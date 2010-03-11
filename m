Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0CKU7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:59:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab0CKU7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:59:45 -0500
Date: Thu, 11 Mar 2010 17:58:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka
 NPT-Virtualization)
Message-ID: <20100311205803.GA18849@amt.cnet>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <20100304144255.GA26657@amt.cnet>
 <20100304155820.GA6019@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304155820.GA6019@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 04:58:20PM +0100, Joerg Roedel wrote:
> On Thu, Mar 04, 2010 at 11:42:55AM -0300, Marcelo Tosatti wrote:
> > On Wed, Mar 03, 2010 at 08:12:03PM +0100, Joerg Roedel wrote:
> > > Hi,
> > > 
> > > here are the patches that implement nested paging support for nested
> > > svm. They are somewhat intrusive to the soft-mmu so I post them as RFC
> > > in the first round to get feedback about the general direction of the
> > > changes.  Nevertheless I am proud to report that with these patches the
> > > famous kernel-compile benchmark runs only 4% slower in the l2 guest as
> > > in the l1 guest when l2 is single-processor. With SMP guests the
> > > situation is very different. The more vcpus the guest has the more is
> > > the performance drop from l1 to l2. 
> > > Anyway, this post is to get feedback about the overall concept of these
> > > patches.  Please review and give feedback :-)
> > 
> > Joerg,
> > 
> > What perf gain does this bring ? (i'm not aware of the current
> > overhead).
> 
> The benchmark was an allnoconfig kernel compile in tmpfs which took with
> the same guest image:
> 
> as l1-guest with npt:
> 		
> 		2m23s
> 
> as l2-guest with l1(nested)-l2(shadow):
> 	
> 		around 8-9 minutes
> 
> as l2-guest with l1(nested)-l2(shadow) without the recent msrpm
> optimization:
> 
> 		around 19 minutes
> 
> as l2-guest with l1(nested)-l2(nested) [this patchset]:
> 
> 		2m25s-2m30s
> 
> > Overall comments:
> > 
> > Can't you translate l2_gpa -> l1_gpa walking the current l1 nested
> > pagetable, and pass that to the kvm tdp fault path (with the correct
> > context setup)?
> 
> If I understand your suggestion correctly, I think thats exactly whats
> done in the patches. Some words about the design:
> 
> For nested-nested we need to shadow the l1-nested-ptable on the host.
> This is done using the vcpu->arch.mmu context which holds the l1 paging
> modes while the l2 is running. On a npt-fault from the l2 we just
> instrument the shadow-ptable code. This is the common case. because it
> happens all the time while the l2 is running.

OK, makes sense now, I was missing the fact that the l1-nested-ptable   
needs to be shadowed and l1 translations to it must be write protected. 

You should disable out of sync shadow so that l1 guest writes to
l1-nested-ptables always trap. And in the trap case, you'd have to
invalidate l2 shadow pagetable entries that used the (now obsolete)
l1-nested-ptable entry. Does that happen automatically?

> The other thing is that vcpu->arch.mmu.gva_to_gpa is expected to still
> work and translate virtual addresses of the l2 into physical addresses
> of the l1 (so it can be accessed with kvm functions).
> 
> To do this we need to be aware of the L2 paging mode. It is stored in
> vcpu->arch.nested_mmu context. This context is only used for gva_to_gpa
> translations. It is not used to build shadow page tables or anything
> else. Thats the reason only the parts necessary for gva_to_gpa
> translations of the nested_mmu context are initialized.
> 
> Since we can not use mmu.gva_to_gpa to translate only between l2_gpa and
> l1_gpa because this function is required to translate l2_gva to l1_gpa
> by other parts of kvm, the function which does this translation is moved
> to nested_mmu.gva_to_gpa. So basically the gva_to_gpa function pointers
> are swapped between mmu and nested_mmu.
> 
> The nested_mmu.gva_to_gpa function is used in translate_gpa_nested which
> is assigned to the newly introduced translate_gpa callback of nested_mmu
> context.
> 
> This callback is used in the walk_addr function to translate every
> l2_gpa address we read from cr3 or the guest ptes into l1_gpa to read
> the next step from the guest memory.
> 
> In the old unnested case the translate_gpa callback would point to a
> function which just returns the gpa it is passed to it unmodified. The
> walk_addr function is generalized and now there are basically two
> versions of it:
> 
> 	* walk_addr which translates using vcpu->arch.mmu context
> 	* walk_addr_nested which translates using vcpu->arch.nested_mmu
> 	  context
> 
> Thats pretty much how these patches work.
> 
> > You probably need to include a flag in base_role to differentiate
> > between l1 / l2 shadow tables (say if they use the same cr3 value).
> 
> Not sure if this is necessary. It may be necessary when large pages come
> into play. Otherwise the host npt pages are distinguished by the shadow
> npt pages by the direct-flag.
> 
> 	Joerg
> 
