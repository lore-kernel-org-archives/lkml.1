Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbYLAQgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbYLAQgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYLAQgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:36:15 -0500
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:48102 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbYLAQgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:36:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=iAKzxHPcnCQ9IGezrUUjW/8kJ6LNS5vyFfwZ3ODaeeBhDzzXPCHpFIdqDTlWGz6D;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4934127A.5080503@earthlink.net>
Date: Mon, 01 Dec 2008 11:36:10 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] v2.6.28 watchdog fixes
References: <20081201160421.GD1910@infomag.infomag.iguana.be>
In-Reply-To: <20081201160421.GD1910@infomag.infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec799752b62cccf59780e71d35edfcb25df9350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck wrote:
> Hi Linus,
> 
> Please pull from 'master' branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> or if master.kernel.org hasn't synced up yet:
> 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> 
> This will update the following files:
> 
>  drivers/watchdog/hpwdt.c               |    5 -
>  drivers/watchdog/iTCO_vendor_support.c |   31 ------
>  drivers/watchdog/iTCO_wdt.c            |  164 ++++++++++++++++++++-------------
>  drivers/watchdog/mtx-1_wdt.c           |    4 
>  4 files changed, 116 insertions(+), 88 deletions(-)
> 
> with these Changes:
> 
> Author: Bernhard Walle <bwalle@suse.de>
> Date:   Sun Oct 26 15:59:37 2008 +0100
> 
>     [WATCHDOG] hpwdt: Fix kdump when using hpwdt
>     
>     When the "hpwdt" module is loaded (even if the /dev/watchdog device is not
>     opened), then kdump does not work. The panic kernel either does not start at
>     all or crash in various places.
>     
>     The problem is that hpwdt_pretimeout is registered with register_die_notifier()
>     with the highest possible priority. Because it returns NOTIFY_STOP, the
>     crash_nmi_callback which is also registered with register_die_notifier()
>     is never executed. This causes the shutdown of other CPUs to fail.
>     
>     Reverting the order is no option: The crash_nmi_callback executes HLT
>     and so never returns normally. Because of that, it must be executed as
>     last notifier, which currently is done.
>     
>     So, that patch returns NOTIFY_OK to keep the crash_nmi_callback executed.
>     
>     Signed-off-by: Bernhard Walle <bwalle@suse.de>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
>     Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
>     Cc: Vivek Goyal <vgoyal@redhat.com>
> 
> Author: Bernhard Walle <bwalle@suse.de>
> Date:   Fri Nov 14 15:47:03 2008 +0100
> 
>     [WATCHDOG] hpwdt: set the mapped BIOS address space as executable
>     
>     The address provided by the SMBIOS/DMI CRU information is mapped via
>     ioremap() in the virtual address space.  However, since the address is
>     executed (i.e.  call'd), we need to set that pages as executable.
>     
>     Without that, I get following oops on a HP ProLiant DL385 G2
>     machine with BIOS from 05/29/2008 when I trigger crashdump:
>     
>         BUG: unable to handle kernel paging request at ffffc20011090c00
>         IP: [<ffffc20011090c00>] 0xffffc20011090c00
>         PGD 12f813067 PUD 7fe6a067 PMD 7effe067 PTE 80000000fffd3173
>         Oops: 0011 [1] SMP
>         last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
>         CPU 1
>         Modules linked in: autofs4 ipv6 af_packet cpufreq_conservative cpufreq_userspace
>          cpufreq_powersave powernow_k8 fuse loop dm_mod rtc_cmos ipmi_si sg rtc_core i2c
>         _piix4 ipmi_msghandler bnx2 sr_mod container button i2c_core hpilo joydev pcspkr
>          rtc_lib shpchp hpwdt cdrom pci_hotplug usbhid hid ff_memless ohci_hcd ehci_hcd
>         uhci_hcd usbcore edd ext3 mbcache jbd fan ide_pci_generic serverworks ide_core p
>         ata_serverworks pata_acpi cciss ata_generic libata scsi_mod dock thermal process
>         or thermal_sys hwmon
>         Supported: Yes
>         Pid: 0, comm: swapper Not tainted 2.6.27.5-HEAD_20081111100657-default #1
>         RIP: 0010:[<ffffc20011090c00>]  [<ffffc20011090c00>] 0xffffc20011090c00
>         RSP: 0018:ffff88012f6f9e68  EFLAGS: 00010046
>         RAX: 0000000000000d02 RBX: 0000000000000000 RCX: 0000000000000000
>         RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>         RBP: ffff88012f6f9e98 R08: 666666666666660a R09: ffffffffa1006fc0
>         R10: 0000000000000000 R11: ffff88012f6f3ea8 R12: ffffc20011090c00
>         R13: ffff88012f6f9ee8 R14: 000000000000000e R15: 0000000000000000
>         FS:  00007ff70b29a6f0(0000) GS:ffff88012f6512c0(0000) knlGS:0000000000000000
>         CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>         CR2: ffffc20011090c00 CR3: 0000000000201000 CR4: 00000000000006e0
>         DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>         DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>         Process swapper (pid: 0, threadinfo ffff88012f6f2000, task ffff88007fa8a1c0)
>         Stack:  ffffffffa0f8502b 0000000000000002 ffffffff80738d50 0000000000000000
>          0000000000000046 0000000000000046 00000000fffffffe ffffffffa0f852ec
>          0000000000000000 ffffffff804ad9a6 0000000000000000 0000000000000000
>         Call Trace:
>         Inexact backtrace:
>     
>          <NMI>  [<ffffffffa0f8502b>] ? asminline_call+0x2b/0x55 [hpwdt]
>          [<ffffffffa0f852ec>] hpwdt_pretimeout+0x3c/0xa0 [hpwdt]
>          [<ffffffff804ad9a6>] ? notifier_call_chain+0x29/0x4c
>          [<ffffffff802587e4>] ? notify_die+0x2d/0x32
>          [<ffffffff804abbdc>] ? default_do_nmi+0x53/0x1d9
>          [<ffffffff804abd90>] ? do_nmi+0x2e/0x43
>          [<ffffffff804ab552>] ? nmi+0xa2/0xd0
>          [<ffffffff80221ef9>] ? native_safe_halt+0x2/0x3
>          <<EOE>>  [<ffffffff8021345d>] ? default_idle+0x38/0x54
>          [<ffffffff8021359a>] ? c1e_idle+0x118/0x11c
>          [<ffffffff8020b3b5>] ? cpu_idle+0xa9/0xf1
>     
>         Code: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff <55> 50 e8 00 00 00 00 58 48 2d 07 10 40 00 48 8b e8 58 e9 68 02
>         RIP  [<ffffc20011090c00>] 0xffffc20011090c00
>          RSP <ffff88012f6f9e68>
>         CR2: ffffc20011090c00
>         Kernel panic - not syncing: Fatal exception
>     
>     Signed-off-by: Bernhard Walle <bwalle@suse.de>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Acked-by: "H. Peter Anvin" <hpa@zytor.com>
>     Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
>     Cc: Alan Cox <alan@redhat.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Wed Nov 19 22:25:53 2008 +0000
> 
>     [WATCHDOG] iTCO_wdt: add PCI ID's for ICH9 & ICH10 chipsets
>     
>     Add support for the following I/O controller hubs:
>     ICH7DH, ICH9M, ICH9M-E, ICH10, ICH10R, ICH10D and ICH10DO.
>     
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Wed Nov 19 20:02:02 2008 +0000
> 
>     [WATCHDOG] iTCO_wdt : correct status clearing
>     
>     The iTCO_wdt code was not clearing the correct bits.
>     It now clears the timeout status bit and then the
>     SECOND_TO_STS bit and then the BOOT_STS bit.
>     Note: we should first clear the SECOND_TO_STS bit
>     before clearing the BOOT_STS bit.
>     
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Wed Nov 19 19:39:58 2008 +0000
> 
>     [WATCHDOG] iTCO_wdt : problem with rebooting on new ICH9 based motherboards
>     
>     Bugzilla #9868: On Intel motherboards with the ICH9 based I/O controllers
>     (Like DP35DP and DG33FB) the iTCO timer counts but it doesn't reboot the
>     system after the counter expires.
Thanks Wim,

can't wait to try this on my DG33FB, now if I could only get WOL to work
on the integrated NIC, life would be fine.
<..big snip..>

Regards,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


