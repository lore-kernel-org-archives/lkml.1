Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYAJWc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYAJWc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYAJWcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:32:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36106 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYAJWcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:32:51 -0500
Date: Thu, 10 Jan 2008 23:35:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity map and kernel text
Message-ID: <20080110223527.GA3973@one.firstfloor.org>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080110211658.GA3145@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A29A1@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5A29A1@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 02:25:29PM -0800, Pallipadi, Venkatesh wrote:
>  
> 
> >-----Original Message-----
> >From: linux-kernel-owner@vger.kernel.org 
> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Andi Kleen
> >Sent: Thursday, January 10, 2008 1:17 PM
> >To: Pallipadi, Venkatesh
> >Cc: Andi Kleen; ebiederm@xmission.com; rdreier@cisco.com; 
> >torvalds@linux-foundation.org; gregkh@suse.de; 
> >airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
> >tglx@linutronix.de; linux-kernel@vger.kernel.org; Siddha, Suresh B
> >Subject: Re: [patch 02/11] PAT x86: Map only usable memory in 
> >x86_64 identity map and kernel text
> >
> >> I think it is unsafe to access any reserved areas through 
> >"WB" not just
> >> mmio regions. In the above case 0xe0000000-0xf0000000 is one such
> >> region.
> >
> >That is 2MB aligned.
> 
> That e820 also has a reserved here at 0x9d000.

That's not a hole

> 
>  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)
> 
> If we keep mapping for such pages, it will be problematic as if a driver
> later does a ioremap, then we have to go through split-pages and cpa.

It should not do ioremap uncacheable from reserved because there
shouldn't be a MMIO hole in there. It can do ioremap_cachable()
but that is ok.

> 
> Most of the holes/reserved areas will be 2M aligned, other than initial
> 2M and possible 2M around ACPI region. So, we may end up mapping some of
> those pages with small pages. Even though it was not enforced until now,
> I feel that is required for correctness.

If it's rare enough mapping in 2MB chunks around the holes is ok.
> 
> >> >
> >> >Exactly it's already broken.
> >> >
> >> >Anyways if someone accesses mmio through /dev/mem I think they 
> >> >definitely
> >> >want the real mappings, not a zero page.  And dev/mem 
> >should provide.
> >> >The trick is just to do it without caching attribute violations, 
> >> >but with mattr it is possible.
> >> 
> >> I don't like /dev/mem supporting access to mmio. We do not know what
> >
> >But it always did that. I'm sure you'll break stuff if you forbid
> >it suddenly.
> >
> >> attributes to use for these regions.  We can potentially map 
> >all these
> >> pages uncacheable. 
> >
> >That is what current /dev/mem does.
> 
> May be I am missing something. But, I don't think I saw /dev/mem
> checking whether some region is reserved and mapping those pages as
> uncacheable. 

It relies partly on the MTRRs and partly checks for >= end_pfn.
Yes it's a gross hack, but it works.

> As I though, its mostly done as MTRR has such setting. If I
> do dd of devmem which ends up reading all reserved regions today, I see
> one of my systems dying horribly with NMI dazed and confused and the
> other gets SCSI errors etc. I am not sure how can some apps depend on
> reading mmio regions through /dev/mem. Any particular app you are
> thinking about?

The older X servers for once or x86emu in user space and likely various 
others. There are all kind of scary utilities using /dev/mem around
(like BIOS flash updaters etc.) 

I know some people who don't trust the VM for large memory ares 
like to boot with small mem=...  and then grab memory through /dev/mem.
I suspect if that didn't work anymore there would be eventually
complaints too although there might be a case be made for not 
supporting that anymore.

BUt really /dev/mem is widely used and full compatibility is fairly
important.


> Other than the complicated code, do you see any issues of identity
> mapping only "usable" and "ACPI" regions as per e820? We can possible
> try to simplify the code, if that is the only concern.

The basic idea is fine.

-Andi

