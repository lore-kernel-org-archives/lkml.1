Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZEMNgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZEMNgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZEMNgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:36:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZEMNgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:36:37 -0400
Date: Wed, 13 May 2009 15:35:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86: fix system without memory on node0
Message-ID: <20090513133504.GA7384@elte.hu>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com> <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com> <20090512150622.GA10015@sgi.com> <4A0A23A7.4080901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A23A7.4080901@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Jack found that crash with doesn't have memory on node0.
> 
> it turns out with per_cpu changeset, node_number for BSP will be 
> alway 0, and it is consistent to cpu_to_node() that is to near 
> node already. aka when numa_set_node() for node0 is called early 
> before per_cpu area is setup
> 
> try to set the node_number for boot cpu, after we get per_cpu area 
> setup.
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

ok, that's a nice fix i guess.

Wouldnt it also be necessary/good to unify this code between 32-bit 
and 64-bit? 32-bit has cpu_to_node_map[], while 64-bit has percpu 
variables for that.

	Ingo
