Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbYBSPtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbYBSPtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYBSPsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:48:52 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55170 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751211AbYBSPsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:48:51 -0500
Message-ID: <47BAFA66.2040603@sgi.com>
Date: Tue, 19 Feb 2008 07:48:54 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lameter@sgi.com
Subject: Re: [PATCH] x86_64: remove never used nodenumer in pda
References: <200802162302.04131.yinghai.lu@sun.com> <p73ve4mxxlc.fsf@bingen.suse.de>
In-Reply-To: <p73ve4mxxlc.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
> 
>> we don't need copy too. already have x86_cpu_to_node_map
> 
> That's a regression (probably from Mike's patches?). Until recently it was 
> used.

Yes, I had removed it because I couldn't find any references to it.
And reading one's own percpu variables should be as efficient as
reading one's own pda.

But if I missed something, I apologize.  Thanks for catching the problem.

-Mike

> 
> The reason the node number was put in there is that it generates far
> shorter code to just fetch the local node number from the PDA than to
> first go through a array lookup from the cpu number. It also saves a
> costly cache line miss on the array if you're unlucky.
> 
> It is far better to fix it than to remove it.
> 
> I know Mike/Christoph want to get rid of the PDA and make per cpu data 
> as efficient as the PDA. If that happens the right fix is to create
> a new per CPU data variable for the node number again.
> 
> Here's a quick patch (tested on kvm with numa emulation only) 
> 
> It should be ok because PDA is set up early and
> the early node is always 0 and there is a 0 in there
> at early boot.
> 
> Saves about 1.6k of text on a vmlinux here.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux/include/asm-x86/topology.h
> ===================================================================
> --- linux.orig/include/asm-x86/topology.h
> +++ linux/include/asm-x86/topology.h
> @@ -34,11 +34,12 @@
>  extern int cpu_to_node_map[];
>  
>  #else
> +#include <asm/pda.h>
>  DECLARE_PER_CPU(int, x86_cpu_to_node_map);
>  extern int x86_cpu_to_node_map_init[];
>  extern void *x86_cpu_to_node_map_early_ptr;
>  /* Returns the number of the current Node. */
> -#define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
> +#define numa_node_id()		(read_pda(nodenumber))
>  #endif
>  
>  extern cpumask_t node_to_cpumask_map[];
> 
> 

