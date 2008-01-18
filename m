Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbYARKel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbYARKel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbYARKdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:33:50 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:55009 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757470AbYARKdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:33:49 -0500
Date: Fri, 18 Jan 2008 12:38:24 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
Message-ID: <20080118070824.GD8973@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Michael Ellerman <michael@ellerman.id.au>,
	linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200634493.7806.0.camel@concordia.ozlabs.ibm.com> <1200635099.7806.3.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1200635099.7806.3.camel@concordia.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Ellerman <michael@ellerman.id.au> [2008-01-18 16:44:58]:

> On Fri, 2008-01-18 at 16:34 +1100, Michael Ellerman wrote:
> > On Sat, 2007-12-08 at 04:07 +0530, Balbir Singh wrote:
> > > Changelog
> > > 
> > > 1. Get rid of the constant 5 (based on comments from
> > >                                 Geert.Uytterhoeven@sonycom.com)
> > > 2. Implement suggestions from Olof Johannson
> > > 3. Check if cmdline is NULL in fake_numa_create_new_node()
> > > 
> > > Tested with additional parameters from Olof
> > > 
> > > numa=debug,fake=
> > > numa=foo,fake=bar
> > 
> > 
> > I'm not sure why yet, but git bisect tells me it's this patch that's
> > causing the for-2.6.25 tree to explode on boot on cell machines.
> 
> This fixes it, although I'm a little worried about some of the
> removals/movings of node_set_online() in the patch.
> 
> 
> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
> index 1666e7d..dcedc26 100644
> --- a/arch/powerpc/mm/numa.c
> +++ b/arch/powerpc/mm/numa.c
> @@ -49,7 +49,6 @@ static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
>  	static unsigned int fake_nid = 0;
>  	static unsigned long long curr_boundary = 0;
>  
> -	*nid = fake_nid;
>  	if (!p)
>  		return 0;
>  
> @@ -60,6 +59,7 @@ static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
>  	if (mem < curr_boundary)
>  		return 0;
>  
> +	*nid = fake_nid;
>  	curr_boundary = mem;
>  
>  	if ((end_pfn << PAGE_SHIFT) > mem) {
> 

This patch makes sense, ideally fake_numa_create_new_node() should
just be a no-op in the case of machines with real NUMA nodes.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
