Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbXJKOlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbXJKOlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 10:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXJKOlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 10:41:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:54688 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbXJKOk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 10:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eZsQLu3ad+sOiOWuu1Zg0wqwvU3hHtc0e/iUX83Aozmf1AbZWQArC6E7Bv0RSqso0JrdNDv4O4e3ew4gM2uwT6716X4baL3GE5d3qQKudvjO5p72mGdOday1kGhevVm8WaGtXHOKH0EZgtaQgeUpmSeKdJTMHXCsUrjcziKs82U=
Date: Thu, 11 Oct 2007 23:36:56 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
Message-ID: <20071011143656.GA3972@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>
References: <20071009161328.GA6470@APFDCB5C> <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com> <20071010121853.GA3911@APFDCB5C> <Pine.LNX.4.64.0710101037210.7158@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710101037210.7158@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 10:39:32AM -0700, Christoph Lameter wrote:
> On Wed, 10 Oct 2007, Akinobu Mita wrote:
> 
> > I couldn't use get_cpu_slab() for that check. But I reviced the patch to do
> > what you said.
> 
> Why would get_cpu_slab not work?


        case CPU_DEAD:
        case CPU_DEAD_FROZEN:
                down_read(&slub_lock);
                list_for_each_entry(s, &slab_caches, list) {
                        struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);

                        local_irq_save(flags);
                        __flush_cpu_slab(s, cpu);
                        local_irq_restore(flags);
                        free_kmem_cache_cpu(c, cpu);
                        s->cpu_slab[cpu] = NULL; <----------------------
                }
                up_read(&slub_lock);
                break;

When CPU is offlined, cpu-hotplug notifier sets s->cpu_slab[cpu] = NULL.
This means get_cpu_slab() always return NULL when CPU is being onlined.
So I can't use get_cpu_slab to check whether kmem_cache_cpu_free
initalization for the CPU has already been done or not.

> 
> > +	if (per_cpu(kmem_cache_cpu_free, cpu)) {
> > +		/* Already initialized once */
> > +		return;
> > +	}
> > +
> 
> kmem_cache_cpu_free is not only NULL if the cpu is not up yet but it is 
> also NULL if the per cpu pool of kmem_cache_cpu structures was 
> exhausted.

cpu-hotplug notifier by CPU_DEAD event frees kmem_cache_cpu structures
for the CPU being offlined. So we have 100 kmem_cache cpu structures
when the CPU will be onlined again.

But I agree that it is not so trivial. It is why I added the comment
/* Already initialized once */ in previous patch.

This is another approach for the fix.
Use cpumask to check whether kmem_cache_cpu_free initalization for
the CPU has already been done or not.

---
 mm/slub.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: 2.6-mm/mm/slub.c
===================================================================
--- 2.6-mm.orig/mm/slub.c
+++ 2.6-mm/mm/slub.c
@@ -1959,6 +1959,7 @@ static DEFINE_PER_CPU(struct kmem_cache_
 				kmem_cache_cpu)[NR_KMEM_CACHE_CPU];
 
 static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
+static cpumask_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
 
 static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
 							int cpu, gfp_t flags)
@@ -2033,8 +2034,13 @@ static void init_alloc_cpu_cpu(int cpu)
 {
 	int i;
 
+	if (cpu_isset(cpu, kmem_cach_cpu_free_init_once))
+		return;
+
 	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
 		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
+
+	cpu_set(cpu, kmem_cach_cpu_free_init_once);
 }
 
 static void __init init_alloc_cpu(void)
