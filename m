Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbXKAPx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbXKAPx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbXKAPxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:53:51 -0400
Received: from mail.suse.de ([195.135.220.2]:39896 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbXKAPxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:53:50 -0400
Date: Thu, 1 Nov 2007 16:53:47 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       riel <riel@redhat.com>
Subject: Re: [patch 1/4] spinlock: lockbreak cleanup
Message-ID: <20071101155347.GB745@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140241.GB26879@wotan.suse.de> <1193925965.27652.284.camel@twins> <20071101142932.GB2648@wotan.suse.de> <1193931599.5300.40.camel@localhost> <20071101154636.GA11723@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101154636.GA11723@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 04:46:36PM +0100, Ingo Molnar wrote:
> 
> * Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > > I guess it was done to make the "template" hacks eaiser. I don't 
> > > really find that in good taste, especially for important core 
> > > infrastructure. Anyway.
> > 
> > Actually, what I had/have is a cond_resched_rwlock() that I needed to 
> > convert the i_mmap_lock() to rw for testing reclaim scalability.  
> > [I've seen a large system running an Oracle OLTP load hang spitting 
> > "cpu soft lockup" messages with all cpus spinning on a i_mmap_lock 
> > spin lock.] One of the i_mmap_lock paths uses cond_resched_lock() for 
> > spin locks. To do a straight forward conversion [and maybe that isn't 
> > the right approach], I created the cond_resched_rwlock() function by 
> > generalizing the cond_sched_lock() code and creating both spin and rw 
> > lock wrappers. I took advantage of the fact that, currently, 
> > need_lockbreak() is a macro and that both spin and rw locks have/had 
> > the break_lock member. Typesafe functions would probably be 
> > preferrable, if we want to keep break_lock for rw spin locks.
> > 
> > Here's the most recent posting:
> > 
> > 	http://marc.info/?l=linux-mm&m=118980356306014&w=4
> > 
> > See the changes to sched.[ch].  Should apply to 23-mm1 with offsets 
> > and minor fixup in fs/inode.c.
> 
> yep. I'm too in favor of keeping the need-lockbreak mechanism and its 
> type-insensitive data structure. We've got way too many locking 
> primitives and keeping them all sorted is nontrivial already.

I think a large contributor to that is being a bit clever with indirections
and cute code (eg. like this template stuff), rather than having two types of
spinlocks instead of one.


