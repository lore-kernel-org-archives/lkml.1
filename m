Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZDAAt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZDAAt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZDAAts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:49:48 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:55874 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752841AbZDAAtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:49:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=TlKnoh0vZkjg3jB5thejcH/uxS2zz+MRd7MvRVidkisAezSAN417oAuwQdSrZHuGNZA4AQ+X228iZvQk+fVvlQf55ceZkfIUKT7yAfIaJ5yELoQRdZXvgbgCwqrShLXg;
Date: Tue, 31 Mar 2009 17:49:43 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Eric Anholt <eric@anholt.net>, lkml <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: PAGE_CACHE_WC strikes again
Message-ID: <20090331174943.59fabcb8@hobbes>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
	<20090331171431.69ad044f@hobbes>
	<7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 17:29:02 -0700
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

>  
> 
> >-----Original Message-----
> >From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org] 
> >Sent: Tuesday, March 31, 2009 5:15 PM
> >To: Eric Anholt
> >Cc: lkml; Pallipadi, Venkatesh
> >Subject: Re: PAGE_CACHE_WC strikes again
> >
> >On Tue, 31 Mar 2009 17:10:47 -0700
> >Eric Anholt <eric@anholt.net> wrote:
> >
> >> I just tracked down what was cutting performance 10x on one of my
> >> systems on a microbenchmark I'd just written:
> >> 
> >> --- a/drivers/gpu/drm/drm_gem.c
> >> +++ b/drivers/gpu/drm/drm_gem.c
> >> @@ -540,7 +540,7 @@ int drm_gem_mmap(struct file *filp, struct
> >> vm_area_struct *vma)
> >>  	/* FIXME: use pgprot_writecombine when available */
> >>  	prot = pgprot_val(vma->vm_page_prot);
> >>  #ifdef CONFIG_X86
> >> -	prot |= _PAGE_CACHE_WC;
> >> +	/*prot |= _PAGE_CACHE_WC;*/
> >>  #endif
> >>  	vma->vm_page_prot = __pgprot(prot);
> >>  
> >> Turns out that setting PAGE_CACHE_WC disables the WC effect of the
> >> MTRR on my non-PAT (disabled due to CPU errata) 945GM 
> >system, and this
> >> workaround took GTT-mapped writes from 120MB/s to 1180MB/s.
> >
> >What the...  There's a pgprot_writecombine now, but it basically does
> >the same thing.  Why is WC so broken?  Venki is the fix for this
> >covered in your last patchset?
> >
> 
> The key point here is 
> 
> > setting PAGE_CACHE_WC disables the WC effect of the
> > MTRR on my non-PAT (disabled due to CPU errata)
> 
> When PAT is disabled, the default setting in PAT MSR is
> 00 - WB
> 01 - WT
> 10 - UC_MINUS
> 11 - UC
> 
> There is no way to set WC with PAT. By hardcoding _PAGE_CACHE_WC
> (which is 01) the driver is basically selecting write-through!
> 
> And when MTRR says WC and PAT says WT, effective type is UC.
> 
> Basically, no one should be hard-coding the memory type. Please use
> pgprot_writecombine() which does the right thing by using WC
> (when PAT is enabled) or UC_MINUS (when PAT is disabled).

Ah ok, that makes sense.  I'm glad we have pgprot_writecombine now
(sorry Eric I should have sent that patch along with my patch
containing the vm_insert_pfn -EINVAL handling).

-- 
Jesse Barnes, Intel Open Source Technology Center
