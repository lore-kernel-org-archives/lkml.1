Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbXLFMCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbXLFMCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLFMCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:02:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbXLFMCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:02:00 -0500
Date: Thu, 6 Dec 2007 04:01:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: suspend-related lockdep warning
Message-Id: <20071206040102.c6b8e9b0.akpm@linux-foundation.org>
In-Reply-To: <1196937088.6788.56.camel@twins>
References: <20071128024355.5931c6ec.akpm@linux-foundation.org>
	<200712032334.27088.rjw@sisk.pl>
	<20071203174505.c5ea84c4.akpm@linux-foundation.org>
	<200712060121.24837.rjw@sisk.pl>
	<1196937088.6788.56.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2007 11:31:28 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Thu, 2007-12-06 at 01:21 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, 4 of December 2007, Andrew Morton wrote:
> 
> > > [   34.455096] ipw2200: Failed to send WEP_KEY: Command timed out.
> > > [   34.911876] Syncing filesystems ... done.
> > > [   34.934526] Freezing user space processes ... WARNING: at kernel/lockdep.c:2662 check_flags()
> > > [   34.934917] Pid: 1922, comm: dbus-daemon Not tainted 2.6.24-rc3-mm3 #2
> > > [   34.935036]  [<c0104853>] show_trace_log_lvl+0x12/0x25
> > > [   34.935142]  [<c010506c>] show_trace+0xd/0x10
> > > [   34.935231]  [<c0105850>] dump_stack+0x55/0x5d
> > > [   34.935322]  [<c0136125>] check_flags+0x7f/0x11a
> > > [   34.935417]  [<c0139210>] lock_acquire+0x3a/0x86
> > > [   34.935511]  [<c0318faf>] _spin_lock+0x1c/0x49
> > > [   34.935603]  [<c0140fc7>] refrigerator+0x13/0xc8
> > > [   34.935697]  [<c01270ac>] get_signal_to_deliver+0x34/0x2e8
> > > [   34.935807]  [<c0102edc>] do_notify_resume+0x8c/0x6fe
> > > [   34.935907]  [<c0103a2c>] work_notifysig+0x13/0x1b
> > > [   34.936004]  =======================
> > > [   34.936072] irq event stamp: 253
> > > [   34.936133] hardirqs last  enabled at (253): [<c0103a8d>] syscall_exit_work+0x11/0x26
> > > [   34.936294] hardirqs last disabled at (252): [<c0103956>] syscall_exit+0x14/0x25
> > > [   34.936446] softirqs last  enabled at (0): [<c011baf9>] copy_process+0x300/0x1246
> > > [   34.936599] softirqs last disabled at (0): [<00000000>] 0x0
> > > [   34.954308] (elapsed 0.01 seconds) done.
> > > [   34.954389] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> > 
> > Hmm, do I understand correctly that lockdep expects us to disable interrupts
> > before acquiring the task lock in refrigerator()?  That would be strange.
> > 
> > Ingo, can you have a look at this, please?
> 
> No its complaining that the IRQ state changed without anybody telling it
> about it. Usually an unannotated cli/sti.
> 
> The particular line it warns, (lockdep.c:2662), suggests... 
> 
>   /me grabs a copy of 24-rc3-mm2
> 
>  ... that hardirqs are disabled, but irq tracking thinks they are still
> enabled. So that would be an unannotated cli.
> 

It would be nice to make that warning tell us that - we've hit it a
few times and I never knew this was the reason.
