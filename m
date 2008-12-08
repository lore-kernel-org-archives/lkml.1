Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbYLHTK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbYLHTK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 14:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYLHTKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 14:10:24 -0500
Received: from gw.goop.org ([64.81.55.164]:48433 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbYLHTKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 14:10:19 -0500
Message-ID: <493D7117.9050503@goop.org>
Date: Mon, 08 Dec 2008 11:10:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Eric Lacombe <goretux@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [x86] do_arch_prctl
References: <200812080002.21192.goretux@gmail.com>
In-Reply-To: <200812080002.21192.goretux@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> I'm sorry to insist, but I really want to understand what occurs in this 
> portion of kernel code. And that's why I resend my previous message with the 
> hope that someone could enlighten my mind.
>   

Well, its quite possible there are no good answers beyond "it needs a 
cleanup". 
> Thanks in advance,
>
> 	Eric
>
> Le lundi 24 novembre 2008 19:22:18 Jeremy Fitzhardinge, vous avez écrit :
>   
>> Eric Lacombe wrote:
>>     
>>> Hello,
>>>
>>> Does the "doit case" (line 822 in ARCH_GET_FS, function do_arch_prctl)
>>> exist for performance reasons? Else, why "task->thread.fs" (line 824)
>>> does not contain the fs base in the "doit case"?
>>>       
>> "doit" gets set when you're operating on yourself.  If you're operating
>> on another process, then you need to use their task structure values
>> rather than the current process's values.  If you're doing it to
>> yourself, then the task structure may be out of date because its only
>> updated on a context switch.
>>     
>
> The task_struct is also updated in sys_arch_prctl (ARCH_SET_FS and 
> ARCH_SET_GS), so not just on a context switch.
> How the task structure could be out of date wrt thread.gs and thread.fs?
> What could be a typical scenario that could induced gs or fs to be modified and 
> not thread.gs and thread.fs?
>   

Not sure.  It could just be redundant.

> Why we have a difference between ARCH_GET_GS :
>
>   
>> 833                 else if (doit) {
>> 834                         asm("movl %%gs,%0" : "=r" (gsindex));
>> 835                         if (gsindex)
>> 836                                 rdmsrl(MSR_KERNEL_GS_BASE, base);
>> 837                         else
>> 838                                 base = task->thread.gs;
>> 839                 }
>>     
>
> and ARCH_GET_FS :
>
>   
>> 821                 else if (doit)
>> 822                         rdmsrl(MSR_FS_BASE, base);
>>     
>
> If I follow what you say, why can't we have the same optimization in 
> ARCH_GET_FS?
>   

I haven't looked into it very closely, but its possible the asymmetry 
comes from the fact that there's no swapfs, and so the kernel and 
userspace aren't sharing %fs.

    J
