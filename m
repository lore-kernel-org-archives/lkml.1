Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbZHaXBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbZHaXBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZHaXBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:01:03 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32725 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZHaXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:01:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GZPjT9jFwKaDOExYxt1QPK3wgGtkaA5K8cMgLPnejQJNAjYlUpk0JwbW4WysU9CtW
	wSUuwfTb2PH+TpiD5Cpfg==
Date: Mon, 31 Aug 2009 16:00:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bill Xie <bill790@gmail.com>
cc: Chungki woo <chungki.woo@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: oom-killer works,but the memory cannot be freed
In-Reply-To: <30c949580908280026i7407cdahbdcead91573fbfb8@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0908311557150.17225@chino.kir.corp.google.com>
References: <30c949580908251825n59da4bceg77c464eca01f0c46@mail.gmail.com> <18eba5a10908252208p791288e3mc28f6aaf8306948f@mail.gmail.com> <30c949580908272349u20145192ydfec4b1950ae7b23@mail.gmail.com>
 <30c949580908280026i7407cdahbdcead91573fbfb8@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Bill Xie wrote:

> and the oom killer message attached.  It seems when at this situation,
> 
> echo 3 > /proc/sys/vm/drop_caches , cannot release the memory occupied
> by the application.
> 
> hotplug invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
> Call Trace:
> [<800207dc>] dump_stack+0x8/0x34
> [<8007cb30>] oom_kill_process+0x138/0x148
> [<8007d1f0>] out_of_memory+0x1f0/0x340
> [<800806a4>] __alloc_pages+0x2a4/0x3d0
> [<8008ebd8>] do_wp_page+0x12c/0x8ec
> [<800913a0>] handle_mm_fault+0x718/0x938
> [<80024a1c>] do_page_fault+0x12c/0x3b0
> [<800196e4>] ret_from_exception+0x0/0x10
> 
> Mem-info:
> Normal per-cpu:
> CPU    0: Hot: hi:   18, btch:   3 usd:   3   Cold: hi:    6, btch:   1 usd:   0
> Active:7767 inactive:2992 dirty:0 writeback:0 unstable:0
>  free:252 slab:676 mapped:95 pagetables:99 bounce:0
> Normal free:1008kB min:1016kB low:1268kB high:1524kB active:31068kB inactive:11968kB press
> lowmem_reserve[]: 0 0
> Normal: 0*4kB 2*8kB 2*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096B
> Swap cache: add 0, delete 0, find 0/0, race 0+0
> Free swap  = 0kB
> Total swap = 0kB
> Free swap:            0kB
> 16384 pages of RAM
> 0 pages of HIGHMEM
> 2467 reserved pages
> 2376 pages shared
> 0 pages swap cached
> Out of memory (oom_kill_allocating_task): kill process 511 (hotplug) score 0 or a child

The key part of these diagnostic messages is the last line, where it says 
you're using oom_kill_allocating_task.  Notice the badness score of the 
task chosen for oom kill, hotplug, is 0, meaning that it's not going to 
lead to any future memory freeing.

We should probably check if badness(current) is 0 before killing it when 
oom_kill_allocating_task is enabled to ensure something worthwhile is 
actually killed.

In the meantime, try

	echo 0 > /proc/sys/vm/oom_kill_allocating_task

 [ In the future, please don't include attachments to messages to LKML 
   unless they are egregiously long, we can handle smaller sizes inline. ]
