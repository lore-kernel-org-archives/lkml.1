Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYAESq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYAESq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 13:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbYAESqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 13:46:21 -0500
Received: from gw.goop.org ([64.81.55.164]:55318 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137AbYAESqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 13:46:21 -0500
Message-ID: <477FD045.50703@goop.org>
Date: Sat, 05 Jan 2008 10:45:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com> <477F2697.5050407@goop.org> <477FC613.7020807@linux.intel.com>
In-Reply-To: <477FC613.7020807@linux.intel.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Jeremy Fitzhardinge wrote:
>> Arjan van de Ven wrote:
>>> This patch moves WARN_ON() out of line entirely. I've considered
>>> keeping
>>> the test inline and moving only the slowpath out of line, but I decided
>>> against that: an out of line test reduces the pressure on the CPUs
>>> branch predictor logic and gives smaller code, while a function call
>>> to a fixed location is quite fast. Likewise I've considered doing
>>> something
>>> similar to BUG() (eg use a trapping instruction) but that's not really
>>> better (it needs the test inline again and recovering from an invalid
>>> instruction isn't quite fun).
>>
>> Power implements WARN_ON this way, and all the machinery is in place to
>> generically implement WARN_ON that way if you want.  It does generate
>> denser code than the call (since its just a single trapping instruction
>> with no need for argument setup), and the performance cost of the trap
>> shouldn't matter if warnings are rare (which one would hope).
>
> I just did an experiment with this to see how much is on the table. I
> made
> a file with 1024 WARN_ON()'s (new style, eg the out of line call) and
> 1024 BUG_ON()'s,
> which on i386 already use the trap.
> This shows that the BUG_ON() case is 2Kb shorter in generated code.
> From this 2Kb you
> need to subtract all the code size that is needed to deal with the
> trap and the module
> merging/unmerging of trap points etc etc, so lets say that a total of
> 1Kb is left on the table.
> HOWEVER, if you have a module with, say, only 4 WARN_ON()/BUG_ON()'s,
> you actually LOOSE
> 48 bytes, because of the extra overhead of how the trap data is stored.
>
> So... call me unconvinced for now. There's 30 Kb on the table with the
> easy, obviously safe
> transform, and maybe another 1Kb with the much more tricky trapping
> scenario, but only
> for the vmlinux case; the module case seems to be a loss instead. 

Yeah, that seems reasonable if you're optimising for overall size.  Did
you count the difference of including the function name?  We decided not
to include it for BUG because its usefulness/size tradeoff didn't seem
terribly important.

But my goal was actually to reduce icache pollution, so by my reckoning
code bytes were much more expensive than data ones, so putting all BUG
information in a separate section makes those bytes much less
significant than putting anything inline in code.  Also, the trap for
WARN_ON would be smaller than BUG, because it wouldn't need the spurious
infinite loop needed to make gcc understand the control flow of a BUG.

On the other hand, you could put the call to out of line warning
function in a separate section to achieve the same effect.

    J
