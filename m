Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbXLDBp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbXLDBp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 20:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXLDBps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 20:45:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXLDBpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 20:45:47 -0500
Date: Mon, 3 Dec 2007 17:45:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: suspend-related lockdep warning
Message-Id: <20071203174505.c5ea84c4.akpm@linux-foundation.org>
In-Reply-To: <200712032334.27088.rjw@sisk.pl>
References: <20071128024355.5931c6ec.akpm@linux-foundation.org>
	<200712022133.24420.rjw@sisk.pl>
	<20071202222652.ef7c6c18.akpm@linux-foundation.org>
	<200712032334.27088.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 23:34:26 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, 3 of December 2007, Andrew Morton wrote:
> > On Sun, 2 Dec 2007 21:33:23 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Saturday, 1 of December 2007, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > 2.6.24-rc3-mm2 (which will be released if it boots on two more machines and
> > > > > if I stay awake) will say this during suspend-to-RAM on the Vaio:
> > > > > 
> > > > > [   91.876445] Syncing filesystems ... done.
> > > > > [   92.382595] Freezing user space processes ... WARNING: at kernel/lockdep.c:2662 check_flags()
> > > > > [   92.384000] Pid: 1925, comm: dbus-daemon Not tainted 2.6.24-rc3-mm2 #32
> > > > > [   92.384177]  [<c0104a74>] show_trace_log_lvl+0x12/0x25
> > > > > [   92.384335]  [<c01052ff>] show_trace+0xd/0x10
> > > > > [   92.384469]  [<c01059be>] dump_stack+0x55/0x5d
> > > > > [   92.384605]  [<c0136a29>] check_flags+0x7f/0x11a
> > > > > [   92.384746]  [<c0139cfb>] lock_acquire+0x3a/0x86
> > > > > [   92.384886]  [<c031f4de>] _spin_lock+0x26/0x53
> > > > > [   92.385023]  [<c0141d3b>] refrigerator+0x13/0xc8
> > > > > [   92.385163]  [<c01274c8>] get_signal_to_deliver+0x32/0x3fb
> > > > > [   92.385326]  [<c01030f4>] do_notify_resume+0x8c/0x699
> > > > > [   92.385476]  [<c0103c18>] work_notifysig+0x13/0x1b
> > > > > [   92.385620]  =======================
> > > > > [   92.385719] irq event stamp: 309
> > > > > [   92.385809] hardirqs last  enabled at (309): [<c0103c79>] syscall_exit_work+0x11/0x26
> > > > > [   92.386045] hardirqs last disabled at (308): [<c0103b42>] syscall_exit+0x14/0x25
> > > > > [   92.386265] softirqs last  enabled at (0): [<c011bea5>] copy_process+0x374/0x130e
> > > > > [   92.386491] softirqs last disabled at (0): [<00000000>] 0x0
> > > > > [   92.392457] (elapsed 0.00 seconds) done.
> > > > > [   92.392581] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > > > > [   92.392882] PM: Entering mem sleep
> > > > > [   92.392974] Suspending console(s)
> > > > > 
> > > > > this has been happening for quite some time and might even be happening in
> > > > > mainline.  
> > > > 
> > > > Is it complaining that we entered refrigerator with irqs disabled?
> > > 
> > > Or that someone else called task_lock() with irqs disabled at one point ...
> > > 
> > > Hm, perhaps it's related to kernel preemption.  Andrew, I guess the kernel is
> > > preemptible?
> > > 
> > 
> > yup.  http://userweb.kernel.org/~akpm/config-sony.txt
> 
> Is this reproducible with kernel preemption off?

yes.  Current -mm lineup:

[   34.455096] ipw2200: Failed to send WEP_KEY: Command timed out.
[   34.911876] Syncing filesystems ... done.
[   34.934526] Freezing user space processes ... WARNING: at kernel/lockdep.c:2662 check_flags()
[   34.934917] Pid: 1922, comm: dbus-daemon Not tainted 2.6.24-rc3-mm3 #2
[   34.935036]  [<c0104853>] show_trace_log_lvl+0x12/0x25
[   34.935142]  [<c010506c>] show_trace+0xd/0x10
[   34.935231]  [<c0105850>] dump_stack+0x55/0x5d
[   34.935322]  [<c0136125>] check_flags+0x7f/0x11a
[   34.935417]  [<c0139210>] lock_acquire+0x3a/0x86
[   34.935511]  [<c0318faf>] _spin_lock+0x1c/0x49
[   34.935603]  [<c0140fc7>] refrigerator+0x13/0xc8
[   34.935697]  [<c01270ac>] get_signal_to_deliver+0x34/0x2e8
[   34.935807]  [<c0102edc>] do_notify_resume+0x8c/0x6fe
[   34.935907]  [<c0103a2c>] work_notifysig+0x13/0x1b
[   34.936004]  =======================
[   34.936072] irq event stamp: 253
[   34.936133] hardirqs last  enabled at (253): [<c0103a8d>] syscall_exit_work+0x11/0x26
[   34.936294] hardirqs last disabled at (252): [<c0103956>] syscall_exit+0x14/0x25
[   34.936446] softirqs last  enabled at (0): [<c011baf9>] copy_process+0x300/0x1246
[   34.936599] softirqs last disabled at (0): [<00000000>] 0x0
[   34.954308] (elapsed 0.01 seconds) done.
[   34.954389] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.

