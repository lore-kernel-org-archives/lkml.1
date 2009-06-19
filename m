Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZFSA37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZFSA37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZFSA3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:29:51 -0400
Received: from claw.goop.org ([74.207.240.146]:46064 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZFSA3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:29:51 -0400
Message-ID: <4A3ADBFA.1060702@goop.org>
Date: Thu, 18 Jun 2009 17:29:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jake Edge <jake@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: problem with function_graph self-test?
References: <20090616122603.6a628097@chukar> <alpine.DEB.2.00.0906172312450.6890@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0906172312450.6890@gandalf.stny.rr.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/09 20:24, Steven Rostedt wrote:
> On Tue, 16 Jun 2009, Jake Edge wrote:
>
>   
>> Hi Steve,
>>
>> This has taken me a bit to track down ... I built a kernel from Linus's
>> git tree (as of this morning: commit
>> 03347e2592078a90df818670fddf97a33eec70fb) and when i boot it, it locks
>> up hard giving me a cursor in the upper left (which seems to grow then
>> shrink once, if that tells anyone anything) and no other output ... i
>> started messing with kernel params (turning off quiet, rhgb, adding
>> boot_delay and, eventually figuring out i needed lpj as well) to try
>> and extract some info ... it seems to reliably fail in the
>> function_graph tracer self-test with a variety of messages (I
>> unfortunately don't have a serial console on the laptop that I am
>> using) ... two of the messages that I got (possibly from different
>> boots):
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000048
>> BUG: Function graph tracer hang!
>>
>> I can try and get more information, but I wanted to check first if you
>> already know about this ... somehow i'll either need to type faster :)
>> or reliably slow it down and take pictures, which I can do if you'd
>> like ...
>>
>> obviously, for my purposes, i can turn off the selftests and/or the
>> function_graph tracer ...
>>     
>
> Jake, when you find a bug, you really find a bug!
>
> This is something that gcc is screwing with us. After spending all day 
> today trying to figure out what is happening, I finally found it in the 
> assembly.
>
> In the timer_stats_update_stats function, I get this at the beginning:
>
> 00000327 <timer_stats_update_stats>:
>  327:   57                      push   %edi
>  328:   8d 7c 24 08             lea    0x8(%esp),%edi
>  32c:   83 e4 e0                and    $0xffffffe0,%esp
>  32f:   ff 77 fc                pushl  0xfffffffc(%edi)
>  332:   55                      push   %ebp
>  333:   89 e5                   mov    %esp,%ebp
>  335:   57                      push   %edi
>  336:   56                      push   %esi
>  337:   53                      push   %ebx
>  338:   81 ec 8c 00 00 00       sub    $0x8c,%esp
>  33e:   e8 fc ff ff ff          call   33f <timer_stats_update_stats+0x18>
>                         33f: R_386_PC32 mcount
>
>
> And this at the end of the function:
>
>  4f6:   8d 67 f8                lea    0xfffffff8(%edi),%esp
>  4f9:   5f                      pop    %edi
>  4fa:   c3                      ret    
>   

Something to do with using _RET_IP_ in spin_unlock_irqrestore() perhaps?

    J
