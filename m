Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbZCFNG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbZCFNG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZCFNGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:06:45 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52448 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZCFNGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:06:44 -0500
X-BigFish: VPS-31(zba6iz1432R98dR148cM1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KG35Q7-03-1DV-01
Date: Fri, 6 Mar 2009 14:06:05 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] kvm/x86/mmu: handle invlpg on large pages
Message-ID: <20090306130605.GH8751@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com> <1236255153-4432-5-git-send-email-joerg.roedel@amd.com> <20090305211122.GA5660@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090305211122.GA5660@amt.cnet>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Mar 2009 13:06:05.0895 (UTC) FILETIME=[4F27AD70:01C99E5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 06:11:22PM -0300, Marcelo Tosatti wrote:
> On Thu, Mar 05, 2009 at 01:12:31PM +0100, Joerg Roedel wrote:
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kvm/paging_tmpl.h |   12 +++++++++---
> >  1 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> > index 79668ba..aa79396 100644
> > --- a/arch/x86/kvm/paging_tmpl.h
> > +++ b/arch/x86/kvm/paging_tmpl.h
> > @@ -441,6 +441,7 @@ out_unlock:
> >  static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
> >  {
> >  	struct kvm_shadow_walk_iterator iterator;
> > +	struct kvm_mmu_page *sp;
> >  	pt_element_t gpte;
> >  	gpa_t pte_gpa = -1;
> >  	int level;
> > @@ -451,12 +452,17 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
> >  	for_each_shadow_entry(vcpu, gva, iterator) {
> >  		level = iterator.level;
> >  		sptep = iterator.sptep;
> > +		sp = page_header(__pa(sptep));
> > +
> > +		if (sp->role.direct) {
> > +			/* mapped from a guest's large_pte */
> > +			kvm_mmu_zap_page(vcpu->kvm, sp);
> > +			kvm_flush_remote_tlbs(vcpu->kvm);
> > +			return;
> > +		}
> 
> If the guest has 32-bit pte's there might be:
> 
> - two large shadow entries to cover 4MB
> - one large shadow entry and one shadow page with 512 4k entries
> - two shadow pages with 512 4k entries each
> 
> So need to cover all this cases.

Right. Thanks for pointing this out. I will post an updated version of
this patch.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

