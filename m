Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbXJKQqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbXJKQqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXJKQq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:46:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50304 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753515AbXJKQq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:46:27 -0400
Date: Thu, 11 Oct 2007 09:46:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
In-Reply-To: <20071011143656.GA3972@APFDCB5C>
Message-ID: <Pine.LNX.4.64.0710110944270.31423@schroedinger.engr.sgi.com>
References: <20071009161328.GA6470@APFDCB5C>
 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
 <20071010121853.GA3911@APFDCB5C> <Pine.LNX.4.64.0710101037210.7158@schroedinger.engr.sgi.com>
 <20071011143656.GA3972@APFDCB5C>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007, Akinobu Mita wrote:

> > Why would get_cpu_slab not work?
> 
> 
>         case CPU_DEAD:
>         case CPU_DEAD_FROZEN:
>                 down_read(&slub_lock);
>                 list_for_each_entry(s, &slab_caches, list) {
>                         struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
> 
>                         local_irq_save(flags);
>                         __flush_cpu_slab(s, cpu);
>                         local_irq_restore(flags);
>                         free_kmem_cache_cpu(c, cpu);
>                         s->cpu_slab[cpu] = NULL; <----------------------
>                 }
>                 up_read(&slub_lock);
>                 break;
> 
> When CPU is offlined, cpu-hotplug notifier sets s->cpu_slab[cpu] = NULL.
> This means get_cpu_slab() always return NULL when CPU is being onlined.
> So I can't use get_cpu_slab to check whether kmem_cache_cpu_free
> initalization for the CPU has already been done or not.

If you have set it to NULL then the earlier kmem_cache_cpu structures has 
been freed. Why is it a problem to allocate another one when the cpu comes 
up again?
