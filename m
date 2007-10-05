Return-Path: <linux-kernel-owner+w=401wt.eu-S1762418AbXJEAz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762418AbXJEAz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 20:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758443AbXJEAzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 20:55:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59813 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443AbXJEAzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 20:55:14 -0400
Message-ID: <47058B69.5050907@cn.fujitsu.com>
Date: Fri, 05 Oct 2007 09:55:05 +0900
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
References: <200710041308.l94D8ZZD015983@harpo.it.uu.se>
In-Reply-To: <200710041308.l94D8ZZD015983@harpo.it.uu.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote::
> On Thu, 4 Oct 2007 21:47:30 +0900, KAMEZAWA Hiroyuki wrote:
>> On Thu, 04 Oct 2007 21:33:12 +0900
>> Shi Weihua <shiwh@cn.fujitsu.com> wrote:
>>
>>> KAMEZAWA Hiroyuki wrote::
>>>> On Thu, 04 Oct 2007 20:56:14 +0900
>>>> Shi Weihua <shiwh@cn.fujitsu.com> wrote:
>>>>
>>>>> 	stack.ss_sp = addr + pagesize;
>>>>> 	stack.ss_flags = 0;
>>>>> 	stack.ss_size = pagesize;
>>>> Here is bad. 
>>>> stack,ss_sp = addr;
>>>> stack.ss_flags = 0;
>>>> stack.ss_size = pagesize * 2;
>>> [What the test code want to do]
>>> addr+pagesize*2 - addr+pagesize	 -> sigaltstack
>>> addr+pagesize	- addr		 -> protected region
>>> The code want to catch overflow when esp enter the protected region.
>>>
>> You have to protect the top of *registered* sigaltstack.
>> The reason of wraparound is %esp will be set to the bottom of sigaltstack
>> if it is not on sigaltstack area when signaled.
>> What you have to do is protect the top of registerd sigaltstack.
>> If %esp is in the range of registerd sigaltstack at SEGV, wraparound
>> will stop.
> 
> Exactly right. You mprotect or munmap the end of the altstack,
> not the area beyond it.
So we tell users "Even if you protectted half of mmap's space, but you must to register all space to 
kernel. " ?

The image about my test code's result:
               No patch        Patched
┌───────────┐
│           │← 1 ┌ ← 3          ← 1
│    A      │    │(wraparound)
│           │    │
│           │← 2 │              ← 2
│           │    │
├───────────┤    │
│▒▒▒▒▒▒▒▒▒▒▒│← 3 ┘              ← 3
│▒▒▒▒B▒▒▒▒▒▒│                  (caught)
│▒protected▒│
│▒▒▒▒▒▒▒▒▒▒▒│
│▒▒▒▒▒▒▒▒▒▒▒│
└───────────┘
A+B  mmap's space
A    sigaltstack
B    protectted

I agree that if register A+B to kernel, the wraparound will stop.
But if register A to kernel, why not kernel do something?

Thanks
Shi Weihua
> 
> /Mikael
> 
> 
> 

