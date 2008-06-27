Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbYF0RZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbYF0RZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYF0RZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:25:03 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:32550 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbYF0RZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:25:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Et1SS62gKB8fVZYBcfb/HlsJfuioHXnW9SEaVGN518Q6NWxQoH4ctcVSISR95BelKj
         sHRztXjxlbv2xAffdx7l2fUhlsZTMn7fsW0zD5H40AfOxQ6l/1T3CWp5VHqR5owLYOnR
         BBi+RaI107abLs79/lMEGxNEmtXbafbcXzKCI=
Message-ID: <19f34abd0806271024j53b383ddq33ab2b58debfbb65@mail.gmail.com>
Date: Fri, 27 Jun 2008 19:24:59 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48651EF5.5090808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>
	 <19f34abd0806090420r4100241cgb4b828441de3b102@mail.gmail.com>
	 <20080609113547.GA1534@elte.hu> <484D54F2.4070603@sgi.com>
	 <20080626113229.GB29619@elte.hu> <4863C334.2090007@sgi.com>
	 <486452CC.8050502@sgi.com> <48651EF5.5090808@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 7:10 PM, Mike Travis <travis@sgi.com> wrote:
> Subject: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3
>
>  * When CONFIG_DEBUG_PER_CPU_MAPS is set, the node passed to
>    node_to_cpumask and node_to_cpumask_ptr should be validated.
>    If invalid, then a dump_stack is performed and a zero cpumask
>    is returned.
>
> Based on "Fri Jun 27 10:06:06 PDT 2008" tip/master...  ;-)
>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
> V2: Slightly different version to remove a compiler warning.
> V3: Redone to reflect moving setup.c -> setup_percpu.c
> ---
>  arch/x86/kernel/setup_percpu.c |   26 +++++++++++++++++++++++---
>  include/asm-x86/topology.h     |    7 ++++++-
>  2 files changed, 29 insertions(+), 4 deletions(-)
>
> --- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
> +++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
> @@ -346,6 +346,10 @@ int early_cpu_to_node(int cpu)
>        return per_cpu(x86_cpu_to_node_map, cpu);
>  }
>
> +
> +/* empty cpumask */
> +static const cpumask_t cpu_mask_none;
> +
>  /*
>  * Returns a pointer to the bitmask of CPUs on Node 'node'.
>  */
> @@ -358,13 +362,23 @@ cpumask_t *_node_to_cpumask_ptr(int node
>                dump_stack();
>                return &cpu_online_map;
>        }
> -       BUG_ON(node >= nr_node_ids);
> -       return &node_to_cpumask_map[node];
> +       if (node >= nr_node_ids) {
> +               printk(KERN_WARNING
> +                       "_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
> +                       node, nr_node_ids);
> +               dump_stack();
> +               return (cpumask_t *)&cpu_mask_none;

Hm, I am wondering about this.

There exists an option DEBUG_RODATA ("Write protect kernel read-only
data structures"). I'm guessing this RO protections means that we'll
get page faults (and thus BUG/panic) if this "none" mask is ever
attempted to be changed.

So if CONFIG_DEBUG_RODATA=y, I believe we'll see first this warning,
then a panic (after all). Would it be better to make cpu_mask_none
non-const, in spirit of trying to continue as far as possible? I don't
really know if it matters, though. It seems that fedora kernels at
least ship with a default of DEBUG_RODATA=y.

What you could also do is to make it non-const and then zero it each
time it is requested. Again, this is an error situation in either
case, so maybe it's not worth fussing about.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
