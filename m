Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYE3FAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYE3FAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYE3E67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:58:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbYE3E66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:58:58 -0400
Date: Thu, 29 May 2008 21:58:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 03/41] cpu alloc: Use cpu allocator instead of the
 builtin modules per cpu allocator
Message-Id: <20080529215837.0528fb3b.akpm@linux-foundation.org>
In-Reply-To: <20080530040011.451400376@sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080530040011.451400376@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 20:56:23 -0700 Christoph Lameter <clameter@sgi.com> wrote:

> Remove the builtin per cpu allocator from modules.c and use cpu_alloc instead.
> 
> The patch also removes PERCPU_ENOUGH_ROOM. The size of the cpu_alloc area is
> determined by CONFIG_CPU_AREA_SIZE. PERCPU_ENOUGH_ROOMs default was 8k.
> CONFIG_CPU_AREA_SIZE defaults to 30k. Thus we have more space to load modules.
> 
>
> ...
>
> +		unsigned long align = sechdrs[pcpuindex].sh_addralign;
> +		unsigned long size = sechdrs[pcpuindex].sh_size;
> +
> +		if (align > PAGE_SIZE) {
> +			printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
> +			mod->name, align, PAGE_SIZE);

Indenting broke.

Alas, PAGE_SIZE has, iirc, unsigned type on some architectures and
unsigned long on others.  I suspect you'll need to cast it to be able
to print it.

> +			align = PAGE_SIZE;
> +		}
> +		percpu = cpu_alloc(size, GFP_KERNEL|__GFP_ZERO, align);
> +		if (!percpu)
> +			printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",

80-col bustage,.

A printk like this should, I think, identify what part of the kernel it
came from.

But really, I don't think any printk should be present here. 
cpu_alloc() itself should dump the warning and the backtrace when it
runs out.  Because a cpu_alloc() failure is a major catastrophe.  It
probably means a reconfigure-and-reboot cycle.

Right now it means a
reconfigure-kernel-rebuild-kernel-reinstall-kernel-then-reboot cycle. 
Or a call-vendor-complain-pay-money-and-wait cycle.  But I hope we can
fix that with the boot parameter thing?


