Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbZASJVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbZASJVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZASJU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:20:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33323 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZASJU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:20:57 -0500
Message-ID: <497445B6.7030606@redhat.com>
Date: Mon, 19 Jan 2009 11:19:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
References: <1232287474.3130.19.camel@localhost.localdomain> <20090118185635.GA30514@elte.hu>
In-Reply-To: <20090118185635.GA30514@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> (Avi Cc:-ed)
>
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>
>   
>>       headers_check fix: linux/kvm.h
>>     
>
>   
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index 5715f19..5d004bc 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -58,12 +58,14 @@ struct kvm_irqchip {
>>  	__u32 pad;
>>          union {
>>  		char dummy[512];  /* reserving space */
>> +#ifdef __KERNEL__
>>  #ifdef CONFIG_X86
>>  		struct kvm_pic_state pic;
>>  #endif
>>  #if defined(CONFIG_X86) || defined(CONFIG_IA64)
>>  		struct kvm_ioapic_state ioapic;
>>  #endif
>> +#endif /* __KERNEL__ */
>>  	} chip;
>>  };
>>     
>
> Avi, does user-space need the kvm_irqchip definition from this header? If 
> not then it would be cleaner to mark this whole structure as #ifdef 
> __KERNEL__.
>
>   

It does.  This patch will break userspace.

Doesn't 'make headers_install' unifder the CONFIG_ stuff?

>> @@ -384,18 +386,24 @@ struct kvm_trace_rec {
>>  #define KVM_CAP_MP_STATE 14
>>  #define KVM_CAP_COALESCED_MMIO 15
>>  #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
>> +#ifdef __KERNEL__
>>  #if defined(CONFIG_X86)||defined(CONFIG_IA64)
>>  #define KVM_CAP_DEVICE_ASSIGNMENT 17
>>  #endif
>> +#endif /* __KERNEL__ */
>>  #define KVM_CAP_IOMMU 18
>> +#ifdef __KERNEL__
>>  #if defined(CONFIG_X86)
>>  #define KVM_CAP_DEVICE_MSI 20
>>  #endif
>> +#endif /* __KERNEL__ */
>>  /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
>>  #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
>> +#ifdef __KERNEL__
>>  #if defined(CONFIG_X86)
>>  #define KVM_CAP_USER_NMI 22
>>  #endif
>> +#endif /* __KERNEL__ */
>>     
>
> likewise, are these bits really used by user-space KVM bits? If not then 
> the whole thing could go into an #ifdef __KERNEL__ block.
>   

They are.  This bits advertise to userspace what features kvm supports, 
both compile- and run-time.

-- 
error compiling committee.c: too many arguments to function

