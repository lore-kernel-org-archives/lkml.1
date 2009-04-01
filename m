Return-Path: <linux-kernel-owner+w=401wt.eu-S1762365AbZDABNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762365AbZDABNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZDABM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:12:58 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:54894 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752734AbZDABM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:12:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=q2iScFdwaseeddKegpEyJwhNeoEMaciCrlNDmQ9UMS9VQ5Z50q1dzVg6G3c5U3GR4ZJSxMw/pT5xXMCraY8hYoVfBy1yCjpeBk597uEJFEysyCtWSSWSr6CzciL9KSHY;
Date: Tue, 31 Mar 2009 18:12:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: suresh.b.siddha@intel.com
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: PAGE_CACHE_WC strikes again
Message-ID: <20090331181251.46cf95b1@hobbes>
In-Reply-To: <1238547790.27006.7743.camel@localhost.localdomain>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
	<20090331171431.69ad044f@hobbes>
	<7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
	<1238547790.27006.7743.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 17:03:10 -0800
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Tue, 2009-03-31 at 17:29 -0700, Pallipadi, Venkatesh wrote:
> > The key point here is 
> > 
> > > setting PAGE_CACHE_WC disables the WC effect of the
> > > MTRR on my non-PAT (disabled due to CPU errata)
> > 
> > When PAT is disabled, the default setting in PAT MSR is
> > 00 - WB
> > 01 - WT
> > 10 - UC_MINUS
> > 11 - UC
> > 
> > There is no way to set WC with PAT. By hardcoding _PAGE_CACHE_WC
> > (which is 01) the driver is basically selecting write-through!
> > 
> > And when MTRR says WC and PAT says WT, effective type is UC.
> > 
> > Basically, no one should be hard-coding the memory type. Please use
> > pgprot_writecombine() which does the right thing by using WC
> > (when PAT is enabled) or UC_MINUS (when PAT is disabled).
> 
> And the driver should use right API to track the underlying page frame
> thats getting mapped by this vma, with the corresponding attribute.
> API's like remap_pfn_range(), vm_insert_pfn() will setup the PTE's
> aswell as track the pfn's attributes.
> 
> API's like set_memory_uc/wc() will explicitly setup the page
> attributes.
> 
> Jesse, As far as I see, the drm GEM fault handler routines don't seem
> to do any of this. Am I missing something? We need to fix this so
> that we can avoid potential aliasing issues.

Right, the drm driver code went in before we had pgprot_writecombine.
Now that it's available we should definitely use it.  I'm not sure
about the set_memory_* routines though; we create io mappings in
i915_dma.c at init time, and I thought we took care of things in
i915_gem.c but we may need updates there.

-- 
Jesse Barnes, Intel Open Source Technology Center
