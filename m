Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYH2IPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYH2IPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYH2IPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:15:07 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46520 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbYH2IPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:15:03 -0400
Date: Fri, 29 Aug 2008 09:14:52 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
 corruption
In-Reply-To: <48B701FB.2020905@goop.org>
Message-ID: <Pine.LNX.4.64.0808290817190.21494@blonde.site>
References: <48B701FB.2020905@goop.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-652708105-1219997692=:21494"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-652708105-1219997692=:21494
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Thanks for taking this on, Jeremy: I had too many doubts to do so.

On Thu, 28 Aug 2008, Jeremy Fitzhardinge wrote:
> Some BIOSes have been observed to corrupt memory in the low 64k.

hpa introduced the 64k idea, and we've all been repeating it;
but I've not heard the reasoning behind it.  Is it a fundamental
addressing limitation within the BIOS memory model?  Or a case
that Windows treats the bottom 64k as scratch, so BIOS testers
won't notice if they corrupt it?

The two instances of corruption we've been studying have indeed
been below 64k (one in page 8 and one in page 11), but that's
because they were both recognizable corruptions of direct map PMDs.

If there is not a very strong justification for that 64k limit,
then I don't think this approach will be very useful, and we should
simply continue to rely on analyzing corruption when it appears, and
recommend memmap=3D as a way of avoiding it once analyzed.  If there
is a strong justification for it, please dispel my ignorance!

> This patch does two things:
>  - Reserves all memory which does not have to be in that area, to
>    prevent it from being used as general memory by the kernel.  Things
>    like the SMP trampoline are still in the memory, however.
>  - Clears the reserved memory so we can observe changes to it.
>  - Adds a function check_for_bios_corruption() which checks and reports o=
n
>    memory becoming unexpectedly non-zero.  Currently it's called in the
>    x86 fault handler, and the powermanagement debug output.
>=20
> RFC: What other places should we check for corruption in?

I don't know: the easy answer would be just to do it once every minute.
As the patch stands, we'll only learn more on machines going through
suspend+resume (disk or ram).  If the corruption avoidance works,
then the fault case should never trigger.

>=20
> [ Alan, Rafa=C5=82: could you check you see:
>    1: corruption messages
>    2: no crashes
>   Thanks -J
> ]
>=20
> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Cc: Hugh Dickens <hugh@veritas.com>

           Dickins

> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  Documentation/kernel-parameters.txt |    5 ++
>  arch/x86/Kconfig                    |    3 +
>  arch/x86/kernel/setup.c             |   86 +++++++++++++++++++++++++++++=
++++++
>  arch/x86/mm/fault.c                 |    2=20
>  drivers/base/power/main.c           |    1=20
>  include/linux/kernel.h              |   12 ++++
>  6 files changed, 109 insertions(+)
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -359,6 +359,11 @@
>  =09=09=09BayCom Serial Port AX.25 Modem (Half Duplex Mode)
>  =09=09=09Format: <io>,<irq>,<mode>
>  =09=09=09See header of drivers/net/hamradio/baycom_ser_hdx.c.
> +
> +=09bios_corruption_check=3D0/1 [X86]
> +=09=09=09Some BIOSes seem to corrupt the first 64k of memory
> +=09=09=09when doing things like suspend/resume.  Setting this
> +=09=09=09option will scan the memory looking for corruption.

It's actually a bottom_of_memory corruption_check: it would pick
up corruption there whether it's caused by the BIOS or not.
The boot parameter description ought to refer to the config
option: ah, the config option is always on for x86, hmm.

If the 64k is in any doubt, maybe the corruption_check boot option
should specify limiting address rather than just off/on.

> =20
>  =09boot_delay=3D=09Milliseconds to delay each printk during boot.
>  =09=09=09Values larger than 10 seconds (10000) are changed to
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -203,6 +203,9 @@
>  =09bool
>  =09depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
>  =09default y
> +
> +config X86_CHECK_BIOS_CORRUPTION
> +        def_bool y

Always on?  For the moment, perhaps.  I'm very pleased to see you've
set it on for x86_32 as well as for x86_64, I'd been wanting to ask
what's been happening on 32-bit.

> =20
>  config KTIME_SCALAR
>  =09def_bool X86_32
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -582,6 +582,88 @@
>  struct x86_quirks *x86_quirks __initdata =3D &default_x86_quirks;
> =20
>  /*
> + * Some BIOSes seem to corrupt the low 64k of memory during events
> + * like suspend/resume and unplugging an HDMI cable.  Reserve all
> + * remaining free memory in that area and fill it with a distinct
> + * pattern.
> + */
> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
> +#define MAX_SCAN_AREAS=098
> +static struct e820entry scan_areas[MAX_SCAN_AREAS];
> +static int num_scan_areas;
> +
> +static void __init setup_bios_corruption_check(void)
> +{
> +=09u64 addr =3D PAGE_SIZE;=09/* assume first page is reserved anyway */
> +
> +=09while(addr < 0x10000 && num_scan_areas < MAX_SCAN_AREAS) {
> +=09=09u64 size;
> +=09=09addr =3D find_e820_area_size(addr, &size, PAGE_SIZE);
> +
> +=09=09if (addr =3D=3D 0)
> +=09=09=09break;
> +
> +=09=09if ((addr + size) > 0x10000)
> +=09=09=09size =3D 0x10000 - addr;

Here (and the patch description) might be the right place to justify 64k.

> +
> +=09=09if (size =3D=3D 0)
> +=09=09=09break;
> +
> +=09=09e820_update_range(addr, size, E820_RAM, E820_RESERVED);
> +=09=09scan_areas[num_scan_areas].addr =3D addr;
> +=09=09scan_areas[num_scan_areas].size =3D size;
> +=09=09num_scan_areas++;
> +
> +=09=09/* Assume we've already mapped this early memory */
> +=09=09memset(__va(addr), 0, size);
> +
> +=09=09addr +=3D size;
> +=09}
> +
> +=09printk(KERN_INFO "scanning %d areas for BIOS corruption\n",
> +=09       num_scan_areas);
> +=09update_e820();
> +}
> +
> +static int __read_mostly bios_corruption_check =3D 1;
> +
> +void check_for_bios_corruption(void)
> +{
> +=09int i;
> +=09int corruption =3D 0;
> +
> +=09if (!bios_corruption_check)
> +=09=09return;
> +
> +=09for(i =3D 0; i < num_scan_areas; i++) {
> +=09=09unsigned long *addr =3D __va(scan_areas[i].addr);

Small point, but since we're doing the same on 32-bit and 64-bit,
I think it would be better to operate on unsigned ints, to get
the same kind of printout in the two cases.

> +=09=09unsigned long size =3D scan_areas[i].size;
> +
> +=09=09for(; size; addr++, size--) {
> +=09=09=09if (!*addr)
> +=09=09=09=09continue;
> +=09=09=09printk(KERN_ERR "Corrupted low memory at %p (%lx phys) =3D %08l=
x\n",
> +=09=09=09       addr, __pa(addr), *addr);

Don't you need to reset *addr to 0 here, to avoid noise ever after?

> +=09=09=09corruption =3D 1;
> +=09=09}
> +=09}
> +
> +=09if (corruption)
> +=09=09dump_stack();

The purpose of the dump_stack being to insert a recognizable and
irritating spew into the log, prompting people to report these cases:
the stacktrace itself is unlikely to be relevant.  Is a simple
dump_stack enough to get it reported to kerneloops.org, or is
more tweaking necessary?

> +}
> +
> +static int set_bios_corruption_check(char *arg)
> +{
> +=09char *end;
> +
> +=09bios_corruption_check =3D simple_strtol(arg, &end, 10);
> +
> +=09return (*end =3D=3D 0) ? 0 : -EINVAL;
> +}
> +early_param("bios_corruption_check", set_bios_corruption_check);
> +#endif
> +
> +/*
>   * Determine if we were loaded by an EFI loader.  If so, then we have al=
so been
>   * passed the efi memmap, systab, etc., so we should use these data stru=
ctures
>   * for initialization.  Note, the efi init code path is determined by th=
e
> @@ -766,6 +848,10 @@
>  =09=09max_low_pfn =3D max_pfn;
> =20
>  =09high_memory =3D (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> +#endif
> +
> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
> +=09setup_bios_corruption_check();
>  #endif
> =20
>  =09/* max_pfn_mapped is updated here */
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -864,6 +864,8 @@
>   * Oops. The kernel tried to access some bad page. We'll have to
>   * terminate things with extreme prejudice.
>   */
> +=09check_for_bios_corruption();
> +
>  #ifdef CONFIG_X86_32
>  =09bust_spinlocks(1);
>  #else
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -254,6 +254,7 @@
> =20
>  static void pm_dev_dbg(struct device *dev, pm_message_t state, char *inf=
o)
>  {
> +=09check_for_bios_corruption();
>  =09dev_dbg(dev, "%s%s%s\n", info, pm_verb(state.event),
>  =09=09((state.event & PM_EVENT_SLEEP) && device_may_wakeup(dev)) ?
>  =09=09", may wakeup" : "");
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -246,6 +246,18 @@
>  extern void add_taint(unsigned);
>  extern int root_mountflags;
> =20
> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
> +/*
> + * This is obviously not a great place for this, but we want to be
> + * able to scatter it around anywhere in the kernel.
> + */
> +void check_for_bios_corruption(void);
> +#else
> +static inline void check_for_bios_corruption(void)
> +{
> +}
> +#endif
> +
>  /* Values used for system_state */
>  extern enum system_states {
>  =09SYSTEM_BOOTING,

I'll give this or something like it a try on my machines later on,
32 and 64, to see if anything comes up which hasn't caused any
visible problem before (but will either need to do suspend+resume
on machines not tried before, or add in the periodic test).

I do wonder whether for 2.6.27 we should simply go back to the
previous kernel pagetable layout, so there's no regression while
we investigate the issue further.  But I don't recall how well-
defined that layout was, and whether your perturbation was just
in that one patch or not.

Is this the right moment for me to mention again that I'm not sure
your reuse of existing pagetables was quite right anyway: NX being
excluded from level2_ident_pgt, but wanted in the direct map?

Hugh
--8323584-652708105-1219997692=:21494--
