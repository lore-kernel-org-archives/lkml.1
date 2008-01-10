Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYAJMjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYAJMjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYAJMjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:39:43 -0500
Received: from ns2.suse.de ([195.135.220.15]:50265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbYAJMjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:39:43 -0500
Date: Thu, 10 Jan 2008 13:39:40 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110123940.GT25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110104351.GC28209@elte.hu> <20080110110704.GQ25945@bingen.suse.de> <20080110122204.GA25129@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110122204.GA25129@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 01:22:04PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > > What is very real though are the hard limitations of MTRRs. So i'd 
> > > rather first like to see a clean PAT approach (which all other 
> > > modern OSs have already migrated to in the past 10 years)
> > 
> > That's mostly orthogonal. Don't know why you bring it up now?
> 
> because the PAT (Page Attribute Table support) patchset and the CPA 
> (change_page_attr()) patchset are are not orthogonal at all - as their 
> name already signals: because they change the implementation/effects of 
> the same interface(s). [just at different levels].
> 
> Both patchsets change how the kernel pagetable caching is handled. PAT 
> changes the kernel pte details and unshackles us from MTRR reliance and 
> thus solves real problems on real boxes:
> 
>  55 files changed, 1288 insertions(+), 237 deletions(-)
> 
> CPA moves change_page_attr() from invwb flushing to cflush flushing, for 
> a speedup/latency-win, plus a whole bunch of intermingled fixes and 
> improvements to page attribute modification:
> 
>  26 files changed, 882 insertions(+), 423 deletions(-)
> 
> so in terms of risk management, the "perfect patch order" is:
> 
>  - minimal_set of correctness fixes to the highlevel cpa code.

The two clear bug fix patches are refcount and flush order.

refcnt could be moved earlier; flush order would be quite painful
because there are quite a lot of patches dependent on it.

I could move ref count earlier, but I would prefer not to because
of the significant work it would be for me. 

Since it is all already bisectable I'm also not sure what debugging
advantages the reordering would be. 

It's already bisectable (I have not booted all immediate steps,
but several of them and I believe all compile) and in small pieces for that.

If it's really broken it would need to be reverted and then the ref count 
stuff would go too.  But I hope that won't be needed. 

And even losing the reference count fixes wouldn't be catastrophic -- in the
worst case you lose some minor performance because kernel mappings are 
unnecessarily split to 4K pages, but it's not a correctness fix. 

So while the reordering would be possible, it would imho not
bring very much advantages and I must admit I'm not too motivated
to do another time-consuming reordering for a relatively weak reason.  

If it was a 5 patch series I would probably not complain too much
about this, but it's 25+ patches.

>  - ( then any provably NOP cleanups to pave the way. )
> 
>  - then change the lowlevel pte code (PAT) to reduce/eliminate the need 
>    to have runtime MTRR use

That's a completely different area really. Most of the PAT code
has nothing to do with clear_page_attr(). Please think that through
again after reading both patchkits.

As far as I can see making it wait for PAT would mean delaying
it for a longer time which would be a pity.


>  - then structural improvements/cleanups of the highlevel cpa code
> 
>  - then the cflush (optional) performance feature ontop of it.

There are actual a lot more performance features in there (self snoop,
minimal TLB flushing some other stuff). Most of it is related to 
that in fact.
 
> 
>  - then gigabyte-largepages/TLBs support [new CPU feature that further
>    complicates page-attribute management]

That's already at the end.

> 
> All in an easy-to-revert fashion. We _will_ regress here, and this stuff 

That's already the case.

-Andi

