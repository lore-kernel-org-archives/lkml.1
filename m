Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZKFTPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZKFTPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759645AbZKFTPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:15:05 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:37844 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759670AbZKFTPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:15:04 -0500
Date: Fri, 6 Nov 2009 14:13:45 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Dave Jones <davej@redhat.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic V2
In-Reply-To: <da621335371fccd6cfb3d8d7c0c2bf3a.squirrel@webmail-b.css.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911061409310.15636@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>    <20091104234923.GA25306@redhat.com>    <alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1>    <alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1>    <20091106101106.8115e0f1.kamezawa.hiroyu@jp.fujitsu.com>
    <20091106122344.51118116.kamezawa.hiroyu@jp.fujitsu.com>    <alpine.DEB.1.10.0911061231580.5187@V090114053VZO-1> <da621335371fccd6cfb3d8d7c0c2bf3a.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Nov 2009, KAMEZAWA Hiroyuki wrote:

> And allocate mm->usage only when the first CLONE_THREAD is specified.

Ok.

> if (mm->usage)
>     access per cpu
> else
>     atomic_long_xxx

If we just have one thread: Do we need atomic access at all?

> and read operation will be
>
>     val = atomic_read(mm->rss);
>     if (mm->usage)
>         for_each_possible_cpu()....

or
   val = m->rss
   for_each_cpu(cpu) val+= percpu ...


> ==
> Does "if" seems too costly ?

The above method would avoid the if.

> If this idea is bad, I think moving mm_counter to task_struct from
> mm_struct and doing slow-sync is an idea instead of percpu.

Yeah then the access is effectively percpu as long as preempt is disabled.

But then for the mmap_writer_lock we would need to traverse a doubly
linked list to add up the counters. Bad caching on that one and we would
have to lock the list too. Sigh.

> kswapd and reclaim routine can update mm_struct's counter, directly.
> Readers just read mm_struct's counter.

Would work for rss counters but not for avoiding the rw semaphore I guess.

