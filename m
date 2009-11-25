Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbZKYNEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbZKYNEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934639AbZKYNEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:04:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934638AbZKYNEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:04:04 -0500
Message-ID: <4B0D2B22.4030403@redhat.com>
Date: Wed, 25 Nov 2009 15:03:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com
Subject: Re: [PATCH v2 08/12] Inject asynchronous page fault into a guest
 if page is swapped out.
References: <1258985167-29178-1-git-send-email-gleb@redhat.com> <1258985167-29178-9-git-send-email-gleb@redhat.com>
In-Reply-To: <1258985167-29178-9-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 04:06 PM, Gleb Natapov wrote:
> If guest access swapped out memory do not swap it in from vcpu thread
> context. Setup slow work to do swapping and send async page fault to
> a guest.
>
> Allow async page fault injection only when guest is in user mode since
> otherwise guest may be in non-sleepable context and will not be able to
> reschedule.
>
> +
> +void kvm_arch_inject_async_page_present(struct kvm_vcpu *vcpu,
> +					struct kvm_async_pf *work)
> +{
> +	put_user(KVM_PV_REASON_PAGE_READY, vcpu->arch.apf_data);
> +	kvm_inject_page_fault(vcpu, work->arch.token, 0);
> +	trace_kvm_send_async_pf(work->arch.token, work->gva,
> +				KVM_PV_REASON_PAGE_READY);
> +}
>    

What if the guest is now handling a previous asynv pf or ready 
notification?  We're clobbering the data structure.

> +
> +bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
> +{
> +	return !kvm_event_needs_reinjection(vcpu)&&
> +		kvm_x86_ops->interrupt_allowed(vcpu);
> +}
>    

Okay, so this is only allowed with interrupts disabled.  Need to make 
sure the entire pf path up to async pf executes with interrupts disabled.

-- 
error compiling committee.c: too many arguments to function

