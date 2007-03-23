Return-Path: <linux-kernel-owner+w=401wt.eu-S1751212AbXCWBrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbXCWBrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXCWBrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:47:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:32850 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbXCWBrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:47:42 -0400
Date: Thu, 22 Mar 2007 18:40:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [1/6] 2.6.21-rc4: known regressions
In-Reply-To: <1174612132.16068.114.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> 
 <20070318184908.GU752@stusta.de>  <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
  <46020385.50301@yahoo.com.au>  <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
 <1174612132.16068.114.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Ok, I think it's those timers again...

  Ingo: let me just state how *happy* I am that I told you off when you 
  wanted to merge the hires timers and NO_HZ before 2.6.20 because they 
  were "stable". You were wrong, and 2.6.20 is at least in reasonable 
  shape. Now we just need to make sure that 2.6.21 will be too.. ]

On Thu, 22 Mar 2007, Mingming Cao wrote:
> 
> I might missed something, so far I can't see a deadlock yet.
> If there is a deadlock, I think we should see ext3_xattr_release_block()
> and ext3_forget() on the stack. Is this the case?

No. What's strange is that two (maybe more, I didn't check) processes seem 
to be stuck in

	 [<c0318981>] schedule_timeout+0x70/0x8e
	 [<c03189b4>] schedule_timeout_uninterruptible+0x15/0x17
	 [<c01b964a>] journal_stop+0xe2/0x1e6
	 [<c01ba2b0>] journal_force_commit+0x1d/0x1f
	 [<c01b29fb>] ext3_force_commit+0x22/0x24
	 [<c01ad607>] ext3_write_inode+0x34/0x3a
	 [<c0189f74>] __writeback_single_inode+0x1c5/0x2cb
	 [<c018a096>] sync_inode+0x1c/0x2e
	 [<c01a9ff7>] ext3_sync_file+0xab/0xc0
	 [<c018c8c5>] do_fsync+0x4b/0x98
	 [<c018c932>] __do_fsync+0x20/0x2f
	 [<c018c960>] sys_fsync+0xd/0xf
	 [<c0104064>] syscall_call+0x7/0xb

but that that thing is literally:

		...
                do {
                        old_handle_count = transaction->t_handle_count;
                        schedule_timeout_uninterruptible(1);
                } while (old_handle_count != transaction->t_handle_count);
		...

and especially if nothing is happening, I'd not expect 
"transaction->t_handle_count" to keep changing, so it should stop very 
quickly.

Maybe it's CONFIG_NO_HZ again, and the problem is that timeout, and simply 
no timer tick happening?

Bingo. I think that's it.

	active timers:
	 #0: hardirq_stack, tick_sched_timer, S:01
	 # expires at 9530893000000 nsecs [in -2567889 nsecs]
	 #1: hardirq_stack, hrtimer_wakeup, S:01
	 # expires at 10858649798503 nsecs [in 1327754230614 nsecs]
	  .expires_next   : 9530893000000 nsecs

See

	http://lkml.org/lkml/2007/3/16/288

and that in turn points to the kernel log:

	http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-console.log
