Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbZJAI5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbZJAI5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbZJAI5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:57:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbZJAI47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:56:59 -0400
Date: Thu, 1 Oct 2009 10:56:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ankita Garg <ankita@in.ibm.com>, Len Brown <len.brown@intel.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] x86: interleave emulated nodes over physical nodes
Message-ID: <20091001085628.GD15345@elte.hu>
References: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com> <alpine.DEB.1.00.0909251519150.14754@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0909251519150.14754@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> Add interleaved NUMA emulation support
> 
> This patch interleaves emulated nodes over the system's physical 
> nodes. This is required for interleave optimizations since 
> mempolicies, for example, operate by iterating over a nodemask and act 
> without knowledge of node distances.  It can also be used for testing 
> memory latencies and NUMA bugs in the kernel.
> 
> There're a couple of ways to do this:
> 
>  - divide the number of emulated nodes by the number of physical nodes
>    and allocate the result on each physical node, or
> 
>  - allocate each successive emulated node on a different physical node
>    until all memory is exhausted.
> 
> The disadvantage of the first option is, depending on the asymmetry in 
> node capacities of each physical node, emulated nodes may 
> substantially differ in size on a particular physical node compared to 
> another.
> 
> The disadvantage of the second option is, also depending on the 
> asymmetry in node capacities of each physical node, there may be more 
> emulated nodes allocated on a single physical node as another.
> 
> This patch implements the second option; we sacrifice the possibility 
> that we may have slightly more emulated nodes on a particular physical 
> node compared to another in lieu of node size asymmetry.
> 
>  [ Note that "node capacity" of a physical node is not only a function of
>    its addressable range, but also is affected by subtracting out the
>    amount of reserved memory over that range.  NUMA emulation only deals
>    with available, non-reserved memory quantities. ]
> 
> We ensure there is at least a minimal amount of available memory
> allocated to each node.  We also make sure that at least this amount of
> available memory is available in ZONE_DMA32 for any node that includes
> both ZONE_DMA32 and ZONE_NORMAL.
> 
> This patch also cleans the emulation code up by no longer passing the
> statically allocated struct bootnode array among the various functions.
> This init.data array is not allocated on the stack since it may be very
> large and thus it may be accessed at file scope.
> 
> The WARN_ON() for nodes_cover_memory() when faking proximity domains is
> removed since it relies on successive nodes always having greater start
> addresses than previous nodes; with interleaving this is no longer always
> true.
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Ankita Garg <ankita@in.ibm.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/mm/numa_64.c |  211 ++++++++++++++++++++++++++++++++++++++++++------
>  arch/x86/mm/srat_64.c |    1 -
>  2 files changed, 184 insertions(+), 28 deletions(-)

Looks very nice. Peter, Thomas, any objections against queueing this up 
in the x86 tree for more testing?

	Ingo
