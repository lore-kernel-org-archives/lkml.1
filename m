Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYJSCoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYJSCoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 22:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYJSCoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 22:44:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:28130 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYJSCoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 22:44:03 -0400
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Anirban Sinha <kernel@anirban.org>
Message-Id: <4C5B59FE-5B39-40E5-BB3C-7390C9625121@anirban.org>
From: Anirban Sinha <kernel@anirban.org>
To: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <87iqrqjpzt.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: panic() logic
Date: Sat, 18 Oct 2008 19:44:01 -0700
References: <13c67e2c0810171448o6858827ei1ccc9e0ddf487f8@mail.gmail.com> <87iqrqjpzt.fsf@basil.nowhere.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi:

Thanks for replying.
On 18-Oct-08, at 12:56 AM, Andi Kleen wrote:

> "Ani Sinha" <kernel@anirban.org> writes:
>
>> I noticed an issue with the panic() firing on a back core in SMP
>> lately. We are mostly working on mips architectures but it might
>> effect other archs as well. Therefore, I am putting forward my
>> thoughts and comments to the whole linux community. In the following,
>> by front core I mean core#0 and by back core I mean other cores.
>
> Why exactly is the "front core" special?

I am not exactly a firmware (CFE) guy but if I understand it  
correctly, all the interrupts are tied to the front core and  
cfe_exit() can only be called from the front core. I have written to  
the other guy who specializes in the CFE area and I will get back to  
you when I get an answer from him.


>
>
>> smp_send_stop basically marks all the other cores as 'down' and
>> updates the cpu bitmap. One implication of this is that you can not  
>> do
>> an IPI later on to other cores (smp_send_function() does a
>> 'for_earch_online_cpu'). This makes sense since you should not be
>> allowed to do anything on a down cpu.


This part of the logic is in Linux and is arch independent.


>> But what if a particular
>> architecture had logic to do specific things for the front core and
>> other things on the back cores as a part of 'graceful reboot'  
>> process?
>
> Is that logic in Linux or in the platform?


This logic is in arch specific code.

>
>
> Normally it's best to not rely on any specific CPU for panic.
> What do you do when that CPU is so broken that it cannot
> process IPIs anymore?


Agreed. That is why in my pseudo code I have a block (a comment  
really) telling you do do absolutely bare minimal things that you must  
do in a panic situation on the current core (without relying on IPIs  
to succeed on other cores).. What this bare minimum will be is a  
matter of debate. Getting a message out to the console saying that  
something bad has occurred (with details of the crash) can perhaps be  
a part of that minumum hunk of code.

Currently, the arch independent logic defeats the main purpose of the  
arch dependent emergency_restart() function which is to restart the  
system.  If a panic occurs on a back core, the kernel halts with the  
message "rebooting in 5 sec) and someone has to physically press the  
reset button. In a vast majority of the cases, we do have a perfectly  
sane and functional front core and we are just not able to gracefully  
reboot the system because we are limited by the way panic() handles  
things. If there are other archs that does a similar specific  
operation for the front core as a part of 'emergency restart', they  
are all defeated.

All I am trying to say is that perhaps there is a window of  
possibility where we can better handle a kernel panic. I am not saying  
that we should rearrange code in order to just accommodate mips archs,  
but if it can be done without much pain and objection, then lets just  
do it.

Thanks.

Ani



>
>
> -Andi
>
> -- 
> ak@linux.intel.com

