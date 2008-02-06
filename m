Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbYBFLPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbYBFLPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYBFLPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:15:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34516 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYBFLPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:15:46 -0500
Date: Wed, 6 Feb 2008 12:15:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1
Message-ID: <20080206111524.GA13264@elte.hu>
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <2f11576a0802060313k3f17547ev4d2643c3a130f59f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0802060313k3f17547ev4d2643c3a130f59f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Ingo,
> 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/
> >
> >
> > - The x86 git tree has been dropped due to runtime failure on one of my test
> >   machines
> 
> My PC display warning message at boot time.
> Could I help your debugging?
> 
> ----------------------------------------------------------------------------------------------
> 
> end_request: I/O error, dev fd0, sector 0
>                 Welcome to  CentOS release 5 (Final)
>                 Press 'I' to enter interactive startup.
> ------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2037 _spin_unlock_irq+0x20/0x23()
> Modules linked in: usb_storage ahci ata_piix libata ehci_hcd ohci_hcd uhci_hcd
> Pid: 1085, comm: hwclock Not tainted 2.6.24-mm1 #1
>  [<c011e75f>] warn_on_slowpath+0x40/0x4f
>  [<c012cc1b>] __kernel_text_address+0x18/0x23
>  [<c0105710>] dump_trace+0xb3/0xbd
>  [<c0137bd1>] check_usage_forwards+0x16/0x35
>  [<c0137d5d>] mark_lock+0x16d/0x389
>  [<c03ed8f2>] _spin_unlock_irq+0x20/0x23
>  [<c0114675>] hpet_rtc_interrupt+0xe6/0x2a7
>  [<c014582b>] handle_IRQ_event+0x13/0x3d
>  [<c01466d6>] handle_edge_irq+0xc2/0xff
>  [<c010664a>] do_IRQ+0x6e/0x84
>  [<c010516e>] common_interrupt+0x2e/0x34
>  [<c03e007b>] nv_probe+0x1281/0x13bc
>  [<c03ef010>] do_page_fault+0x15f/0x4ae
>  [<c03eeeb1>] do_page_fault+0x0/0x4ae
>  [<c03edb62>] error_code+0x72/0x78
>  =======================
> ---[ end trace 908d580e4399e39b ]---

should be fixed by the commit below. (already upstream)

	Ingo

-------------->
commit 795d45b22c079946332bf3825afefe5a981a97b6
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Feb 4 16:48:10 2008 +0100

    x86: fix RTC lockdep warning: potential hardirq recursion
    
    After disabling both CONFIG_DEBUG_LOCKING_API_SELFTESTS and netconsole
    (using current mainline) I get a login prompt, and also...
    
    [    5.181668] SELinux: policy loaded with handle_unknown=deny
    [    5.183315] type=1403 audit(1202100038.157:3): policy loaded auid=4294967295 ses=4294967295
    [    5.822073] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
    [    7.819146] ------------[ cut here ]------------
    [    7.819146] WARNING: at kernel/lockdep.c:2033 trace_hardirqs_on+0x9b/0x10d()
    [    7.819146] Modules linked in: generic ext3 jbd ide_disk ide_core
    [    7.819146] Pid: 399, comm: hwclock Not tainted 2.6.24 #4
    [    7.819146]  [<c011d140>] warn_on_slowpath+0x41/0x51
    [    7.819146]  [<c01364a9>] ? lock_release_holdtime+0x50/0x56
    [    7.819146]  [<c013770c>] ? check_usage_forwards+0x19/0x3b
    [    7.819146]  [<c01390c4>] ? __lock_acquire+0xac3/0xb0b
    [    7.819146]  [<c0108c98>] ? native_sched_clock+0x8b/0x9f
    [    7.819146]  [<c01364a9>] ? lock_release_holdtime+0x50/0x56
    [    7.819146]  [<c030ca6c>] ? _spin_unlock_irq+0x22/0x42
    [    7.819146]  [<c013848b>] trace_hardirqs_on+0x9b/0x10d
    [    7.819146]  [<c030ca6c>] _spin_unlock_irq+0x22/0x42
    [    7.819146]  [<c011481e>] hpet_rtc_interrupt+0xdf/0x290
    [    7.819146]  [<c014ea90>] handle_IRQ_event+0x1a/0x46
    [    7.819146]  [<c014f8ea>] handle_edge_irq+0xbe/0xff
    [    7.819146]  [<c0106e08>] do_IRQ+0x6d/0x84
    [    7.819146]  [<c0105596>] common_interrupt+0x2e/0x34
    [    7.819146]  [<c013007b>] ? ktime_get_ts+0x8/0x3f
    [    7.819146]  [<c0139420>] ? lock_release+0x167/0x16f
    [    7.819146]  [<c017974a>] ? core_sys_select+0x2c/0x327
    [    7.819146]  [<c0179792>] core_sys_select+0x74/0x327
    [    7.819146]  [<c0108c98>] ? native_sched_clock+0x8b/0x9f
    [    7.819146]  [<c01364a9>] ? lock_release_holdtime+0x50/0x56
    [    7.819146]  [<c030ca6c>] ? _spin_unlock_irq+0x22/0x42
    [    7.819146]  [<c01384d6>] ? trace_hardirqs_on+0xe6/0x10d
    [    7.819146]  [<c030ca77>] ? _spin_unlock_irq+0x2d/0x42
    [    7.819146]  [<c023b437>] ? rtc_do_ioctl+0x11b/0x677
    [    7.819146]  [<c01c487e>] ? inode_has_perm+0x5e/0x68
    [    7.819146]  [<c01364a9>] ? lock_release_holdtime+0x50/0x56
    [    7.819146]  [<c0108c98>] ? native_sched_clock+0x8b/0x9f
    [    7.819146]  [<c01c490b>] ? file_has_perm+0x83/0x8c
    [    7.819146]  [<c023ba08>] ? rtc_ioctl+0xf/0x11
    [    7.819146]  [<c017898d>] ? do_ioctl+0x55/0x67
    [    7.819146]  [<c0179d15>] sys_select+0x93/0x163
    [    7.819146]  [<c0104b39>] ? sysenter_past_esp+0x9a/0xa5
    [    7.819146]  [<c0104afe>] sysenter_past_esp+0x5f/0xa5
    [    7.819146]  =======================
    [    7.819146] ---[ end trace 96540ca301ffb84c ]---
    [    7.819210] rtc: lost 6 interrupts
    [    7.870668] type=1400 audit(1202128840.794:4): avc:  denied  { audit_write } for  pid=399 comm="hwclock" capability=29 scontext=system_u:system_r:hwclock_t:s0 tcontext=system_u:system_r:hwclock_t:s0 tclass=capability
    [    9.538866] input: PC Speaker as /class/input/input5
    
    Because hpet_rtc_interrupt()'s call to get_rtc_time() ends up
    resolving to include/asm-generic/rtc.h's (hilariously inlined)
    get_rtc_time(), which does spin_unlock_irq() from hard IRQ context.
    
    The obvious patch fixes it.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index d3238f1..dd1bed8 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -35,10 +35,11 @@
 static inline unsigned char rtc_is_updating(void)
 {
 	unsigned char uip;
+	unsigned long flags;
 
-	spin_lock_irq(&rtc_lock);
+	spin_lock_irqsave(&rtc_lock, flags);
 	uip = (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP);
-	spin_unlock_irq(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 	return uip;
 }
 
@@ -46,6 +47,8 @@ static inline unsigned int get_rtc_time(struct rtc_time *time)
 {
 	unsigned long uip_watchdog = jiffies;
 	unsigned char ctrl;
+	unsigned long flags;
+
 #ifdef CONFIG_MACH_DECSTATION
 	unsigned int real_year;
 #endif
@@ -72,7 +75,7 @@ static inline unsigned int get_rtc_time(struct rtc_time *time)
 	 * RTC has RTC_DAY_OF_WEEK, we ignore it, as it is only updated
 	 * by the RTC when initially set to a non-zero value.
 	 */
-	spin_lock_irq(&rtc_lock);
+	spin_lock_irqsave(&rtc_lock, flags);
 	time->tm_sec = CMOS_READ(RTC_SECONDS);
 	time->tm_min = CMOS_READ(RTC_MINUTES);
 	time->tm_hour = CMOS_READ(RTC_HOURS);
@@ -83,7 +86,7 @@ static inline unsigned int get_rtc_time(struct rtc_time *time)
 	real_year = CMOS_READ(RTC_DEC_YEAR);
 #endif
 	ctrl = CMOS_READ(RTC_CONTROL);
-	spin_unlock_irq(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
 	{
