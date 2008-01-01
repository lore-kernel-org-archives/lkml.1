Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbYAAQfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbYAAQfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYAAQf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:35:28 -0500
Received: from il.qumranet.com ([82.166.9.18]:38879 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbYAAQf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:35:28 -0500
Message-ID: <477A6BCE.7070808@qumranet.com>
Date: Tue, 01 Jan 2008 18:35:26 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH 21/54] KVM: Export include/linux/kvm.h only if $ARCH actually
 supports KVM
References: <1199201780-14001-1-git-send-email-avi@qumranet.com> <1199201780-14001-22-git-send-email-avi@qumranet.com> <20080101162200.GA30024@uranus.ravnborg.org>
In-Reply-To: <20080101162200.GA30024@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Jan 01, 2008 at 05:35:47PM +0200, Avi Kivity wrote:
>   
>> Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
>> includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export kvm.h
>> only if the arch actually supports it.
>>
>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>> ---
>>  arch/x86/Kconfig     |    4 ++++
>>  drivers/kvm/Kconfig  |    4 ++--
>>  include/linux/Kbuild |    2 +-
>>  3 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 80b7ba4..e029a93 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -116,6 +116,10 @@ config ARCH_SUPPORTS_OPROFILE
>>  	bool
>>  	default y
>>  
>> +config ARCH_SUPPORTS_KVM
>> +	bool
>> +	default y
>> +
>>  
>>  config ZONE_DMA32
>>  	bool
>> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
>> index 6569206..4086080 100644
>> --- a/drivers/kvm/Kconfig
>> +++ b/drivers/kvm/Kconfig
>> @@ -3,7 +3,7 @@
>>  #
>>  menuconfig VIRTUALIZATION
>>  	bool "Virtualization"
>> -	depends on X86
>> +	depends on ARCH_SUPPORTS_KVM || X86
>>  	default y
>>  	---help---
>>  	  Say Y here to get to see options for using your Linux host to run other
>> @@ -16,7 +16,7 @@ if VIRTUALIZATION
>>  
>>  config KVM
>>  	tristate "Kernel-based Virtual Machine (KVM) support"
>> -	depends on X86 && EXPERIMENTAL
>> +	depends on ARCH_SUPPORTS_KVM && EXPERIMENTAL
>>  	select PREEMPT_NOTIFIERS
>>  	select ANON_INODES
>>  	---help---
>>     
>
> An approach like the following is preferred:
> kvm/Kconfig:
>
> # config symbols to be selected by archs that implment virtualization/kvm
> config HAVE_VIRTUALIZATION
> config HAVE_KVM
>
> menuconfig VIRTUALIZATION
> 	bool "..."
> 	depends on HAVE_VIRTUALIZATION
>
> config KVM
> 	tristate "..."
> 	depends on HAVE_KVM
>
> arch/x86/Kconfig:
>
> config X86
> 	select HAVE_VIRTUALIZATION
> 	select HAVE_KVM
>
>
> I dunno about the additional "HAVE_VIRTUALIZATION" - I added it
> because I assume virtualization is more than just kvm.
>
> The rationales behinds this approach is:
>
> -> We do not define a new config variable for each arch
> -> We have a common way to say that an arch supports a feature
> -> We have a common naming scheme
>   

I think my ARCH_SUPPORTS_KVM is exactly your HAVE_KVM.  I'll update the 
patch to rename the variable and to have x86 select it instead of 
defining it (which is clearly better) as you suggest.

I'll also apply your HAVE_VIRTUALIZATION suggestion.  Thanks for the 
review, comments, and explanations.

-- 
error compiling committee.c: too many arguments to function

