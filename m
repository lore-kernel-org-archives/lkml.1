Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbZDCPAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbZDCPAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933625AbZDCO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:59:55 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:38608 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934777AbZDCO7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:59:53 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: markus.t.metzger@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090403144550.712401000@intel.com>
References: <20090403144332.799740000@intel.com>
	 <20090403144550.712401000@intel.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 17:00:52 +0200
Message-Id: <1238770852.798.146.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 16:43 +0200, markus.t.metzger@intel.com wrote:
> Index: b/include/linux/mm.h
> ===================================================================
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -13,6 +13,7 @@
>  #include <linux/prio_tree.h>
>  #include <linux/debug_locks.h>
>  #include <linux/mm_types.h>
> +#include <linux/sched.h>

Why do we need that new include?

>  struct mempolicy;
>  struct anon_vma;
> @@ -1318,6 +1319,6 @@ void vmemmap_populate_print_last(void);
>  
>  extern void *alloc_locked_buffer(size_t size);
>  extern void free_locked_buffer(void *buffer, size_t size);
> -extern void release_locked_buffer(void *buffer, size_t size);
> +extern void refund_locked_buffer_memory(struct mm_struct *mm, size_t size);

that's a pointer to a struct, so it doesn't need a fully qualified type.

Also, I can't say I like the name, what about something like:

void account_locked_buffer(struct mm_struct *mm, long pages)
{
	down_write(&mm->mmap_sem);

	mm->total_vm += pages;
	mm->locked_vm += pages;

	up_write(&mm->mmap_sem);
}

but looking more closely at that alloc_locked_buffer() stuff, I really
hate it, who in his right mind does a multi-page kmalloc() -- that's
crazy.



