Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYFKXEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYFKXEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYFKXEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:04:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:39954 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYFKXEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AvhE2jfa3v8K0pv476swR0VZbA46JttbXgjIgIjdaBFbpn+cx9aLFhA7iAhJpXaeyA
         Nkm5VeBnYaMq/78eOi4kyY9jHf2/XlKodO35KG02QF+Kru2I5cJmDN1UyCbYdqd/Mx0H
         bglMr8tdJcS9mnCdNWngjbg944ZqdRCVp8H8c=
Message-ID: <48505A0C.7060506@gmail.com>
Date: Thu, 12 Jun 2008 01:04:44 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, skumar@linux.vnet.ibm.com,
       yamamoto@valinux.co.jp, menage@google.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>	<4850070F.6060305@gmail.com>	<20080611121510.d91841a3.akpm@linux-foundation.org>	<485032C8.4010001@gmail.com>	<20080611134323.936063d3.akpm@linux-foundation.org>	<485055FF.9020500@gmail.com> <20080611155530.099a54d6.akpm@linux-foundation.org>
In-Reply-To: <20080611155530.099a54d6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 12 Jun 2008 00:47:27 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
>> Andrew Morton wrote:
>>>> At least we could add something like:
>>>>
>>>> #ifdef CONFIG_32BIT
>>>> #define PAGE_ALIGN64(addr) (((((addr)+PAGE_SIZE-1))>>PAGE_SHIFT)<<PAGE_SHIFT)
>>>> #else
>>>> #define PAGE_ALIGN64(addr) PAGE_ALIGN(addr)
>>>> #endif
>>>>
>>>> But IMHO the single PAGE_ALIGN64() implementation is more clear.
>>> No, we should just fix PAGE_ALIGN.  It should work correctly when
>>> passed a long-long.  Otherwse it's just a timebomb.
>>>
>>> This:
>>>
>>> #define PAGE_ALIGN(addr) ({				\
>>> 	typeof(addr) __size = PAGE_SIZE;		\
>>> 	typeof(addr) __mask = PAGE_MASK;		\
>>> 	(addr + __size - 1) & __mask;			\
>>> })
>>>
>>> (with a suitable comment) does what we want.  I didn't check to see
>>> whether this causes the compiler to generate larger code, but it
>>> shouldn't.
>>>
>> No, it doesn't work. The problem seems to be in the PAGE_MASK definition
>> (from include/asm-x86/page.h for example):
>>
>> /* PAGE_SHIFT determines the page size */
>> #define PAGE_SHIFT      12
>> #define PAGE_SIZE       (_AC(1,UL) << PAGE_SHIFT)
>> #define PAGE_MASK       (~(PAGE_SIZE-1))
>>
>> The "~" is performed on a 32-bit value, so everything in "and" with
>> PAGE_MASK greater than 4GB will be truncated to the 32-bit boundary.
> 
> OK, I oversimplified my testcase.
> 
>> What do you think about the following?
>>
>> #define PAGE_SIZE64 (1ULL << PAGE_SHIFT)
>> #define PAGE_MASK64 (~(PAGE_SIZE64 - 1))
>>
>> #define PAGE_ALIGN(addr) ({					\
>> 	typeof(addr) __size = PAGE_SIZE;			\
>> 	typeof(addr) __ret = (addr) + __size - 1;		\
>> 	__ret > -1UL ? __ret & PAGE_MASK64 : __ret & PAGE_MASK;	\
>> })
> 
> Complex.  And I'd worry about added code overhead.
> 
> What about
> 
> #define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
> 
> ?
> 
> afaict ALIGN() tries to do the right thing, and if it doesn't, we
> should fix ALIGN().

Good! Much simpler.

-Andrea
