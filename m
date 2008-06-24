Return-Path: <linux-kernel-owner+w=401wt.eu-S1758287AbYFXLpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbYFXLpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYFXLp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:45:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:53653 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYFXLp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:45:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=l6GmIjQvAACqFgRPC1fgYPG+na/y+LPwH+WGEMDKX9Y3z5e0FCkePDhYOSUXslq288
         ibE+YNPy+nwCTp/lxsccnyjwuZihkQDH+xJXusNRuffQHv6uvYGVF+p6NExBZAZLVL/l
         6ZooJzsB91w074QoVztuwm4tYbC/2uRNSYYsw=
Message-ID: <19f34abd0806240445i6282c49cia22a700140dd27eb@mail.gmail.com>
Date: Tue, 24 Jun 2008 13:45:27 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH] softirq softlockup debugging
Cc: a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <87prq79kty.fsf@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622122845.GA10133@damson.getinternet.no>
	 <87prq79kty.fsf@skyscraper.fehenstaub.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/08, Johannes Weiner <hannes@saeurebad.de> wrote:
> After more staring at the code in question, I think that the approach is
> not correct (or I didn't understand it, which is not unlikely).
>
> I hunted down the address of the traces from kerneloops.org
> (__do_softirq+0x6d) on a kernel image with a fedora config and it's at
> the local_irq_enable() right after the restart:label in __do_softirq().
>

Are you quite sure? I didn't use the fedora image, but I compiled with
the fedora config and got a function size for __do_softirq that was
exactly equal to some of the reports. And there, the EIP pointed to
the second "pop" instruction after calling... oh, true.
local_irq_enable(). And those pops come from calling into paravirt
ops.

Right, I fully agree.

> So if the softirq handler had disabled interrupts, the softlockup would
> have been detected still within the handler (when it reenables irqs and
> the timer irq runs) and the stackframe should be there.
>
> do_softirq()
>  local_irq_save()                      1)
>  local_softirq_pending()
>  __do_softirq()
>   restart:                             2)
>    local_irq_enable()                  3)
>    run a handler
>    local_irq_disable()                 4)
>    jnz restart
>
> So the lockup must be caused somewhere
>  between 1) and 3)
> or
>  between 4) and 3) [when we jump back]
>
> These functions are in the path and possible candidates for causing it:
>
> - local_softirq_pending()
> - account_system_vtime()
> - __local_bh_disable()
> - trace_softirq_enter()
> - smp_processor_id()
> - set_softirq_pending()
>
> What do you think?  You said you actually used your patch already for
> debugging lockups in softirq handlers, so it confuses me why the
> stackframe of the handler was no longer present.

What didn't make sense to me when first looking at the oops reports
was that there was nowhere inside __do_softirq() that could actually
lock up. As far as I can see, there is no infinite (or very
long-running) loop in there, so I concluded (probably wrongly) that it
must be the handler; it was the only logical explanation I could find.
I believe that the functions you listed all run in constant time, but
maybe we should check it.

It also seems that the timer interrupt (where softlockup detection
kicks in) has a small delay after irqs are re-enabled before it
actually interrupts the CPU. Can you post a disassembly of
__do_softirq() where you pinpoint the exact instruction that was
interrupted, e.g. in this case __do_softirq+0x6d? Again, for me, this
was a pop %ebx or so, which doesn't change interruptibility, so maybe
I simply had the wrong disassembly.

(Actually, I didn't use the patch for debugging yet; I ran with the
patch applied, but I was unable to reproduce the lockup. But KOSAKI
Motohiro found some theoretical ABBA deadlock in cpusets vs. cpu
hotplug that could be the reason for it.)

Thanks for the analysis; I am very curious to see which code that
locks up and how I failed to notice where it was.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
