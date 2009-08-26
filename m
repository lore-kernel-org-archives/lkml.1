Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbZHZOdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbZHZOdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZHZOdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZHZOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:33:16 -0400
Message-ID: <4A9547A6.1000902@redhat.com>
Date: Wed, 26 Aug 2009 17:33:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/47] KVM: VMX: Optimize vmx_get_cpl()
References: <1251282609-12835-1-git-send-email-avi@redhat.com> <1251282609-12835-6-git-send-email-avi@redhat.com> <4A95437C.2060707@gmail.com>
In-Reply-To: <4A95437C.2060707@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 05:15 PM, Roel Kluin wrote:
> Op 26-08-09 12:29, Avi Kivity schreef:
>    
>> Instead of calling vmx_get_segment() (which reads a whole bunch of
>> vmcs fields), read only the cs selector which contains the cpl.
>>
>> Signed-off-by: Avi Kivity<avi@redhat.com>
>>      
> Can't we also optimise cs_ss_rpl_check()? (Please review, untested.)
>
> ------------->8 ---------------------- 8<  --------------------
> Instead of calling vmx_get_segment() (which reads a whole bunch of
> vmcs fields), read only the cs/ss selectors which contains the rpls.
>
>    

It's really a slowpath, so I prefer not to touch it.  We're likely to 
start caching guest segment fields soon, so the less code that reads 
them directly, the better.

> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>
> ---
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 29f9129..5d8512a 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -1932,13 +1932,8 @@ static bool ldtr_valid(struct kvm_vcpu *vcpu)
>
>   static bool cs_ss_rpl_check(struct kvm_vcpu *vcpu)
>   {
> -	struct kvm_segment cs, ss;
> -
> -	vmx_get_segment(vcpu,&cs, VCPU_SREG_CS);
> -	vmx_get_segment(vcpu,&ss, VCPU_SREG_SS);
> -
> -	return ((cs.selector&  SELECTOR_RPL_MASK) ==
> -		 (ss.selector&  SELECTOR_RPL_MASK));
> +	return ((vmcs_read16(GUEST_CS_SELECTOR)&  SELECTOR_RPL_MASK) ==
> +		 (vmcs_read16(GUEST_SS_SELECTOR)&  SELECTOR_RPL_MASK));
>   }
>
>   /*
>    


-- 
error compiling committee.c: too many arguments to function

