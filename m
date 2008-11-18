Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYKRRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYKRRBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYKRRBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:01:35 -0500
Received: from gw.goop.org ([64.81.55.164]:55973 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbYKRRBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:01:34 -0500
Message-ID: <4922F4EC.6050408@goop.org>
Date: Tue, 18 Nov 2008 09:01:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Zachary Amsden <zach@vmware.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: arch_flush_lazy_mmu_mode() in arch/x86/mm/highmem_32.c
References: <4921428A.76E4.0078.0@novell.com> <1226944387.9969.77.camel@bodhitayantram.eng.vmware.com> <4921BA8E.60806@goop.org> <492284CE.76E4.0078.0@novell.com>
In-Reply-To: <492284CE.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Jeremy Fitzhardinge <jeremy@goop.org> 17.11.08 19:40 >>>
>>>>         
>> Zachary Amsden wrote:
>>     
>>> On Mon, 2008-11-17 at 01:08 -0800, Jan Beulich wrote:
>>>       
>>>> the batch should be prevented in asynchronous contexts altogether, or
>>>> things should properly nest. As a positive side effect, disabling interrupts
>>>> in the batch handling - in particular around the submission of the batch -
>>>> could also be avoided, reducing interrupt latency (perhaps significantly
>>>> in some case).
>>>>     
>>>>         
>>> Jeremy already fixed that; we don't disable interrupts, the change he
>>> made was to flush and then immediately restart the batching.
>>>   
>>>       
>> Yes.  The Xen code only disables interrupts temporarily while actually 
>> constructing a new multicall list member, to stop a half-constructed 
>> multicall from being issued by a nested flush.  But that's very brief, 
>> and cheap under Xen.
>>     
>
> Where's that fixed? Even in the -tip tree I still see xen_mc_flush()
> disabling interrupts (and multicalls.c didn't change for over two months)...
>   

Yes, it disables interrupts while its actually issuing the multicall.  I 
don't think that matters much, since the multicall itself can't be 
preempted (can it?) and the rest of the code is very short.  Originally 
it disabled interrupts for the entire lazy section, which is obviously 
worse.

> There's no reason to do any flush at all if you suppress batching temporarily.
> And it only needs (would need) explicit suppressing here because you can't
> easily recognize being in the context of a page fault handler from the
> batching functions (other than recognizing being in the context of an
> interrupt handler, which is what would allow removing the flush calls from
> highmem_32.c).

I'm not sure what your concern is here.  If batching is currently 
enabled, then the flush will push out anything pending immediately.  If 
batching is disabled, then the flush will be a noop and return immediately.

Making it so that the batching state can nest or have some way to push 
unbatched updates past the current batch would work as mechanisms, but I 
don't see what advantage there is to doing it, especially to offset the 
increased complexity.

    J
