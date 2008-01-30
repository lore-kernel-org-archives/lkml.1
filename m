Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbYA3Xom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbYA3Xom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYA3Xo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:44:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48700 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbYA3Xo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:44:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Regression] 2.6.24-git8 (and earlier): Multiple processes stuck in D states after logout from KDE
Date: Thu, 31 Jan 2008 00:42:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801302338.25365.rjw@sisk.pl>
In-Reply-To: <200801302338.25365.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801310042.07910.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update.

On Wednesday, 30 of January 2008, Rafael J. Wysocki wrote:
> Hi,
> 
> Recently I've been observing problems with unmounting the /home fs on reboot
> and/or shutdown on two test boxes.
> 
> After some more investigation I've found that this is due to some KDE processes
> stuck in D states after their owner has logged out.
> 
> This happens 100% of the time if there's a suspend/resume cycle before the user
> logs out (ie. the user logs into KDE, works for some time, suspends the box to
> RAM and resmes one or more times and then logs out).  Still, I also observe the
> symptoms on a box that's never suspended.
> 
> I'm not sure how to debug this, so please advise.

After reverting:

commit 37bb6cb4097e29ffee970065b74499cbf10603a3
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jan 25 21:08:32 2008 +0100

    hrtimer: unlock hrtimer_wakeup

I no longer get processes in the D state, but there still is a problem with
artswrapper (this is an openSUSE 10.3 system, x86-64).  Namely,
after a suspend/resume cycle and logging out/logging in the user,
artswrapper gets stuck somewhere, apparently in the running (R) state.
For this reason it blocks any subsequent attempts to suspend.

Here's the relevant trace (from show_state()):

[  522.474919] artswrapper   R  running task        0  4805      1
[  522.474922]  ffff810074cd1f70 0000000000000082 0000000000000296 ffff810074cd1ed8
[  522.474926]  ffffffff80311769 ffff810074cd1f20 ffffffff80701240 ffffffff80701240
[  522.474930]  ffffffff80701240 ffffffff80701240 ffffffff80701240 ffffffff80701240
[  522.474933] Call Trace:
[  522.474940]  [<ffffffff80311769>] ? __up_read+0x8f/0x97
[  522.474963]  [<ffffffff8020c5cf>] retint_careful+0xd/0x21

where, according to gdb,

(gdb) l *__up_read+0x8f
0xffffffff80311769 is in __up_read (/home/rafael/src/linux-2.6/lib/rwsem-spinlock.c:273).
268
269             if (--sem->activity == 0 && !list_empty(&sem->wait_list))
270                     sem = __rwsem_wake_one_writer(sem);
271
272             spin_unlock_irqrestore(&sem->wait_lock, flags);
273     }
274
275     /*
276      * release a write lock on the semaphore
277      */

What gives?

Rafael
