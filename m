Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0CHJhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:37:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0CHJh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:37:27 -0500
Message-ID: <4B94C552.30604@redhat.com>
Date: Mon, 08 Mar 2010 11:37:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] KVM: MMU: Add infrastructure for two-level page
 walker
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <1267643541-451-12-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267643541-451-12-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 09:12 PM, Joerg Roedel wrote:
> This patch introduces a mmu-callback to translate gpa
> addresses in the walk_addr code. This is later used to
> translate l2_gpa addresses into l1_gpa addresses.
>
> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    1 +
>   arch/x86/kvm/mmu.c              |    7 +++++++
>   arch/x86/kvm/paging_tmpl.h      |   19 +++++++++++++++++++
>   include/linux/kvm_host.h        |    5 +++++
>   4 files changed, 32 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c0b5576..76c8b5f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -250,6 +250,7 @@ struct kvm_mmu {
>   	void (*free)(struct kvm_vcpu *vcpu);
>   	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
>   			    u32 *error);
> +	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error);
>   	void (*prefetch_page)(struct kvm_vcpu *vcpu,
>   			      struct kvm_mmu_page *page);
>   	int (*sync_page)(struct kvm_vcpu *vcpu,
>    

I think placing this here means we will miss a few translations, namely 
when we do a physical access (say, reading PDPTEs or similar).

We need to do this on the level of kvm_read_guest() so we capture 
physical accesses:

kvm_read_guest_virt
   -> walk_addr
      -> kvm_read_guest_tdp
          -> kvm_read_guest_virt
             -> walk_addr
                 -> kvm_read_guest_tdp
                      -> kvm_read_guest

Of course, not all accesses will use kvm_read_guest_tdp; for example 
kvmclock accesses should still go untranslated.

-- 
error compiling committee.c: too many arguments to function

