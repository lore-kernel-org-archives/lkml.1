Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZI0Iyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZI0Iyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZI0Iym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:54:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbZI0Iym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:54:42 -0400
Message-ID: <4ABF2851.5090302@redhat.com>
Date: Sun, 27 Sep 2009 10:54:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH: kvm 4/5] Fix hotremove of CPUs for KVM.
References: <20090924151049.GB14102@amt.cnet> <1253839640-12695-1-git-send-email-zamsden@redhat.com> <1253839640-12695-2-git-send-email-zamsden@redhat.com> <1253839640-12695-3-git-send-email-zamsden@redhat.com> <1253839640-12695-4-git-send-email-zamsden@redhat.com> <1253839640-12695-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1253839640-12695-5-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2009 03:47 AM, Zachary Amsden wrote:
> In the process of bringing down CPUs, the SVM / VMX structures associated
> with those CPUs are not freed.  This may cause leaks when unloading and
> reloading the KVM module, as only the structures associated with online
> CPUs are cleaned up.  So, clean up all possible CPUs, not just online ones.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> ---
>   arch/x86/kvm/svm.c |    2 +-
>   arch/x86/kvm/vmx.c |    7 +++++--
>   2 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 8f99d0c..13ca268 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -525,7 +525,7 @@ static __exit void svm_hardware_unsetup(void)
>   {
>   	int cpu;
>
> -	for_each_online_cpu(cpu)
> +	for_each_possible_cpu(cpu)
>   		svm_cpu_uninit(cpu);
>
>   	__free_pages(pfn_to_page(iopm_base>>  PAGE_SHIFT), IOPM_ALLOC_ORDER);
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index b8a8428..603bde3 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -1350,8 +1350,11 @@ static void free_kvm_area(void)
>   {
>   	int cpu;
>
> -	for_each_online_cpu(cpu)
> -		free_vmcs(per_cpu(vmxarea, cpu));
> +	for_each_possible_cpu(cpu)
> +		if (per_cpu(vmxarea, cpu)) {
> +			free_vmcs(per_cpu(vmxarea, cpu));
> +			per_cpu(vmxarea, cpu) = NULL;
> +		}
>   }
>
>   static __init int alloc_kvm_area(void)
>    

First, I'm not sure per_cpu works for possible but not actual cpus.  
Second, we now eagerly allocate but lazily free, leading to lots of ifs 
and buts.  I think the code can be cleaner by eagerly allocating and 
eagerly freeing.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

