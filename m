Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbZFWRAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbZFWRAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760024AbZFWRAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:00:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:19330 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759296AbZFWRAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:00:33 -0400
X-SpamScore: -24
X-BigFish: VPS-24(z34a4jz1432R98dR4015L1805Mzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KLPB89-04-MNN-01
Date: Tue, 23 Jun 2009 19:00:12 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] kvm/mmu: rename is_largepage_backed to
	mapping_level
Message-ID: <20090623170012.GH5139@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <1245417389-5527-4-git-send-email-joerg.roedel@amd.com> <20090623155933.GA3651@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090623155933.GA3651@amt.cnet>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 23 Jun 2009 17:00:13.0199 (UTC) FILETIME=[1306E9F0:01C9F424]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 12:59:33PM -0300, Marcelo Tosatti wrote:
> Hi Joerg,
> 
> On Fri, Jun 19, 2009 at 03:16:24PM +0200, Joerg Roedel wrote:
> >  	gfn = unalias_gfn(kvm, gfn);
> > -	write_count = slot_largepage_idx(gfn,
> > -					 gfn_to_memslot_unaliased(kvm, gfn));
> > -	*write_count += 1;
> > +
> > +	for (i = PT_DIRECTORY_LEVEL;
> > +	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
> > +		slot          = gfn_to_memslot_unaliased(kvm, gfn);
> 
> Can't you move this call out of the loop?

True. Will do this.

> > @@ -1704,7 +1739,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >  	if ((pte_access & ACC_WRITE_MASK)
> >  	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
> >  
> > -		if (largepage && has_wrprotected_page(vcpu->kvm, gfn)) {
> > +		if (largepage && has_wrprotected_page(vcpu->kvm, gfn, 1)) {
> 
> It seems direct_map is missing the large pte overwrite check that
> fetch() contains:
> 
>                 if (is_large_pte(*sptep)) {
>                         rmap_remove(vcpu->kvm, sptep);
>                         __set_spte(sptep, shadow_trap_nonpresent_pte);
>                         kvm_flush_remote_tlbs(vcpu->kvm);
>                 }
> 
> (perhaps its not a possible scenario at the moment, but...).


This function is only called from mmu_set_spte which takes care of this.

Thanks,

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

