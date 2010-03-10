Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0CJOqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:46:17 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:41818
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756498Ab0CJOqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:46:15 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz1432R98dN936eM1442J9371Pab9bhzz1202hzzz32i2a8h6bh87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KZ2MCP-02-CJC-02
X-M-MSG: 
Date: Wed, 10 Mar 2010 15:46:00 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] KVM: MMU: Add infrastructure for two-level page
 walker
Message-ID: <20100310144600.GL5619@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
 <1267643541-451-12-git-send-email-joerg.roedel@amd.com>
 <4B94C552.30604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B94C552.30604@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Mar 2010 14:46:00.0709 (UTC) FILETIME=[66C57350:01CAC060]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 11:37:22AM +0200, Avi Kivity wrote:
> On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> >This patch introduces a mmu-callback to translate gpa
> >addresses in the walk_addr code. This is later used to
> >translate l2_gpa addresses into l1_gpa addresses.
> >
> >Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >---
> >  arch/x86/include/asm/kvm_host.h |    1 +
> >  arch/x86/kvm/mmu.c              |    7 +++++++
> >  arch/x86/kvm/paging_tmpl.h      |   19 +++++++++++++++++++
> >  include/linux/kvm_host.h        |    5 +++++
> >  4 files changed, 32 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >index c0b5576..76c8b5f 100644
> >--- a/arch/x86/include/asm/kvm_host.h
> >+++ b/arch/x86/include/asm/kvm_host.h
> >@@ -250,6 +250,7 @@ struct kvm_mmu {
> >  	void (*free)(struct kvm_vcpu *vcpu);
> >  	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
> >  			    u32 *error);
> >+	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error);
> >  	void (*prefetch_page)(struct kvm_vcpu *vcpu,
> >  			      struct kvm_mmu_page *page);
> >  	int (*sync_page)(struct kvm_vcpu *vcpu,
> 
> I think placing this here means we will miss a few translations,
> namely when we do a physical access (say, reading PDPTEs or
> similar).
> 
> We need to do this on the level of kvm_read_guest() so we capture
> physical accesses:
> 
> kvm_read_guest_virt
>   -> walk_addr
>      -> kvm_read_guest_tdp
>          -> kvm_read_guest_virt
>             -> walk_addr
>                 -> kvm_read_guest_tdp
>                      -> kvm_read_guest
> 
> Of course, not all accesses will use kvm_read_guest_tdp; for example
> kvmclock accesses should still go untranslated.

Ok, doing the translation in kvm_read_guest is certainly the more
generic approach. I already fixed a bug related to loading l2 pdptr
pointers. Doing the translation in kvm_read_guest makes the code a lot
nicer.

	Joerg


