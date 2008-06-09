Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYFIU3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYFIU3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYFIU3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:29:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYFIU3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:29:44 -0400
Date: Mon, 9 Jun 2008 16:29:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: Amul Shah <amul.shah@unisys.com>, Andi Kleen <andi@firstfloor.org>,
       Johannes Weiner <hannes@saeurebad.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, anderson@redhat.com,
       "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080609202935.GI3542@redhat.com>
References: <20080608134628.757299158@halley.suse.de> <20080608134629.743220278@halley.suse.de> <87bq2bmvro.fsf@saeurebad.de> <20080609132207.GC3542@redhat.com> <20080609182341.00d6e746@halley.suse.de> <484D5CCB.5020709@firstfloor.org> <1213041041.19111.68.camel@ustr-shaha1-linux-dev.na.uis.unisys.com> <20080609221732.1e14e5d5@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609221732.1e14e5d5@kopernikus.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 10:17:32PM +0200, Bernhard Walle wrote:
> * Amul Shah <amul.shah@unisys.com> [2008-06-09 15:50]:
> >
> > > Don't remember the details. Perhaps Amul does (cc'ed)
> > > 
> > > -Andi
> > >   
> > 
> > The short story is that the kexec kernel was panicking when trying to
> > reserve the MP tables.  The panic occurs because the MP tables resided
> > in a reserved memory area above the highest address (80MB phys at that
> > time) in the user defined E820 map used by the kexec kernel.
> > 
> > I had placed my code to affect only MP table reservation (see patch
> > below) because it is unique to just that code path.  Andi decided a
> > generalized approach would be better in case other vendors had similar
> > issues.
> 
> Ok, in that case it makes indeed sense to just return success here.
> Here's my third version of that patch:

Hi Bernhard,


[..]
> -void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
> +int __init reserve_bootmem_generic(unsigned long phys, unsigned len, int flags)
>  {
>  #ifdef CONFIG_NUMA
>  	int nid, next_nid;
>  #endif
>  	unsigned long pfn = phys >> PAGE_SHIFT;
> +	int ret;
>  
>  	if (pfn >= end_pfn) {
>  		/*
> @@ -811,11 +812,11 @@ void __init reserve_bootmem_generic(unsi
>  		 * firmware tables:
>  		 */
>  		if (pfn < max_pfn_mapped)
> -			return;
> +			return 0;
>  

Can you please put some more explanation comment here to explain that
why it is ok to return with success, despite the fact that we never
reserved any memory.

One comment is already there, but it would be nice if we could expand
that a bit to give more context. Like during normal boot there we need
to make sure "MP tables" memory is reserved but once kdump kernel is
booted, same "MP tables" memory might be beyond "end_pfn" and
reserving code would not know about this special case. So it is ok to
return with success. (Something similar).

Thanks
Vivek
