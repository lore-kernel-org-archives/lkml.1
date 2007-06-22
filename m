Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXFVWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXFVWn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXFVWnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:43:21 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:29874 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbXFVWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:43:20 -0400
X-IronPort-AV: i="4.16,453,1175497200"; 
   d="scan'208"; a="170564164:sNHT48526353"
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
X-Message-Flag: Warning: May contain useful information
References: <20070622040014.234651401@goodmis.org>
	<alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	<20070622204058.GA11777@elte.hu>
	<alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	<20070622215953.GA22917@elte.hu> <20070622220901.GA26207@elte.hu>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 22 Jun 2007 15:43:16 -0700
In-Reply-To: <20070622220901.GA26207@elte.hu> (Ingo Molnar's message of "Sat, 23 Jun 2007 00:09:01 +0200")
Message-ID: <aday7ibzk3f.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jun 2007 22:43:16.0912 (UTC) FILETIME=[B97F4300:01C7B51E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > [ and on a similar notion, i still havent given up on seeing all BKL 
 > >   use gone from the kernel. I expect it to happen any decade now ;-) ]

 > 2.6.21 had 476 lock_kernel() calls. 2.6.22-git has 473 lock_kernel() 
 > calls currently. With that kind of flux we'll see the BKL gone in about 
 > 40 years =B-)

 > 'struct semaphore' use on the other hand has gone down by 10% in this 
 > release, which is a good rate. I guess the lack of lockdep coverage for 
 > semaphores might be one of the driving forces? ;-)

The problem with removing uses of the BKL is that a "lock_kernel()"
gives no clue about what it is protecting against, and so it requires
a lot of very difficult auditing to replace with appropriate locking.

To take a couple of examples at random: fs/ext4/ioctl.c takes the BKL
in ext4_compat_ioctl() around the call to ext4_ioctl().  Kind of sad
that a "next-generation" FS still uses the BKL, but who understands
things well enough to say how all the cases in ext4_ioctl() are
relying on being called with the BKL held?

As a second example, msr_seek() in arch/i386/kernel/msr.c... is the
inode semaphore enough or not?  Who understands the implications well
enough to say?

Most semaphores on the other hand can be replaced by mutexes or
completions in a fairly straightforward way.

 - R.
