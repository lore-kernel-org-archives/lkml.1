Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbYAYVk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbYAYVk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbYAYVkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:40:13 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:27869 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbYAYVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:40:09 -0500
Message-ID: <479A5740.2060608@codemonkey.ws>
Date: Fri, 25 Jan 2008 15:40:16 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 4/8] X86: export information about NPT to
 generic x86 code
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-5-git-send-email-joerg.roedel@amd.com> <479A56B2.7010306@codemonkey.ws>
In-Reply-To: <479A56B2.7010306@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Joerg Roedel wrote:
>> The generic x86 code has to know if the specific implementation uses 
>> Nested
>> Paging. In the generic code Nested Paging is called Hardware Assisted 
>> Paging
>> (HAP) to avoid confusion with (future) HAP implementations of other 
>> vendors.
>> This patch exports the availability of HAP to the generic x86 code.
>>
>> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>> ---
>>  arch/x86/kvm/svm.c         |    7 +++++++
>>  arch/x86/kvm/vmx.c         |    7 +++++++
>>  include/asm-x86/kvm_host.h |    2 ++
>>  3 files changed, 16 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 2e718ff..d0bfdd8 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1678,6 +1678,11 @@ static bool svm_cpu_has_accelerated_tpr(void)
>>      return false;
>>  }
>>  
>> +static bool svm_hap_enabled(void)
>> +{
>> +    return npt_enabled;
>> +}
>> +
>>   
>
> To help with bisecting, you should probably return false here until 
> the patch that actually implements NPT support.  Otherwise, the 7th 
> patch in this series breaks KVM for SVM.

Ignore this, you're already doing the right thing :-)

Regards,

Anthony Liguori

> Regards,
>
> Anthony Liguori
>
>>  static struct kvm_x86_ops svm_x86_ops = {
>>      .cpu_has_kvm_support = has_svm,
>>      .disabled_by_bios = is_disabled,
>> @@ -1734,6 +1739,8 @@ static struct kvm_x86_ops svm_x86_ops = {
>>      .inject_pending_vectors = do_interrupt_requests,
>>  
>>      .set_tss_addr = svm_set_tss_addr,
>> +
>> +    .hap_enabled = svm_hap_enabled,
>>  };
>>  
>>  static int __init svm_init(void)
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 00a00e4..8feb775 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -2631,6 +2631,11 @@ static void __init 
>> vmx_check_processor_compat(void *rtn)
>>      }
>>  }
>>  
>> +static bool vmx_hap_enabled(void)
>> +{
>> +    return false;
>> +}
>> +
>>  static struct kvm_x86_ops vmx_x86_ops = {
>>      .cpu_has_kvm_support = cpu_has_kvm_support,
>>      .disabled_by_bios = vmx_disabled_by_bios,
>> @@ -2688,6 +2693,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
>>      .inject_pending_vectors = do_interrupt_requests,
>>  
>>      .set_tss_addr = vmx_set_tss_addr,
>> +
>> +    .hap_enabled = vmx_hap_enabled,
>>  };
>>  
>>  static int __init vmx_init(void)
>> diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
>> index 67ae307..45a9d05 100644
>> --- a/include/asm-x86/kvm_host.h
>> +++ b/include/asm-x86/kvm_host.h
>> @@ -392,6 +392,8 @@ struct kvm_x86_ops {
>>                         struct kvm_run *run);
>>  
>>      int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
>> +
>> +    bool (*hap_enabled)(void);
>>  };
>>  
>>  extern struct kvm_x86_ops *kvm_x86_ops;
>>   
>

