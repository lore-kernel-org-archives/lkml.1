Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZFEQJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZFEQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZFEQJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:09:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:9736 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbZFEQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bMGEIePThFpLRvZOyKewcneIFW/NQbgsGoCt48hZQiS/RQxEs1hoPwLLRXZoYajkYR
         t6fp7YsSD7JE7ybZIuUSRU+F8K5G00GBfZMxUB6fAZlAwVl2eARveOW23+gCpAc7P9OH
         /kl8otBBXEPesKag4OBEIUdWFILCi36Ki/+EA=
Date: Fri, 5 Jun 2009 20:09:43 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090605160943.GA5262@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090605104517.GA11713@infradead.org> <alpine.LFD.2.01.0906050808551.6847@localhost.localdomain> <20090605154147.GA16766@x200.localdomain> <alpine.LFD.2.01.0906050848520.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906050848520.6847@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 08:49:56AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 5 Jun 2009, Alexey Dobriyan wrote:
> > 
> > This mapping issue is what created VM_EXECUTABLE/MAP_EXECUTABLE in
> > the first place, I assume? Never mind it's cheap hack.
> > 
> > > and goes along with task->mm, and should be there, not in task_struct.
> > 
> > Because ->mm can be borrowed to unrelated task and user has to check
> > for it.
> 
> Not it can't.
> 
> You're confusing ->mm with ->active_mm.
> 
> The latter can be borrowed. The former can not.

Not permanently, but it can:

	static void aio_kick_handler(struct work_struct *work)
	{
	        struct kioctx *ctx = container_of(work, struct kioctx, wq.work);
	        mm_segment_t oldfs = get_fs();
	        struct mm_struct *mm;
	        int requeue;
	
	        set_fs(USER_DS);
	        use_mm(ctx->mm);
	        spin_lock_irq(&ctx->ctx_lock);
	        requeue =__aio_run_iocbs(ctx);
	        mm = ctx->mm;
	        spin_unlock_irq(&ctx->ctx_lock);
	        unuse_mm(mm);
	        set_fs(oldfs);
	        /*
	         * we're in a worker thread already, don't use
	         * queue_delayed_work,
	         */
	        if (requeue)
	                queue_delayed_work(aio_wq, &ctx->wq, 0);
	}

It's borrowed by kernel thread of course, not userspace task.

> The fact is, the executable is _inherently_ tied to the mm. It's what it 
> is mapped into. It makes no sense to tie it to anything else. It's simply 
> fundamentally not a "per-thread" thing.
