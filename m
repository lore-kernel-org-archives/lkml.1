Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbXJDXKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbXJDXKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXJDXKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:10:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018AbXJDXKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:10:33 -0400
Date: Thu, 4 Oct 2007 16:09:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, wfg@mail.ustc.edu.cn, a.p.zijlstra@chello.nl,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove throttle_vm_writeout()
Message-Id: <20071004160941.e0c0c7e5.akpm@linux-foundation.org>
In-Reply-To: <E1IdZLg-0002Wr-00@dorka.pomaz.szeredi.hu>
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu>
	<20071004145640.18ced770.akpm@linux-foundation.org>
	<E1IdZLg-0002Wr-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2007 00:39:16 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> > throttle_vm_writeout() should be a per-zone thing, I guess.  Perhaps fixing
> > that would fix your deadlock.  That's doubtful, but I don't know anything
> > about your deadlock so I cannot say.
> 
> No, doing the throttling per-zone won't in itself fix the deadlock.
> 
> Here's a deadlock example:
> 
> Total memory = 32M
> /proc/sys/vm/dirty_ratio = 10
> dirty_threshold = 3M
> ratelimit_pages = 1M
> 
> Some program dirties 4M (dirty_threshold + ratelimit_pages) of mmap on
> a fuse fs.  Page balancing is called which turns all these into
> writeback pages.
> 
> Then userspace filesystem gets a write request, and tries to allocate
> memory needed to complete the writeout.
> 
> That will possibly trigger direct reclaim, and throttle_vm_writeout()
> will be called.  That will block until nr_writeback goes below 3.3M
> (dirty_threshold + 10%).  But since all 4M of writeback is from the
> fuse fs, that will never happen.
> 
> Does that explain it better?
> 

yup, thanks.

This is a somewhat general problem: a userspace process is in the IO path. 
Userspace block drivers, for example - pretty much anything which involves
kernel->userspace upcalls for storage applications.

I solved it once in the past by marking the userspace process as
PF_MEMALLOC and I beleive that others have implemented the same hack.

I suspect that what we need is a general solution, and that the solution
will involve explicitly telling the kernel that this process is one which
actually cleans memory and needs special treatment.

Because I bet there will be other corner-cases where such a process needs
kernel help, and there might be optimisation opportunities as well.

Problem is, any such mark-me-as-special syscall would need to be
privileged, and FUSE servers presently don't require special perms (do
they?)

