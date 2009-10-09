Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbZJIJfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbZJIJfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbZJIJfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:35:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37002 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301AbZJIJfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:35:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QhLh+gCvaLpFXAmpAkB3Z+xlMQAu7Hb85TlQ1QWAiPUbzJ93vF3B/x89NmY6olmAH
	kfRrmMSRh8L2lnCiG1/Fw==
Date: Fri, 9 Oct 2009 02:34:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Ankita Garg <ankita@in.ibm.com>, Len Brown <len.brown@intel.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] x86: interleave emulated nodes over physical nodes
In-Reply-To: <20091001085628.GD15345@elte.hu>
Message-ID: <alpine.DEB.1.00.0910090233460.2838@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909251517440.14754@chino.kir.corp.google.com> <alpine.DEB.1.00.0909251519150.14754@chino.kir.corp.google.com> <20091001085628.GD15345@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Ingo Molnar wrote:

> > This patch interleaves emulated nodes over the system's physical 
> > nodes. This is required for interleave optimizations since 
> > mempolicies, for example, operate by iterating over a nodemask and act 
> > without knowledge of node distances.  It can also be used for testing 
> > memory latencies and NUMA bugs in the kernel.
> > 
> > There're a couple of ways to do this:
> > 
> >  - divide the number of emulated nodes by the number of physical nodes
> >    and allocate the result on each physical node, or
> > 
> >  - allocate each successive emulated node on a different physical node
> >    until all memory is exhausted.
> > 
> > The disadvantage of the first option is, depending on the asymmetry in 
> > node capacities of each physical node, emulated nodes may 
> > substantially differ in size on a particular physical node compared to 
> > another.
> > 
> > The disadvantage of the second option is, also depending on the 
> > asymmetry in node capacities of each physical node, there may be more 
> > emulated nodes allocated on a single physical node as another.
> > 
> > This patch implements the second option; we sacrifice the possibility 
> > that we may have slightly more emulated nodes on a particular physical 
> > node compared to another in lieu of node size asymmetry.
> > 
> >  [ Note that "node capacity" of a physical node is not only a function of
> >    its addressable range, but also is affected by subtracting out the
> >    amount of reserved memory over that range.  NUMA emulation only deals
> >    with available, non-reserved memory quantities. ]
> > 
> > We ensure there is at least a minimal amount of available memory
> > allocated to each node.  We also make sure that at least this amount of
> > available memory is available in ZONE_DMA32 for any node that includes
> > both ZONE_DMA32 and ZONE_NORMAL.
> > 
> > This patch also cleans the emulation code up by no longer passing the
> > statically allocated struct bootnode array among the various functions.
> > This init.data array is not allocated on the stack since it may be very
> > large and thus it may be accessed at file scope.
> > 
> > The WARN_ON() for nodes_cover_memory() when faking proximity domains is
> > removed since it relies on successive nodes always having greater start
> > addresses than previous nodes; with interleaving this is no longer always
> > true.
> > 
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Cc: Ankita Garg <ankita@in.ibm.com>
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> >  arch/x86/mm/numa_64.c |  211 ++++++++++++++++++++++++++++++++++++++++++------
> >  arch/x86/mm/srat_64.c |    1 -
> >  2 files changed, 184 insertions(+), 28 deletions(-)
> 
> Looks very nice. Peter, Thomas, any objections against queueing this up 
> in the x86 tree for more testing?
> 

Thanks!  Do you know when this will be merged?
