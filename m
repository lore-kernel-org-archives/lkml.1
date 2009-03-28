Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbZC1WE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbZC1WE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbZC1WEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:04:33 -0400
Received: from 8bytes.org ([88.198.83.132]:39231 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761525AbZC1WEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:04:32 -0400
Date: Sat, 28 Mar 2009 23:04:29 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: add support for 1GB pages in shadow paging
	code
Message-ID: <20090328220429.GF31080@8bytes.org>
References: <1238164518-16261-1-git-send-email-joerg.roedel@amd.com> <20090328212834.GA4694@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328212834.GA4694@amt.cnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 06:28:35PM -0300, Marcelo Tosatti wrote:
> > I have searched this bug for quite some time with no real luck. Maybe
> > some other reviewers have more luck than I had by now.
> 
> Sorry, I can't spot what is wrong here. Avi?
> 
> Perhaps it helps if you provide some info of the hang when guest
> allocates hugepages on boot (its probably and endless fault that can't
> be corrected?).

I will try to find out why the guest stucks. I also created a full
mmu trace of a boot crash case. But its size was around 170MB and I
found no real problem there.

> Also another point is that the large huge page at 0-1GB will never
> be created, because it crosses slot boundary.

The instabilies only occur if the guest has enough memory to use a
gbpage in its own direct mapping. They also go away when I boot it with
nogbpages command line option. So its likely that is has something to do
with the processing of guest gbpages in the softmmu code. But I looked
over this code again and again. There seems to be no bug.

> 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kvm/mmu.c         |   56 +++++++++++++++++++++++++++++++------------
> >  arch/x86/kvm/paging_tmpl.h |   35 +++++++++++++++++++++------
> >  arch/x86/kvm/svm.c         |    2 +-
> >  3 files changed, 68 insertions(+), 25 deletions(-)
> > 
> > +	psize = backing_size(vcpu, vcpu->arch.update_pte.gfn);
> 
> This can block, and this path holds mmu_lock. Thats why it needs to be
> done in guess_page_from_pte_write.

Ah true. Thanks for pointing this out. The previous code in the
guess_page function makes sense now.

> > +	if ((sp->role.level == PT_DIRECTORY_LEVEL) &&
> > +	    (psize >= KVM_PAGE_SIZE_2M)) {
> > +		psize = KVM_PAGE_SIZE_2M;
> > +		vcpu->arch.update_pte.gfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
> > +		vcpu->arch.update_pte.pfn &= ~(KVM_PAGES_PER_2M_PAGE-1);
> > +	} else if ((sp->role.level == PT_MIDDLE_LEVEL) &&
> > +		   (psize == KVM_PAGE_SIZE_1G)) {
> > +		vcpu->arch.update_pte.gfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
> > +		vcpu->arch.update_pte.pfn &= ~(KVM_PAGES_PER_1G_PAGE-1);
> > +	} else
> > +		goto out_pde;
> 
> Better just zap the entry in case its a 1GB one and let the
> fault path handle it.

Yes, that probably better.

	Joerg

