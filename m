Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZK3V1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZK3V1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZK3V1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:27:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:55310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZK3V1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:27:20 -0500
Subject: Re: [rfc] "fair" rw spinlocks
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de>
	 <alpine.LFD.2.00.0911280927180.2561@localhost>
	 <20091130100041.GA29610@infradead.org>
	 <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
	 <20091130174638.GA9782@elte.hu>
	 <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 22:27:09 +0100
Message-ID: <1259616429.26472.499.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 22:12 +0100, Thomas Gleixner wrote:

> I think the conversion Linus proposed is pretty feasible. I went
> through the read_lock sites and most of them are protecting function
> calls which we already use under rcu_read_lock() in other places like
> find_task* and thread or pid iterators.
> 
> There are a few non obvious ones in signal.c and posix-cpu-timers.c
> (what a surprise) but nothing looks too scary.
> 
> If nobody beats me I'm going to let sed loose on the kernel, lift the
> task_struct rcu free code from -rt and figure out what explodes.

Things like sched.c:tg_set_bandwidth() take the tasklist_lock in
read-mode to exclude tasks being added concurrently to avoid
sched_rt_can_attach() races with tg_has_rt_tasks().

Possibly the cgroup stuff has a smaller lock to use for this.

