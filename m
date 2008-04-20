Return-Path: <linux-kernel-owner+w=401wt.eu-S1760189AbYDTSw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbYDTSw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYDTSws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:52:48 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:50358 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYDTSwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:52:47 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 14:52:47 EDT
Message-ID: <480B8E9F.8000701@firmworks.com>
Date: Sun, 20 Apr 2008 08:42:39 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419031024.GC3503@nineveh.local>	<20080418202925.b18452c5.akpm@linux-foundation.org>	<20080419092544.378664a8@ephemeral>	<20080419133909.5aa6b63e@ephemeral>	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	<480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral>
In-Reply-To: <20080420135948.61bdb4c9@ephemeral>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andres Salomon wrote:
> On Sun, 20 Apr 2008 08:07:55 -0400
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>   
>> Yinghai Lu wrote:
>>     
>>> On Sat, Apr 19, 2008 at 10:39 AM, Andres Salomon <dilinger@queued.net> wrote:
>>>       
>>>>  This adds 32-bit support for calling into OFW from the kernel.  It's useful
>>>>  for querying the firmware for misc hardware information, fetching the device
>>>>  tree, etc.
>>>>
>>>>  There's potentially no reason why other platforms couldn't use this, but
>>>>  currently OLPC is the main user of it.
>>>>
>>>>  This work was originally done by Mitch Bradley.
>>>>
>>>>         
>> Hm.  This interface seems more than a bit ad hoc.  In particular, I 
>> *really* don't like the swapper_pg_dir hack.
>>
>> "There must be a better way."
>>
>> 	-hpa
>>     
>
> I'm certainly open to suggestions..  Otherwise, I'll poke around and
> see if I can come up w/ something.
>   

The x86 architecture doesn't make this problem easy.

The conventional solution is to have the BIOS operate in real mode.  
When the kernel calls into the BIOS, it has to do a grotesque dance that 
involves jumping through a chain of several segments of different 
flavors, thus gradually shutting down the multi-tiered address 
translation mechanism.  Then, if the BIOS is actually operating in 
protected mode (which is necessary if it is larger than 64K, as all 
modern BIOSes are), it has to perform the inverse process, do the 
requested work, then go back into real mode to return to the kernel.  
The net result is that a "call" into the BIOS involves:

a) Copying the arguments to a real-mode register shadow array
b) Saving all the registers - general ones and a few special ones too
c) Far call to a linear-mapped code segment with an execution address in 
the first 1M of memory
d) Switching to a different stack
e) Turning off page translation
f) Switching from protected mode to real mode (or in some cases, V86 
mode instead, which requires an additional Task State Segment dance to 
set the IO permission mask)
g) Switching to a real-mode interrupt descriptor table

h) Executing an INT instruction

I) Performing the inverse of a - g inside the BIOS

j) Doing the requested work

K) Performing a - g again to get back into real mode

l) Executing an "iret" instruction

M) Performing the inverse of a-g to return to normal operation

The machinery that you need to do all that is predictably complex - 
extra segment descriptors that are set up just-so, several little code 
fragments that must be at special addresses in the first meg, additional 
stacks, a real-mode interrupt table at a fixed address, and several data 
save arrays.  That machinery has to be in assembly language, spanning 
several different instruction set modes.

Compared to that, I think that sharing one or two page directory entries 
at the very top of the virtual address space is pretty clean and 
simple.  With that sharing, the BIOS call is just an ordinary subroutine 
call.  (The setup code copies the entire page directory, but only a 
couple of entries are actually needed.  The reason for copying the whole 
thing is because it is rather more work to determine the exact number of 
entries necessary, compared to copying everything and then letting Linux 
replace the ones it uses.)

Every other solution that I know of requires some sort of heroic dance, 
either from the OS or from the BIOS or (usually) both.

