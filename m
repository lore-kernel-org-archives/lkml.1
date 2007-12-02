Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXLCJva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXLCJva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXLCJvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:51:07 -0500
Received: from ozlabs.org ([203.10.76.45]:43937 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbXLCJvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:51:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 1/3] Percpu infrastructure to rebase the per cpu area to 0UL
Date: Sun, 2 Dec 2007 14:13:27 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071130064305.459255715@sgi.com> <20071130064359.604365398@sgi.com>
In-Reply-To: <20071130064359.604365398@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712021413.27612.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 17:43:06 Christoph Lameter wrote:
> Support an option
>
> 	CONFIG_PERCPU_ZERO_BASED

Minor nitpicks aside, I like this patch (using AT() was a nice touch: I tried 
using section-relative relocs originally and it gave horrible results).

But this belongs in a completely separate patch, since it could well break 
archs which don't have NUMA stuff set up yet:

> Index: linux-2.6.24-rc3-mm2/init/main.c
> ===================================================================
> --- linux-2.6.24-rc3-mm2.orig/init/main.c	2007-11-29 22:06:01.607326159
> -0800 +++ linux-2.6.24-rc3-mm2/init/main.c	2007-11-29 22:06:22.754826440
> -0800 @@ -370,18 +370,19 @@ EXPORT_SYMBOL(__per_cpu_offset);
>
>  static void __init setup_per_cpu_areas(void)
>  {
> -	unsigned long size, i;
> -	char *ptr;
> -	unsigned long nr_possible_cpus = num_possible_cpus();
> +	unsigned long size;
> +	int cpu;
>
>  	/* Copy section for each CPU (we discard the original) */
>  	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
> -	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
>
> -	for_each_possible_cpu(i) {
> -		__per_cpu_offset[i] = ptr - __per_cpu_start;
> -		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
> -		ptr += size;
> +	for_each_possible_cpu(cpu) {
> +		char *ptr;
> +
> +		ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(cpu)),
> +								size);
> +		__per_cpu_offset[cpu] = ptr - __per_cpu_start;
> +		memcpy(ptr, __per_cpu_load, __per_cpu_size);
>  	}
>  }

Thanks!
Rusty.
