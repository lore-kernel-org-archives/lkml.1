Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYLMI3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYLMI3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 03:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYLMI3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 03:29:30 -0500
Received: from sh.osrg.net ([192.16.179.4]:45143 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbYLMI33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 03:29:29 -0500
Date: Sat, 13 Dec 2008 17:29:15 +0900 (JST)
Message-Id: <20081213.172915.31069043.ryusuke@osrg.net>
To: andi@firstfloor.org
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm 1/5] nilfs2: fix problems of memory allocation in
 ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20081212202411.GK25779@one.firstfloor.org>
References: <871vwdcxo1.fsf@basil.nowhere.org>
	<20081213.034808.104867584.ryusuke@osrg.net>
	<20081212202411.GK25779@one.firstfloor.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 21:24:11 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> > In the current interface, each data item is copied twice: one is to
> > the allocated memory from user space (via copy_from_user), and another
> 
> For such large copies it is better to use multiple smaller (e.g. 4K) 
> copy user, that gives better real time preempt latencies. Each cfu has a 
> cond_resched(), but only one, not multiple times in the inner loop.

For the function in question, the buffer memory can be divided into a
smaller size (at least to 4K bytes) since the buffer is repeatedly
used for small objects, where the copy_from_user (and a copy_to_user)
is only once in each cycle.

So, just reducing the allocation size of the buffer seems good; it is
likely able to avoid both large preempt latencies and large memory
allocation, which also can leave off the use of vmalloc.

> > is to on-memory structures or to buffers/pages from the allocated
> > memory.
> 
> It depends how performance critical it is.
> 
> One way for example is to grab the user pages using get_user_pages()
> and then reference those pages directly using kmap().
> But you would be at the mercy of the user process not modifying in 
> parallel then. Normally it is safer to work from copies in kernel
> space to avoid races. As long as it doesn't happen too often a few
> copies are also usually not a problem. I wouldn't worry about them
> unless you see them prominently in profiler logs.
> 
> -Andi

I got it.  If need arises, then I'll recall get_user_pages(). At
present, there is likely no need to do like that.

Thank you for the informative advises.

With regards,
Ryusuke
