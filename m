Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbXEIRh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbXEIRh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 13:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbXEIRhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 13:37:48 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbXEIRhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 13:37:47 -0400
Date: Wed, 9 May 2007 10:37:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - hanging with initcall_debug and netconsole
Message-Id: <20070509103720.76ed6a99.akpm@linux-foundation.org>
In-Reply-To: <6257.1178729509@turing-police.cc.vt.edu>
References: <20070509012322.199f292b.akpm@linux-foundation.org>
	<6257.1178729509@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 12:51:49 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/
> 
> So I have a canned grub config for booting with netconsole, initcall_debug, and
> all that fun stuff.  Tried it on 21-mm2, and it wedged up hard here:
> 
> [   66.842587] TCP: Hash tables configured (established 131072 bind 65536)
> [   66.842591] TCP reno registered
> [   66.845424] initcall 0xffffffff806ff7c6: inet_init+0x0/0x34d() returned 0.
> [   66.845437] initcall 0xffffffff806ff7c6 ran for 14 msecs: inet_init+0x0/0x34d()
> [   66.845443] Calling initcall 0xffffffff806e28eb: populate_rootfs+0x0/0xea()
> [   66.845566] checking if image is initramfs... it is
> [   66.978816] Freeing initrd memory: 1824k freed
> [   66.979130] initcall 0xffffffff806e28eb: populate_rootfs+0x0/0xea() returned 0.
> [   66.979141] initcall 0xffffffff806e28eb ran for 127 msecs: populate_rootfs+0x0/0xea()
> [   66.979146] Calling initcall 0xffffffff8020cf78: time_init_device+0x0/0x22()
> 
> Total brick, no sysrq.  Had to power cycle.  Oddly enough, it boots OK
> with the same grub line, but minus 'earlyprintk=vga initcall_debug':
> 
> [   26.768561] TCP: Hash tables configured (established 131072 bind 65536)
> [   26.768566] TCP reno registered
> [   26.771502] checking if image is initramfs... it is
> [   26.904772] Freeing initrd memory: 1824k freed
> [   26.910854] audit: initializing netlink socket (disabled)
> [   26.910874] audit(1178725351.514:1): initialized
> [   26.911253] VFS: Disk quotas dquot_6.5.1
> 
> (My guess is that initcall_debug is trashing some timing constraint that
> time_init_device is relying on?)
> 

Could be.  We've had numerous problems recently wherein something tries to
read the system time while holding locks which make that illegal.  One
popular site is mark_tsc_unstable(), which does a printk, which calls
sched_clock() to get the timestamp.

Maybe this?

--- a/arch/i386/kernel/tsc.c~a
+++ a/arch/i386/kernel/tsc.c
@@ -280,7 +280,7 @@ void mark_tsc_unstable(char *reason)
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
 		tsc_enabled = 0;
-		printk("Marking TSC unstable due to: %s.\n", reason);
+//		printk("Marking TSC unstable due to: %s.\n", reason);
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
_

