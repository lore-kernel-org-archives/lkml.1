Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZCHKuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZCHKuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZCHKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:50:04 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:24939 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252AbZCHKuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:50:02 -0400
Message-ID: <49B3A2AC.7050701@panasas.com>
Date: Sun, 08 Mar 2009 12:49:16 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: um: WARNING: vmlinux: 'memcpy' exported twice. Previous export
 was in vmlinux
References: <49AFC206.9080004@panasas.com> <20090305130610.GA4265@hack.private> <49AFD780.8080500@panasas.com> <20090305160447.GB4265@hack.private> <49B00B83.20400@panasas.com> <20090306075211.GN22605@hack.private>
In-Reply-To: <20090306075211.GN22605@hack.private>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Mar 2009 10:49:59.0558 (UTC) FILETIME=[A0770A60:01C99FDB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Thu, Mar 05, 2009 at 07:27:31PM +0200, Boaz Harrosh wrote:
>> Américo Wang wrote:
>>> On Thu, Mar 05, 2009 at 03:45:36PM +0200, Boaz Harrosh wrote:
>>>> Américo Wang wrote:
>>>>> On Thu, Mar 05, 2009 at 02:13:58PM +0200, Boaz Harrosh wrote:
>>>>>> On today's linus v2.6.29-rc7-3-g559595a
>>>>>>
>>>>>> Doing make ARCH=um defconfig & make ARCH=um
>>>>>> give's me:
>>>>>>
>>>>>> LD vmlinux.o
>>>>>> MODPOST vmlinux.o
>>>>>> WARNING: vmlinux: 'memcpy' exported twice. Previous export was in vmlinux
>>>>>>
>>>>>>
>>>>>> Sorry if this is a duplicate report
>>>>>>
>>>>> Weird...
>>>>> I tried to compile like what you said, I can't reproduce it.
>>>>>
>>>>> Which gcc are you using?
>>>>>
>>>>> Thanks.
>>>>>
>>>> $ gcc --version
>>>> gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
>>>>
>>>> I'm running on an x86_64 Fedora10 system (updated recently)
>>>> $ uname -o -s -r -m -p -i
>>>> Linux 2.6.27.15-170.2.24.fc10.x86_64 x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>> I am using the same thing, but on i386. I still can't reproduce it. :(
>>>
>> What can I say I just did it again from scratch
>>
>> $ mkdir .build_um
>> $ make ARCH=um KBUILD_OUTPUT=.build_um defconfig
>> $ make ARCH=um KBUILD_OUTPUT=.build_um
>>
>> (I'm using KBUILD_OUTPUT= because O= does not work when also using M= with
>> external modules, so it's a habit)
>>
>> Thanks for your help. I will try to bisect it on Sunday
> 
> Hi, Boaz.
> 
> I am sorry that I don't have an x86_64 machine to use, but I know
> why this happens now. :)
> 
> Would you like to try the following patch? Thanks!
> 
> -------------->
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 

Tested-by: Boaz Harrosh <bharrosh@panasas.com>

> ---
> diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
> index 74f49bb..89b48a1 100644
> --- a/arch/um/os-Linux/user_syms.c
> +++ b/arch/um/os-Linux/user_syms.c
> @@ -14,7 +14,6 @@
>  #undef memset
>  
>  extern size_t strlen(const char *);
> -extern void *memcpy(void *, const void *, size_t);
>  extern void *memmove(void *, const void *, size_t);
>  extern void *memset(void *, int, size_t);
>  extern int printf(const char *, ...);
> @@ -24,7 +23,11 @@ extern int printf(const char *, ...);
>  EXPORT_SYMBOL(strstr);
>  #endif
>  
> +#ifndef __x86_64__
> +extern void *memcpy(void *, const void *, size_t);
>  EXPORT_SYMBOL(memcpy);
> +#endif
> +
>  EXPORT_SYMBOL(memmove);
>  EXPORT_SYMBOL(memset);
>  EXPORT_SYMBOL(printf);
>  

Yes this works. But it is weird, what is the difference between
__x86_64__ and any other platform?

Thanks
Boaz
