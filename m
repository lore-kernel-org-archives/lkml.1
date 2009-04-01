Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbZDABWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbZDABWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZDABWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:22:38 -0400
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:40888 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755233AbZDABWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:22:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ku758B1kBLL5cOt5gJWYed/DFuYFE75qrLM0BvmO3ZNI4MuqETMKaAaKHSumKWjQ1O91wWNDZlVT6gL/6Hsij6foJ93tdXlwgUhZIiPbG8JKa6LNO8n0NZaLLoF9VRMO;
Date: Tue, 31 Mar 2009 18:22:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: suresh.b.siddha@intel.com
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: PAGE_CACHE_WC strikes again
Message-ID: <20090331182231.4620df87@hobbes>
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

Ok so we use set_memory_wc/wb in the physical mapping stuff, which I
think is fine.  We also use io_mapping_create_wc on the whole aperture
at load time.  That will take care of any pages we map there right?  So
along with this fix I think we'll be ok?

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index c1173d8..fa828a8 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -538,11 +538,7 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_ops = obj->dev->driver->gem_vm_ops;
 	vma->vm_private_data = map->handle;
 	/* FIXME: use pgprot_writecombine when available */
-	prot = pgprot_val(vma->vm_page_prot);
-#ifdef CONFIG_X86
-	prot |= _PAGE_CACHE_WC;
-#endif
-	vma->vm_page_prot = __pgprot(prot);
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
 	/* Take a ref for this mapping of the object, so that the fault
 	 * handler can dereference the mmap offset's pointer to the object.



