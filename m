Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZEMQw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZEMQw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbZEMQwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:52:19 -0400
Received: from relay3.sgi.com ([192.48.156.57]:43666 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755610AbZEMQwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:52:18 -0400
Date: Wed, 13 May 2009 11:52:10 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86: fix system without memory on node0
Message-ID: <20090513165210.GA1739@sgi.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com> <20090512150622.GA10015@sgi.com> <4A0A23A7.4080901@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A23A7.4080901@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 06:34:31PM -0700, Yinghai Lu wrote:
> 
> Jack found that crash with doesn't have memory on node0.
> 
> it turns out with per_cpu changeset, node_number for BSP will be alway 0,
> and it is consistent to cpu_to_node() that is to near node already.
> aka when numa_set_node() for node0 is called early before per_cpu area is
> setup
> 
> try to set the node_number for boot cpu, after we get per_cpu area setup.
> 
> [ Impact: fix crashing on memoryless node 0]
> 
> Reported-by: Jack Steiner <steiner@sgi.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/setup_percpu.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-2.6/arch/x86/kernel/setup_percpu.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
> +++ linux-2.6/arch/x86/kernel/setup_percpu.c
> @@ -423,6 +423,14 @@ void __init setup_per_cpu_areas(void)
>  	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
>  #endif
>  
> +#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
> +	/*
> +	 * make sure boot cpu node_number is right, when boot cpu is on the
> +	 * node that doesn't have mem installed
> +	 */
> +	per_cpu(node_number, boot_cpu_id) = cpu_to_node(boot_cpu_id);
> +#endif
> +
>  	/* Setup node to cpumask map */
>  	setup_node_to_cpumask_map();
>  

With the patch above PLUS the patch below, I verified that all of our strange
configurations boot to shell prompt & run simple commands. There are certainly
some corner cases that have not been tested.

Note that both patches are required. The system panics in early boot if either
patch is omitted.

---


Ignore offline nodes when building the zone lists. This
fix is needed to support configurations that hax PXMs with
cpus but no memory.


Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2009-05-12 17:06:59.000000000 -0500
+++ linux/mm/page_alloc.c	2009-05-13 09:54:09.000000000 -0500
@@ -2370,6 +2370,8 @@ static void build_zonelists(pg_data_t *p
 		 * If another node is sufficiently far away then it is better
 		 * to reclaim pages in a zone before going off node.
 		 */
+		if (!node_online(node))
+			continue;
 		if (distance > RECLAIM_DISTANCE)
 			zone_reclaim_mode = 1;
 
