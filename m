Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbYLAQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbYLAQEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYLAQEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:04:40 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:19752 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbYLAQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:04:38 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFAEWaM0lR9cy1/2dsb2JhbACBbc45gn0
Date: Mon, 1 Dec 2008 17:04:21 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Bernhard Walle <bwalle@suse.de>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>,
       Florian Fainelli <florian@openwrt.org>
Subject: [WATCHDOG] v2.6.28 watchdog fixes
Message-ID: <20081201160421.GD1910@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/hpwdt.c               |    5 -
 drivers/watchdog/iTCO_vendor_support.c |   31 ------
 drivers/watchdog/iTCO_wdt.c            |  164 ++++++++++++++++++++-------------
 drivers/watchdog/mtx-1_wdt.c           |    4 
 4 files changed, 116 insertions(+), 88 deletions(-)

with these Changes:

Author: Bernhard Walle <bwalle@suse.de>
Date:   Sun Oct 26 15:59:37 2008 +0100

    [WATCHDOG] hpwdt: Fix kdump when using hpwdt
    
    When the "hpwdt" module is loaded (even if the /dev/watchdog device is not
    opened), then kdump does not work. The panic kernel either does not start at
    all or crash in various places.
    
    The problem is that hpwdt_pretimeout is registered with register_die_notifier()
    with the highest possible priority. Because it returns NOTIFY_STOP, the
    crash_nmi_callback which is also registered with register_die_notifier()
    is never executed. This causes the shutdown of other CPUs to fail.
    
    Reverting the order is no option: The crash_nmi_callback executes HLT
    and so never returns normally. Because of that, it must be executed as
    last notifier, which currently is done.
    
    So, that patch returns NOTIFY_OK to keep the crash_nmi_callback executed.
    
    Signed-off-by: Bernhard Walle <bwalle@suse.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Cc: Vivek Goyal <vgoyal@redhat.com>

Author: Bernhard Walle <bwalle@suse.de>
Date:   Fri Nov 14 15:47:03 2008 +0100

    [WATCHDOG] hpwdt: set the mapped BIOS address space as executable
    
    The address provided by the SMBIOS/DMI CRU information is mapped via
    ioremap() in the virtual address space.  However, since the address is
    executed (i.e.  call'd), we need to set that pages as executable.
    
    Without that, I get following oops on a HP ProLiant DL385 G2
    machine with BIOS from 05/29/2008 when I trigger crashdump:
    
        BUG: unable to handle kernel paging request at ffffc20011090c00
        IP: [<ffffc20011090c00>] 0xffffc20011090c00
        PGD 12f813067 PUD 7fe6a067 PMD 7effe067 PTE 80000000fffd3173
        Oops: 0011 [1] SMP
        last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
        CPU 1
        Modules linked in: autofs4 ipv6 af_packet cpufreq_conservative cpufreq_userspace
         cpufreq_powersave powernow_k8 fuse loop dm_mod rtc_cmos ipmi_si sg rtc_core i2c
        _piix4 ipmi_msghandler bnx2 sr_mod container button i2c_core hpilo joydev pcspkr
         rtc_lib shpchp hpwdt cdrom pci_hotplug usbhid hid ff_memless ohci_hcd ehci_hcd
        uhci_hcd usbcore edd ext3 mbcache jbd fan ide_pci_generic serverworks ide_core p
        ata_serverworks pata_acpi cciss ata_generic libata scsi_mod dock thermal process
        or thermal_sys hwmon
        Supported: Yes
        Pid: 0, comm: swapper Not tainted 2.6.27.5-HEAD_20081111100657-default #1
        RIP: 0010:[<ffffc20011090c00>]  [<ffffc20011090c00>] 0xffffc20011090c00
        RSP: 0018:ffff88012f6f9e68  EFLAGS: 00010046
        RAX: 0000000000000d02 RBX: 0000000000000000 RCX: 0000000000000000
        RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
        RBP: ffff88012f6f9e98 R08: 666666666666660a R09: ffffffffa1006fc0
        R10: 0000000000000000 R11: ffff88012f6f3ea8 R12: ffffc20011090c00
        R13: ffff88012f6f9ee8 R14: 000000000000000e R15: 0000000000000000
        FS:  00007ff70b29a6f0(0000) GS:ffff88012f6512c0(0000) knlGS:0000000000000000
        CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
        CR2: ffffc20011090c00 CR3: 0000000000201000 CR4: 00000000000006e0
        DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
        DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
        Process swapper (pid: 0, threadinfo ffff88012f6f2000, task ffff88007fa8a1c0)
        Stack:  ffffffffa0f8502b 0000000000000002 ffffffff80738d50 0000000000000000
         0000000000000046 0000000000000046 00000000fffffffe ffffffffa0f852ec
         0000000000000000 ffffffff804ad9a6 0000000000000000 0000000000000000
        Call Trace:
        Inexact backtrace:
    
         <NMI>  [<ffffffffa0f8502b>] ? asminline_call+0x2b/0x55 [hpwdt]
         [<ffffffffa0f852ec>] hpwdt_pretimeout+0x3c/0xa0 [hpwdt]
         [<ffffffff804ad9a6>] ? notifier_call_chain+0x29/0x4c
         [<ffffffff802587e4>] ? notify_die+0x2d/0x32
         [<ffffffff804abbdc>] ? default_do_nmi+0x53/0x1d9
         [<ffffffff804abd90>] ? do_nmi+0x2e/0x43
         [<ffffffff804ab552>] ? nmi+0xa2/0xd0
         [<ffffffff80221ef9>] ? native_safe_halt+0x2/0x3
         <<EOE>>  [<ffffffff8021345d>] ? default_idle+0x38/0x54
         [<ffffffff8021359a>] ? c1e_idle+0x118/0x11c
         [<ffffffff8020b3b5>] ? cpu_idle+0xa9/0xf1
    
        Code: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff <55> 50 e8 00 00 00 00 58 48 2d 07 10 40 00 48 8b e8 58 e9 68 02
        RIP  [<ffffc20011090c00>] 0xffffc20011090c00
         RSP <ffff88012f6f9e68>
        CR2: ffffc20011090c00
        Kernel panic - not syncing: Fatal exception
    
    Signed-off-by: Bernhard Walle <bwalle@suse.de>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Ingo Molnar <mingo@elte.hu>
    Acked-by: "H. Peter Anvin" <hpa@zytor.com>
    Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Cc: Alan Cox <alan@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Nov 19 22:25:53 2008 +0000

    [WATCHDOG] iTCO_wdt: add PCI ID's for ICH9 & ICH10 chipsets
    
    Add support for the following I/O controller hubs:
    ICH7DH, ICH9M, ICH9M-E, ICH10, ICH10R, ICH10D and ICH10DO.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Nov 19 20:02:02 2008 +0000

    [WATCHDOG] iTCO_wdt : correct status clearing
    
    The iTCO_wdt code was not clearing the correct bits.
    It now clears the timeout status bit and then the
    SECOND_TO_STS bit and then the BOOT_STS bit.
    Note: we should first clear the SECOND_TO_STS bit
    before clearing the BOOT_STS bit.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Nov 19 19:39:58 2008 +0000

    [WATCHDOG] iTCO_wdt : problem with rebooting on new ICH9 based motherboards
    
    Bugzilla #9868: On Intel motherboards with the ICH9 based I/O controllers
    (Like DP35DP and DG33FB) the iTCO timer counts but it doesn't reboot the
    system after the counter expires.
    
    This patch fixes this by moving the enabling & disabling of the TCO_EN bit
    in the SMI_EN register into the start and stop code.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Florian Fainelli <florian@openwrt.org>
Date:   Fri Oct 24 19:52:56 2008 +0200

    [WATCHDOG] fix mtx1_wdt compilation failure
    
    Using spin_lock_irqsave with a local variable called flags without
    declaring is a bad idea, fix this by declaring it.
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a3765e0..763c1ea 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -40,6 +40,7 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <asm/desc.h>
+#include <asm/cacheflush.h>
 
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
 #define CRU_BIOS_SIGNATURE_VALUE	0x55524324
@@ -394,6 +395,8 @@ static void __devinit dmi_find_cru(const struct dmi_header *dm)
 				smbios_cru64_ptr->double_offset;
 			cru_rom_addr = ioremap(cru_physical_address,
 				smbios_cru64_ptr->double_length);
+			set_memory_x((unsigned long)cru_rom_addr & PAGE_MASK,
+				smbios_cru64_ptr->double_length >> PAGE_SHIFT);
 		}
 	}
 }
@@ -482,7 +485,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 			"Management Log for details.\n");
 	}
 
-	return NOTIFY_STOP;
+	return NOTIFY_OK;
 }
 
 /*
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index ca344a8..2474ebc 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -1,7 +1,7 @@
 /*
  *	intel TCO vendor specific watchdog driver support
  *
- *	(c) Copyright 2006 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2006-2008 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -19,8 +19,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_vendor_support"
-#define DRV_VERSION	"1.01"
-#define DRV_RELDATE	"11-Nov-2006"
+#define DRV_VERSION	"1.02"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -78,24 +77,6 @@ MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default=0 (n
  *	    20.6 seconds.
  */
 
-static void supermicro_old_pre_start(unsigned long acpibase)
-{
-	unsigned long val32;
-
-	val32 = inl(SMI_EN);
-	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
-	outl(val32, SMI_EN);	/* Needed to activate watchdog */
-}
-
-static void supermicro_old_pre_stop(unsigned long acpibase)
-{
-	unsigned long val32;
-
-	val32 = inl(SMI_EN);
-	val32 &= 0x00002000;	/* Turn on SMI clearing watchdog */
-	outl(val32, SMI_EN);	/* Needed to deactivate watchdog */
-}
-
 static void supermicro_old_pre_keepalive(unsigned long acpibase)
 {
 	/* Reload TCO Timer (done in iTCO_wdt_keepalive) + */
@@ -247,18 +228,14 @@ static void supermicro_new_pre_set_heartbeat(unsigned int heartbeat)
 void iTCO_vendor_pre_start(unsigned long acpibase,
 			   unsigned int heartbeat)
 {
-	if (vendorsupport == SUPERMICRO_OLD_BOARD)
-		supermicro_old_pre_start(acpibase);
-	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
+	if (vendorsupport == SUPERMICRO_NEW_BOARD)
 		supermicro_new_pre_start(heartbeat);
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_start);
 
 void iTCO_vendor_pre_stop(unsigned long acpibase)
 {
-	if (vendorsupport == SUPERMICRO_OLD_BOARD)
-		supermicro_old_pre_stop(acpibase);
-	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
+	if (vendorsupport == SUPERMICRO_NEW_BOARD)
 		supermicro_new_pre_stop();
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_stop);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index bfb93bc..26173a2 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -1,7 +1,7 @@
 /*
  *	intel TCO Watchdog Driver (Used in i82801 and i6300ESB chipsets)
  *
- *	(c) Copyright 2006-2007 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2006-2008 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -20,34 +20,41 @@
  *	82801BAM (ICH2-M)    : document number 290687-002, 298242-027,
  *	82801CA  (ICH3-S)    : document number 290733-003, 290739-013,
  *	82801CAM (ICH3-M)    : document number 290716-001, 290718-007,
- *	82801DB  (ICH4)      : document number 290744-001, 290745-020,
- *	82801DBM (ICH4-M)    : document number 252337-001, 252663-005,
+ *	82801DB  (ICH4)      : document number 290744-001, 290745-025,
+ *	82801DBM (ICH4-M)    : document number 252337-001, 252663-008,
  *	82801E   (C-ICH)     : document number 273599-001, 273645-002,
- *	82801EB  (ICH5)      : document number 252516-001, 252517-003,
- *	82801ER  (ICH5R)     : document number 252516-001, 252517-003,
- *	82801FB  (ICH6)      : document number 301473-002, 301474-007,
- *	82801FR  (ICH6R)     : document number 301473-002, 301474-007,
- *	82801FBM (ICH6-M)    : document number 301473-002, 301474-007,
- *	82801FW  (ICH6W)     : document number 301473-001, 301474-007,
- *	82801FRW (ICH6RW)    : document number 301473-001, 301474-007,
- *	82801GB  (ICH7)      : document number 307013-002, 307014-009,
- *	82801GR  (ICH7R)     : document number 307013-002, 307014-009,
- *	82801GDH (ICH7DH)    : document number 307013-002, 307014-009,
- *	82801GBM (ICH7-M)    : document number 307013-002, 307014-009,
- *	82801GHM (ICH7-M DH) : document number 307013-002, 307014-009,
- *	82801HB  (ICH8)      : document number 313056-003, 313057-009,
- *	82801HR  (ICH8R)     : document number 313056-003, 313057-009,
- *	82801HBM (ICH8M)     : document number 313056-003, 313057-009,
- *	82801HH  (ICH8DH)    : document number 313056-003, 313057-009,
- *	82801HO  (ICH8DO)    : document number 313056-003, 313057-009,
- *	82801HEM (ICH8M-E)   : document number 313056-003, 313057-009,
- *	82801IB  (ICH9)      : document number 316972-001, 316973-006,
- *	82801IR  (ICH9R)     : document number 316972-001, 316973-006,
- *	82801IH  (ICH9DH)    : document number 316972-001, 316973-006,
- *	82801IO  (ICH9DO)    : document number 316972-001, 316973-006,
- *	6300ESB  (6300ESB)   : document number 300641-003, 300884-010,
- *	631xESB  (631xESB)   : document number 313082-001, 313075-005,
- *	632xESB  (632xESB)   : document number 313082-001, 313075-005
+ *	82801EB  (ICH5)      : document number 252516-001, 252517-028,
+ *	82801ER  (ICH5R)     : document number 252516-001, 252517-028,
+ *	6300ESB  (6300ESB)   : document number 300641-004, 300884-013,
+ *	82801FB  (ICH6)      : document number 301473-002, 301474-026,
+ *	82801FR  (ICH6R)     : document number 301473-002, 301474-026,
+ *	82801FBM (ICH6-M)    : document number 301473-002, 301474-026,
+ *	82801FW  (ICH6W)     : document number 301473-001, 301474-026,
+ *	82801FRW (ICH6RW)    : document number 301473-001, 301474-026,
+ *	631xESB  (631xESB)   : document number 313082-001, 313075-006,
+ *	632xESB  (632xESB)   : document number 313082-001, 313075-006,
+ *	82801GB  (ICH7)      : document number 307013-003, 307014-024,
+ *	82801GR  (ICH7R)     : document number 307013-003, 307014-024,
+ *	82801GDH (ICH7DH)    : document number 307013-003, 307014-024,
+ *	82801GBM (ICH7-M)    : document number 307013-003, 307014-024,
+ *	82801GHM (ICH7-M DH) : document number 307013-003, 307014-024,
+ *	82801GU  (ICH7-U)    : document number 307013-003, 307014-024,
+ *	82801HB  (ICH8)      : document number 313056-003, 313057-017,
+ *	82801HR  (ICH8R)     : document number 313056-003, 313057-017,
+ *	82801HBM (ICH8M)     : document number 313056-003, 313057-017,
+ *	82801HH  (ICH8DH)    : document number 313056-003, 313057-017,
+ *	82801HO  (ICH8DO)    : document number 313056-003, 313057-017,
+ *	82801HEM (ICH8M-E)   : document number 313056-003, 313057-017,
+ *	82801IB  (ICH9)      : document number 316972-004, 316973-012,
+ *	82801IR  (ICH9R)     : document number 316972-004, 316973-012,
+ *	82801IH  (ICH9DH)    : document number 316972-004, 316973-012,
+ *	82801IO  (ICH9DO)    : document number 316972-004, 316973-012,
+ *	82801IBM (ICH9M)     : document number 316972-004, 316973-012,
+ *	82801IEM (ICH9M-E)   : document number 316972-004, 316973-012,
+ *	82801JIB (ICH10)     : document number 319973-002, 319974-002,
+ *	82801JIR (ICH10R)    : document number 319973-002, 319974-002,
+ *	82801JD  (ICH10D)    : document number 319973-002, 319974-002,
+ *	82801JDO (ICH10DO)   : document number 319973-002, 319974-002
  */
 
 /*
@@ -56,8 +63,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
-#define DRV_VERSION	"1.03"
-#define DRV_RELDATE	"30-Apr-2008"
+#define DRV_VERSION	"1.04"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -96,19 +102,26 @@ enum iTCO_chipsets {
 	TCO_ICH6,	/* ICH6 & ICH6R */
 	TCO_ICH6M,	/* ICH6-M */
 	TCO_ICH6W,	/* ICH6W & ICH6RW */
+	TCO_631XESB,	/* 631xESB/632xESB */
 	TCO_ICH7,	/* ICH7 & ICH7R */
-	TCO_ICH7M,	/* ICH7-M */
+	TCO_ICH7DH,	/* ICH7DH */
+	TCO_ICH7M,	/* ICH7-M & ICH7-U */
 	TCO_ICH7MDH,	/* ICH7-M DH */
 	TCO_ICH8,	/* ICH8 & ICH8R */
-	TCO_ICH8ME,	/* ICH8M-E */
 	TCO_ICH8DH,	/* ICH8DH */
 	TCO_ICH8DO,	/* ICH8DO */
 	TCO_ICH8M,	/* ICH8M */
+	TCO_ICH8ME,	/* ICH8M-E */
 	TCO_ICH9,	/* ICH9 */
 	TCO_ICH9R,	/* ICH9R */
 	TCO_ICH9DH,	/* ICH9DH */
 	TCO_ICH9DO,	/* ICH9DO */
-	TCO_631XESB,	/* 631xESB/632xESB */
+	TCO_ICH9M,	/* ICH9M */
+	TCO_ICH9ME,	/* ICH9M-E */
+	TCO_ICH10,	/* ICH10 */
+	TCO_ICH10R,	/* ICH10R */
+	TCO_ICH10D,	/* ICH10D */
+	TCO_ICH10DO,	/* ICH10DO */
 };
 
 static struct {
@@ -129,19 +142,26 @@ static struct {
 	{"ICH6 or ICH6R", 2},
 	{"ICH6-M", 2},
 	{"ICH6W or ICH6RW", 2},
+	{"631xESB/632xESB", 2},
 	{"ICH7 or ICH7R", 2},
-	{"ICH7-M", 2},
+	{"ICH7DH", 2},
+	{"ICH7-M or ICH7-U", 2},
 	{"ICH7-M DH", 2},
 	{"ICH8 or ICH8R", 2},
-	{"ICH8M-E", 2},
 	{"ICH8DH", 2},
 	{"ICH8DO", 2},
 	{"ICH8M", 2},
+	{"ICH8M-E", 2},
 	{"ICH9", 2},
 	{"ICH9R", 2},
 	{"ICH9DH", 2},
 	{"ICH9DO", 2},
-	{"631xESB/632xESB", 2},
+	{"ICH9M", 2},
+	{"ICH9M-E", 2},
+	{"ICH10", 2},
+	{"ICH10R", 2},
+	{"ICH10D", 2},
+	{"ICH10DO", 2},
 	{NULL, 0}
 };
 
@@ -175,18 +195,6 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M)},
-	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9)},
-	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,		TCO_ICH9DO)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
@@ -203,6 +211,25 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x267d,				TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x267e,				TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x267f,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_30,		TCO_ICH7DH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME)},
+	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9)},
+	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,		TCO_ICH9DO)},
+	{ ITCO_PCI_DEVICE(0x2919,				TCO_ICH9M)},
+	{ ITCO_PCI_DEVICE(0x2917,				TCO_ICH9ME)},
+	{ ITCO_PCI_DEVICE(0x3a18,				TCO_ICH10)},
+	{ ITCO_PCI_DEVICE(0x3a16,				TCO_ICH10R)},
+	{ ITCO_PCI_DEVICE(0x3a1a,				TCO_ICH10D)},
+	{ ITCO_PCI_DEVICE(0x3a14,				TCO_ICH10DO)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
@@ -311,6 +338,7 @@ static int iTCO_wdt_unset_NO_REBOOT_bit(void)
 static int iTCO_wdt_start(void)
 {
 	unsigned int val;
+	unsigned long val32;
 
 	spin_lock(&iTCO_wdt_private.io_lock);
 
@@ -323,6 +351,18 @@ static int iTCO_wdt_start(void)
 		return -EIO;
 	}
 
+	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
+	val32 = inl(SMI_EN);
+	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
+	outl(val32, SMI_EN);
+
+	/* Force the timer to its reload value by writing to the TCO_RLD
+	   register */
+	if (iTCO_wdt_private.iTCO_version == 2)
+		outw(0x01, TCO_RLD);
+	else if (iTCO_wdt_private.iTCO_version == 1)
+		outb(0x01, TCO_RLD);
+
 	/* Bit 11: TCO Timer Halt -> 0 = The TCO timer is enabled to count */
 	val = inw(TCO1_CNT);
 	val &= 0xf7ff;
@@ -338,6 +378,7 @@ static int iTCO_wdt_start(void)
 static int iTCO_wdt_stop(void)
 {
 	unsigned int val;
+	unsigned long val32;
 
 	spin_lock(&iTCO_wdt_private.io_lock);
 
@@ -349,6 +390,11 @@ static int iTCO_wdt_stop(void)
 	outw(val, TCO1_CNT);
 	val = inw(TCO1_CNT);
 
+	/* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI# */
+	val32 = inl(SMI_EN);
+	val32 &= 0x00002000;
+	outl(val32, SMI_EN);
+
 	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
 	iTCO_wdt_set_NO_REBOOT_bit();
 
@@ -459,7 +505,6 @@ static int iTCO_wdt_open(struct inode *inode, struct file *file)
 	/*
 	 *      Reload and activate timer
 	 */
-	iTCO_wdt_keepalive();
 	iTCO_wdt_start();
 	return nonseekable_open(inode, file);
 }
@@ -604,7 +649,6 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	int ret;
 	u32 base_address;
 	unsigned long RCBA;
-	unsigned long val32;
 
 	/*
 	 *      Find the ACPI/PM base I/O address which is the base
@@ -644,17 +688,13 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
 	iTCO_wdt_set_NO_REBOOT_bit();
 
-	/* Set the TCO_EN bit in SMI_EN register */
+	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
 	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
 		printk(KERN_ERR PFX
 			"I/O address 0x%04lx already in use\n", SMI_EN);
 		ret = -EIO;
 		goto out;
 	}
-	val32 = inl(SMI_EN);
-	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
-	outl(val32, SMI_EN);
-	release_region(SMI_EN, 4);
 
 	/* The TCO I/O registers reside in a 32-byte range pointed to
 	   by the TCOBASE value */
@@ -662,7 +702,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 		printk(KERN_ERR PFX "I/O address 0x%04lx already in use\n",
 			TCOBASE);
 		ret = -EIO;
-		goto out;
+		goto unreg_smi_en;
 	}
 
 	printk(KERN_INFO PFX
@@ -672,8 +712,9 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 			TCOBASE);
 
 	/* Clear out the (probably old) status */
-	outb(0, TCO1_STS);
-	outb(3, TCO2_STS);
+	outb(8, TCO1_STS);	/* Clear the Time Out Status bit */
+	outb(2, TCO2_STS);	/* Clear SECOND_TO_STS bit */
+	outb(4, TCO2_STS);	/* Clear BOOT_STS bit */
 
 	/* Make sure the watchdog is not running */
 	iTCO_wdt_stop();
@@ -701,6 +742,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 unreg_region:
 	release_region(TCOBASE, 0x20);
+unreg_smi_en:
+	release_region(SMI_EN, 4);
 out:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
@@ -718,6 +761,7 @@ static void __devexit iTCO_wdt_cleanup(void)
 	/* Deregister */
 	misc_deregister(&iTCO_wdt_miscdev);
 	release_region(TCOBASE, 0x20);
+	release_region(SMI_EN, 4);
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
 	pci_dev_put(iTCO_wdt_private.pdev);
@@ -782,8 +826,8 @@ static int __init iTCO_wdt_init_module(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "Intel TCO WatchDog Timer Driver v%s (%s)\n",
-		DRV_VERSION, DRV_RELDATE);
+	printk(KERN_INFO PFX "Intel TCO WatchDog Timer Driver v%s\n",
+		DRV_VERSION);
 
 	err = platform_driver_register(&iTCO_wdt_driver);
 	if (err)
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index b4b7b0a..3acce62 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -98,6 +98,8 @@ static void mtx1_wdt_reset(void)
 
 static void mtx1_wdt_start(void)
 {
+	unsigned long flags;
+
 	spin_lock_irqsave(&mtx1_wdt_device.lock, flags);
 	if (!mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 1;
@@ -110,6 +112,8 @@ static void mtx1_wdt_start(void)
 
 static int mtx1_wdt_stop(void)
 {
+	unsigned long flags;
+
 	spin_lock_irqsave(&mtx1_wdt_device.lock, flags);
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
