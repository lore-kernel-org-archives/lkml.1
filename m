Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbZANDtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbZANDtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZANDtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:49:31 -0500
Received: from fall-lakeland.atl.sa.earthlink.net ([207.69.195.103]:57450 "EHLO
	fall-lakeland.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZANDta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:49:30 -0500
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 22:49:30 EST
Message-ID: <496D5E19.7040802@earthlink.net>
Date: Tue, 13 Jan 2009 22:38:01 -0500
From: Robert Reif <reif@earthlink.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>,
       "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: =?windows-1252?Q?Re=3A_sparc32_compile_error=3A_redefini?=
 =?windows-1252?Q?tion_of_=91smp=5Fcall=5Ffunction=5Fsingle=92?=
References: <496D4274.6000304@earthlink.net>	<20090113.181039.185575172.davem@davemloft.net>	<20090113184239.e6b6e68e.akpm@linux-foundation.org> <20090113184536.95ebc973.akpm@linux-foundation.org>
In-Reply-To: <20090113184536.95ebc973.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 13 Jan 2009 18:42:39 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> On Tue, 13 Jan 2009 18:10:39 -0800 (PST) David Miller <davem@davemloft.net> wrote:
>>
>>     
>>> From: Robert Reif <reif@earthlink.net>
>>> Date: Tue, 13 Jan 2009 20:40:04 -0500
>>>
>>>       
>>>> Todays git produces this compile error on sparc32:
>>>>
>>>> kernel/up.c:10: error: redefinition of ___smp_call_function_single___
>>>> /usr/src/sparc32/linux-2.6/arch/sparc/include/asm/smp_32.h:78: error: previous definition of ___smp_call_function_single___ was here
>>>>         
>>> Andrew, are you sure that Makefile condition for compiling
>>> up.o is correct?
>>>       
>> you give me grounds for now being ;)
>>
>>     
>>> ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
>>> obj-y += smp.o
>>> else
>>> obj-y += up.o
>>> endif
>>>
>>> If an arch doesn't use generic SMP helpers, there is no way
>>> we should compile up.c into the tree when SMP.
>>>
>>>       
>> How's about this?
>>
>> --- a/kernel/Makefile~a
>> +++ a/kernel/Makefile
>> @@ -43,7 +43,7 @@ obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
>>  ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
>>  obj-y += smp.o
>>  else
>> -obj-y += up.o
>> +obj-$(CONFIG_SMP) += up.o
>>  endif
>>  obj-$(CONFIG_SMP) += spinlock.o
>>  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
>>     
>
> err, the other way of course...
>
> --- a/kernel/Makefile~a
> +++ a/kernel/Makefile
> @@ -43,6 +43,7 @@ obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
>  ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
>  obj-y += smp.o
>  else
> +ifneq ($(CONFIG_SMP),y)
>  obj-y += up.o
>  endif
>  obj-$(CONFIG_SMP) += spinlock.o
> _
>
>
>
>   
This worked:

diff --git a/kernel/Makefile b/kernel/Makefile
index 2aebc4c..368227d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -43,8 +43,10 @@ obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
 obj-y += smp.o
 else
+ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
+endif
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o

