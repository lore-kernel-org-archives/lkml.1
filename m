Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZEKP3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZEKP3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZEKP3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:29:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZEKP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:29:13 -0400
Message-ID: <4A084426.2080604@redhat.com>
Date: Mon, 11 May 2009 18:28:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu> <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu> <4A083B69.6010702@redhat.com> <20090511145903.GB737@elte.hu> <4A08405E.3070709@redhat.com> <20090511151823.GC9492@elte.hu>
In-Reply-To: <20090511151823.GC9492@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
>
>   
>>> I.e. the 3000 cycles value itself could be eliminated as well. 
>>> (with just a common-sense max of say 100,000 cycles enforced)
>>>       
>> Yeah, though that has a much smaller effect as it's only 
>> responsible for a few microseconds of spinning.
>>     
>
> 3000 cycles would be 1-2 usecs. Isnt the VM exit+entry cost still in 
> that range?
>   

It's 3000 executions of rep nop, so you need to account for the entire 
spinlock loop body.

The Linux spinlock is

             "1:\t"
             "cmpl %0, %2\n\t"
             "je 2f\n\t"
             "rep ; nop\n\t"
             "movzwl %1, %2\n\t"
             /* don't need lfence here, because loads are in-order */
             "jmp 1b\n"

5 instructions, maybe 2-3 cycles, not counting any special rep nop 
overhead.  Mark, any idea what the spin time is?

VM entry/exit is around 1us on the newer processors.

-- 
error compiling committee.c: too many arguments to function

