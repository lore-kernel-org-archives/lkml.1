Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbXLCSKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbXLCSKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXLCSKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:10:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbXLCSKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:10:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Date: Mon, 3 Dec 2007 19:28:52 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, andi@firstfloor.org, penberg@cs.helsinki.fi,
       lkml@astralstorm.puszkin.org, arjan@infradead.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <20071202165913.3eaebee6@laptopd505.fenrus.org> <20071203141925.GA8327@elte.hu> <20071203095736.7963553e.akpm@linux-foundation.org>
In-Reply-To: <20071203095736.7963553e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712031928.53659.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of December 2007, Andrew Morton wrote:
> On Mon, 3 Dec 2007 15:19:25 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > this patch extends the soft-lockup detector to automatically
> > detect hung TASK_UNINTERRUPTIBLE tasks. Such hung tasks are
> > printed the following way:
> > 
> >  ------------------>
> >  INFO: task prctl:3042 blocked for more than 120 seconds.
> >  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message
> >  prctl         D fd5e3793     0  3042   2997
> >         f6050f38 00000046 00000001 fd5e3793 00000009 c06d8264 c06dae80 00000286
> >         f6050f40 f6050f00 f7d34d90 f7d34fc8 c1e1be80 00000001 f6050000 00000000
> >         f7e92d00 00000286 f6050f18 c0489d1a f6050f40 00006605 00000000 c0133a5b
> >  Call Trace:
> >   [<c04883a5>] schedule_timeout+0x6d/0x8b
> >   [<c04883d8>] schedule_timeout_uninterruptible+0x15/0x17
> >   [<c0133a76>] msleep+0x10/0x16
> >   [<c0138974>] sys_prctl+0x30/0x1e2
> >   [<c0104c52>] sysenter_past_esp+0x5f/0xa5
> >   =======================
> >  2 locks held by prctl/3042:
> >  #0:  (&sb->s_type->i_mutex_key#5){--..}, at: [<c0197d11>] do_fsync+0x38/0x7a
> >  #1:  (jbd_handle){--..}, at: [<c01ca3d2>] journal_start+0xc7/0xe9
> >  <------------------
> > 
> > the current default timeout is 120 seconds. Such messages are printed
> > up to 10 times per bootup. If the system has crashed already then the
> > messages are not printed.
> > 
> > if lockdep is enabled then all held locks are printed as well.
> > 
> > this feature is a natural extension to the softlockup-detector (kernel
> > locked up without scheduling) and to the NMI watchdog (kernel locked up
> > with IRQs disabled).
> 
> This feature will save one full reporter-developer round-trip during
> investigation of a significant number of bug reports.
> 
> It might be more practical if it were to dump the traces for _all_
> D-state processes when it fires - basically an auto-triggered sysrq-W.

Er, it won't play well if that happen when tasks are frozen for suspend.
