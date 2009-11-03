Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZKCTrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZKCTrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZKCTrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:47:31 -0500
Received: from smtp-out.google.com ([216.239.33.17]:39333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbZKCTra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:47:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UyGw+R1RoqM8WBpGHHcqRaGq7lA8pbYn1LDtmTO7UFp/CtielMVQPrjHHAIaRvxxT
	tSnEnVC3NWoFyCn2JDQsw==
Date: Tue, 3 Nov 2009 11:47:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, minchan.kim@gmail.com,
       vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [RFC][-mm][PATCH 2/6] oom-killer: count swap usage per
 process.
In-Reply-To: <20091102162526.c985c5a8.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911031144390.11821@chino.kir.corp.google.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com> <20091102162526.c985c5a8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, KAMEZAWA Hiroyuki wrote:

> Now, anon_rss and file_rss is counted as RSS and exported via /proc.
> RSS usage is important information but one more information which
> is often asked by users is "usage of swap".(user support team said.)
> 
> This patch counts swap entry usage per process and show it via
> /proc/<pid>/status. I think status file is robust against new entry.
> Then, it is the first candidate..
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by; David Rientjes <rientjes@google.com>

Thanks!  I think this should be added to -mm now while the remainder of 
your patchset is developed and reviewed, it's helpful as an independent 
change.

> Index: mmotm-2.6.32-Nov2/fs/proc/task_mmu.c
> ===================================================================
> --- mmotm-2.6.32-Nov2.orig/fs/proc/task_mmu.c
> +++ mmotm-2.6.32-Nov2/fs/proc/task_mmu.c
> @@ -17,7 +17,7 @@
>  void task_mem(struct seq_file *m, struct mm_struct *mm)
>  {
>  	unsigned long data, text, lib;
> -	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
> +	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss, swap;
>  
>  	/*
>  	 * Note: to minimize their overhead, mm maintains hiwater_vm and
> @@ -36,6 +36,8 @@ void task_mem(struct seq_file *m, struct
>  	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
>  	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
>  	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
> +
> +	swap = get_mm_counter(mm, swap_usage);
>  	seq_printf(m,
>  		"VmPeak:\t%8lu kB\n"
>  		"VmSize:\t%8lu kB\n"

Not sure about this newline though.
