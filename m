Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYH2NVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYH2NVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYH2NVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:21:48 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33637 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbYH2NVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:21:47 -0400
Date: Fri, 29 Aug 2008 14:21:34 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
 corruption
In-Reply-To: <48B7E6EE.9090901@tuffmail.co.uk>
Message-ID: <Pine.LNX.4.64.0808291413260.12571@blonde.site>
References: <48B701FB.2020905@goop.org>  <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
  <48B76CE0.5010309@goop.org>  <20080829102547.655440bf@lxorguk.ukuu.org.uk>
  <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com> 
 <Pine.LNX.4.64.0808291120540.8561@blonde.site>
 <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com>
 <48B7E6EE.9090901@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1843234723-1220016094=:12571"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1843234723-1220016094=:12571
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 29 Aug 2008, Alan Jenkins wrote:
> Rafa=C5=82 Mi=C5=82ecki wrote:
> >
> > I tried your patch anyway (after applying Jeremy's patch of course)
> > and it doesn't seem to work. The only output is:
> > scanning 2 areas for BIOS corruption
> > after using s2ram. I do not get any
> > Corrupted low memory at*
> >  =20
> It seemed to work for me.  Did you remember to plug HDMI to trigger the
> corruption before you used s2ram?

I hope that's what got missed.

Here's my version of Jeremy's patch, that I've now tested on my machines,
as x86_32 and as x86_64.  It addresses none of the points Alan Cox made,
and it stays silent for me, even after suspend+resume, unless I actually
introduce corruption myself.  Omits Jeremy's check in fault.c, but does
a check every minute, so should soon detect Rafa=C5=82's HDMI corruption
without any need to suspend+resume.

Hugh

--- 2.6.27-rc5/Documentation/kernel-parameters.txt=092008-08-29 01:02:34.00=
0000000 +0100
+++ linux/Documentation/kernel-parameters.txt=092008-08-29 11:17:16.0000000=
00 +0100
@@ -360,6 +360,11 @@ and is between 256 and 4096 characters.=20
 =09=09=09Format: <io>,<irq>,<mode>
 =09=09=09See header of drivers/net/hamradio/baycom_ser_hdx.c.
=20
+=09bios_corruption_check=3D0/1 [X86]
+=09=09=09Some BIOSes seem to corrupt the first 64k of memory
+=09=09=09when doing things like suspend/resume.  Setting this
+=09=09=09option will scan the memory looking for corruption.
+
 =09boot_delay=3D=09Milliseconds to delay each printk during boot.
 =09=09=09Values larger than 10 seconds (10000) are changed to
 =09=09=09no delay (0).
--- 2.6.27-rc5/arch/x86/Kconfig=092008-08-29 01:02:35.000000000 +0100
+++ linux/arch/x86/Kconfig=092008-08-29 11:17:16.000000000 +0100
@@ -201,6 +201,9 @@ config X86_TRAMPOLINE
 =09depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
 =09default y
=20
+config X86_CHECK_BIOS_CORRUPTION
+        def_bool y
+
 config KTIME_SCALAR
 =09def_bool X86_32
 source "init/Kconfig"
--- 2.6.27-rc5/arch/x86/kernel/setup.c=092008-08-29 01:02:35.000000000 +010=
0
+++ linux/arch/x86/kernel/setup.c=092008-08-29 13:50:19.000000000 +0100
@@ -579,6 +579,106 @@ static struct x86_quirks default_x86_qui
 struct x86_quirks *x86_quirks __initdata =3D &default_x86_quirks;
=20
 /*
+ * Some BIOSes seem to corrupt the low 64k of memory during events
+ * like suspend/resume and unplugging an HDMI cable.  Reserve all
+ * remaining free memory in that area and fill it with a distinct
+ * pattern.
+ */
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+#define MAX_SCAN_AREAS=098
+static struct e820entry scan_areas[MAX_SCAN_AREAS];
+static int num_scan_areas;
+
+static void __init setup_bios_corruption_check(void)
+{
+=09u64 addr =3D PAGE_SIZE;=09/* assume first page is reserved anyway */
+
+=09while (addr < 0x10000 && num_scan_areas < MAX_SCAN_AREAS) {
+=09=09u64 size;
+=09=09addr =3D find_e820_area_size(addr, &size, PAGE_SIZE);
+
+=09=09if (addr =3D=3D 0)
+=09=09=09break;
+
+=09=09if ((addr + size) > 0x10000)
+=09=09=09size =3D 0x10000 - addr;
+
+=09=09if (size =3D=3D 0)
+=09=09=09break;
+
+=09=09e820_update_range(addr, size, E820_RAM, E820_RESERVED);
+=09=09scan_areas[num_scan_areas].addr =3D addr;
+=09=09scan_areas[num_scan_areas].size =3D size;
+=09=09num_scan_areas++;
+
+=09=09/* Assume we've already mapped this early memory */
+=09=09memset(__va(addr), 0, size);
+
+=09=09addr +=3D size;
+=09}
+
+=09printk(KERN_INFO "scanning %d areas for BIOS corruption\n",
+=09       num_scan_areas);
+=09update_e820();
+}
+
+static int __read_mostly bios_corruption_check =3D 1;
+static struct timer_list periodic_check_timer;
+
+void check_for_bios_corruption(void)
+{
+=09int i;
+=09int corruption =3D 0;
+
+=09if (!bios_corruption_check)
+=09=09return;
+
+=09for (i =3D 0; i < num_scan_areas; i++) {
+=09=09unsigned int *addr =3D __va(scan_areas[i].addr);
+=09=09unsigned long size =3D scan_areas[i].size;
+
+=09=09for (; size; addr++, size -=3D sizeof(unsigned int)) {
+=09=09=09if (!*addr)
+=09=09=09=09continue;
+=09=09=09printk(KERN_ERR "Corrupted low memory at %p (%lx phys) =3D %08x\n=
",
+=09=09=09       addr, __pa(addr), *addr);
+=09=09=09*addr =3D 0;
+=09=09=09corruption =3D 1;
+=09=09}
+=09}
+
+=09if (corruption)
+=09=09dump_stack();
+}
+
+static void periodic_check_for_corruption(unsigned long data)
+{
+=09check_for_bios_corruption();
+=09mod_timer(&periodic_check_timer, jiffies + 60*HZ);
+}
+
+void start_periodic_check_for_corruption(void)
+{
+=09if (!bios_corruption_check)
+=09=09return;
+
+=09init_timer(&periodic_check_timer);
+=09periodic_check_timer.function =3D &periodic_check_for_corruption;
+=09periodic_check_for_corruption(0);
+}
+
+static int set_bios_corruption_check(char *arg)
+{
+=09char *end;
+
+=09bios_corruption_check =3D simple_strtol(arg, &end, 10);
+
+=09return (*end =3D=3D 0) ? 0 : -EINVAL;
+}
+early_param("bios_corruption_check", set_bios_corruption_check);
+#endif
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also=
 been
  * passed the efi memmap, systab, etc., so we should use these data struct=
ures
  * for initialization.  Note, the efi init code path is determined by the
@@ -750,6 +850,10 @@ void __init setup_arch(char **cmdline_p)
 =09high_memory =3D (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
 #endif
=20
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+=09setup_bios_corruption_check();
+#endif
+
 =09/* max_pfn_mapped is updated here */
 =09max_low_pfn_mapped =3D init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 =09max_pfn_mapped =3D max_low_pfn_mapped;
--- 2.6.27-rc5/arch/x86/mm/init_32.c=092008-07-29 04:24:15.000000000 +0100
+++ linux/arch/x86/mm/init_32.c=092008-08-29 11:52:21.000000000 +0100
@@ -907,6 +907,8 @@ void __init mem_init(void)
 =09int codesize, reservedpages, datasize, initsize;
 =09int tmp;
=20
+=09start_periodic_check_for_corruption();
+
 #ifdef CONFIG_FLATMEM
 =09BUG_ON(!mem_map);
 #endif
--- 2.6.27-rc5/arch/x86/mm/init_64.c=092008-08-29 01:02:35.000000000 +0100
+++ linux/arch/x86/mm/init_64.c=092008-08-29 11:53:09.000000000 +0100
@@ -769,6 +769,8 @@ void __init mem_init(void)
 {
 =09long codesize, reservedpages, datasize, initsize;
=20
+=09start_periodic_check_for_corruption();
+
 =09pci_iommu_alloc();
=20
 =09/* clear_bss() already clear the empty_zero_page */
--- 2.6.27-rc5/drivers/base/power/main.c=092008-08-29 01:02:35.000000000 +0=
100
+++ linux/drivers/base/power/main.c=092008-08-29 11:17:16.000000000 +0100
@@ -254,6 +254,7 @@ static char *pm_verb(int event)
=20
 static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
 {
+=09check_for_bios_corruption();
 =09dev_dbg(dev, "%s%s%s\n", info, pm_verb(state.event),
 =09=09((state.event & PM_EVENT_SLEEP) && device_may_wakeup(dev)) ?
 =09=09", may wakeup" : "");
--- 2.6.27-rc5/include/linux/kernel.h=092008-08-13 04:14:50.000000000 +0100
+++ linux/include/linux/kernel.h=092008-08-29 11:49:23.000000000 +0100
@@ -240,6 +240,22 @@ extern const char *print_tainted(void);
 extern void add_taint(unsigned);
 extern int root_mountflags;
=20
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+/*
+ * This is obviously not a great place for this, but we want to be
+ * able to scatter it around anywhere in the kernel.
+ */
+void check_for_bios_corruption(void);
+void start_periodic_check_for_corruption(void);
+#else
+static inline void check_for_bios_corruption(void)
+{
+}
+static inline void start_periodic_check_for_corruption(void)
+{
+}
+#endif
+
 /* Values used for system_state */
 extern enum system_states {
 =09SYSTEM_BOOTING,
--8323584-1843234723-1220016094=:12571--
