Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbYKOHke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbYKOHke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 02:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYKOHkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 02:40:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:52306 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbYKOHkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 02:40:25 -0500
Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H.Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hugh@veritas.com>,
       Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.com>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20081112232312.GB29363@wotan.suse.de>
References: <20081112212647.259698000@intel.com>
	 <20081112212900.151113000@intel.com> <20081112232312.GB29363@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 15 Nov 2008 18:38:27 +1100
Message-Id: <1226734707.7178.163.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 00:23 +0100, Nick Piggin wrote:
> You have to be careful of this, because it can be called with mmap_sem
> held for read only. Hmm, I guess vm_insert_page is doing the same thing.
> Probably mostly works because all other modifiers of vm_flags are holding
> mmap_sem.
> 
> However, in some cases, code can do vm_insert_pfn and vm_insert_page
> (actually hmm, no vm_insert_mixed actually should cover most of those
> cases).
> 
> Still, I'd be much happier if we could make these into BUG_ON, and then
> teach callers to set it in their .mmap routines.

Agreed. I don't think vm_insert_* is the right place to muck
with that ..

Ben.

>  
> On Wed, Nov 12, 2008 at 01:26:49PM -0800, Venkatesh Pallipadi wrote:
> > vm_insert_pfn() is not setting the VM_PFNMAP flag in vma. Fix that.
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > 
> > ---
> >  mm/memory.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: tip/mm/memory.c
> > ===================================================================
> > --- tip.orig/mm/memory.c	2008-11-06 09:44:56.000000000 -0800
> > +++ tip/mm/memory.c	2008-11-10 09:44:47.000000000 -0800
> > @@ -1444,6 +1444,8 @@ int vm_insert_pfn(struct vm_area_struct 
> >  
> >  	if (addr < vma->vm_start || addr >= vma->vm_end)
> >  		return -EFAULT;
> > +
> > +	vma->vm_flags |= VM_PFNMAP;
> >  	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
> >  }
> >  EXPORT_SYMBOL(vm_insert_pfn);
> > 
> > -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

