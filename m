Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbXJKRYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbXJKRYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbXJKRYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:24:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:24660 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbXJKRYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dHLhzCsUoTBFnX6Ek9TYTnZFTysZQtWB4tZFlPw8WOgTyGdnV3fKDESqHf+cSuELMQhCuvRIvbQsG0hYu5n0P5wfQe7vNZsVjPOyGmyzO0SVy3DDY+2cn1+hY2QpS7TgxH+MUOvwaTxIWV0DWsCGgSk44tCaGfIf6zJHZLsG+Eo=
Message-ID: <961aa3350710111024jbcfd3e3q959bdb2d3c2828fe@mail.gmail.com>
Date: Fri, 12 Oct 2007 02:24:13 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0710110944270.31423@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071009161328.GA6470@APFDCB5C>
	 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
	 <20071010121853.GA3911@APFDCB5C>
	 <Pine.LNX.4.64.0710101037210.7158@schroedinger.engr.sgi.com>
	 <20071011143656.GA3972@APFDCB5C>
	 <Pine.LNX.4.64.0710110944270.31423@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/12, Christoph Lameter <clameter@sgi.com>:
> On Thu, 11 Oct 2007, Akinobu Mita wrote:
>
> > > Why would get_cpu_slab not work?
> >
> >
> >         case CPU_DEAD:
> >         case CPU_DEAD_FROZEN:
> >                 down_read(&slub_lock);
> >                 list_for_each_entry(s, &slab_caches, list) {
> >                         struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
> >
> >                         local_irq_save(flags);
> >                         __flush_cpu_slab(s, cpu);
> >                         local_irq_restore(flags);
> >                         free_kmem_cache_cpu(c, cpu);
> >                         s->cpu_slab[cpu] = NULL; <----------------------
> >                 }
> >                 up_read(&slub_lock);
> >                 break;
> >
> > When CPU is offlined, cpu-hotplug notifier sets s->cpu_slab[cpu] = NULL.
> > This means get_cpu_slab() always return NULL when CPU is being onlined.
> > So I can't use get_cpu_slab to check whether kmem_cache_cpu_free
> > initalization for the CPU has already been done or not.
>
> If you have set it to NULL then the earlier kmem_cache_cpu structures has
> been freed. Why is it a problem to allocate another one when the cpu comes
> up again?
>

kmem_cache_cpu_free per-cpu singly list will be broken by calling
init_alloc_cpu_cpu() twice. It happens when online/offlining CPU.
All three patches I send attempt to make init_alloc_cpu_cpu()
called only once for each cpu.
