Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYDQNdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYDQNdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYDQNdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:33:06 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47310 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbYDQNdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:33:05 -0400
Message-Id: <1208439182.14784.1248410993@webmail.messagingengine.com>
X-Sasl-Enc: QYe5kqTQeS9uCIoQlcAYxogqSVdaHWQX3DYcnCrWY6PJ 1208439182
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080416202338.GA6007@elte.hu> <878wzdikwk.fsf@basil.nowhere.org>   
   <1208426793.10305.1248377703@webmail.messagingengine.com>   
   <48072B9D.2000900@firstfloor.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
In-Reply-To: <48072B9D.2000900@firstfloor.org>
Date: Thu, 17 Apr 2008 15:33:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 12:51:09 +0200, "Andi Kleen" <andi@firstfloor.org>
said:
> I think a realistic benchmark would be by running a real kernel
> and profiling the input values of the bitmap functions and then
> testing these cases.
> 
> I actually started that when I complained last time by writing
> a systemtap script for this that generates a histogram, but for some
> reason systemtap couldn't tap all bitmap functions in my kernel and
> missed some completely and I ran out of time tracking that down.
> 
> My gut feeling is the only interesting cases are cpumask/nodemask sized
> (which can be one word, two words but now upto 8 words on a NR_CPU=4096
> x86 kernel) and then 4k sized ext3/reiser/etc. block bitmaps.
>
> The generic version is out-of-line,
> > while the private implementation of i386 was inlined: this causes a
> > regression for very small bitmaps. However, if the bitmap size is
> > a constant and fits a long integer, the updated generic code should
> > inline an optimized version, like x86_64 currently does it.
> 
> Yes it should probably. cpumask walks are relatively common.

Hi,

The version that is in x86#testing _will_ do this optimization. For
32 node SMP on x86_64 this results in:

<__first_cpu>:
    mov    $0x20,%edx   (inlined...)
    mov    $0x100000000,%rax
    or     (%rdi),%rax
    bsf    %rax,%rax    (... find_first_bit)
    cmp    $0x20,%eax   (superfluous paranoia...)
    cmovg  %edx,%eax    (... for broken find_first_bit)
    retq   

and something similar for __next_cpu.

> I remember profiling mysql some time ago which did bad overscheduling
> due to dumb locking. Funny was that the mask walking in the scheduler
> actually stood out. No, i don't claim extreme overscheduling is an
> interesting case to optimize for, but then there are more realistic
> workloads which also do a lot of context switching.
> 
> BTW if you do generic work on this: one reason the generated code for
> for_each_cpu etc. is so ugly is that the code has checks for
> find_next_bit returning >= max size. If you can generize the
> code enough to make sure no arch does that anymore these checks
> could be eliminated.

for_each_cpu code looks fine:

    mov    $cpumapaddress,%rdi
    callq  <__first_cpu>
    jmp    end_of_body
start_of_body:
    ...
end_of_body:
    mov    $cpumapaddress,%edi  ($mapaddress often cached in register)
    callq  <__next_cpu>
    cmp    $0x1f,%eax
    jle    start_of_body

On the other hand it would be nice to change __first_cpu and
__next_cpu into inline functions. If all implementations of
find_first_bit and find_next_bit would reliably return max_size
if no bits were found, that would be a good thing to do. The
generic one does return max_size.

Greetings,
    Alexander

> -Andi
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - One of many happy users:
  http://www.fastmail.fm/docs/quotes.html

