Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYKRSA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYKRSA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYKRSAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:00:49 -0500
Received: from gw.goop.org ([64.81.55.164]:58588 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbYKRSAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:00:48 -0500
Message-ID: <492302CE.5090702@goop.org>
Date: Tue, 18 Nov 2008 10:00:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: arch_flush_lazy_mmu_mode() in arch/x86/mm/highmem_32.c
References: <4921428A.76E4.0078.0@novell.com> <1226944387.9969.77.camel@bodhitayantram.eng.vmware.com> <4921BA8E.60806@goop.org> <492284CE.76E4.0078.0@novell.com> <4922F4EC.6050408@goop.org> <4923096A.76E4.0078.0@novell.com>
In-Reply-To: <4923096A.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> If an interrupt (event) comes in, a multicall could of course be 'preempted',
> in order to service the event. But of course that works only if event
> delivery isn't disabled.
>   

Well, if we made a local copy of the multicall queue, we could enable 
interrupts before doing the multicall.

>>> There's no reason to do any flush at all if you suppress batching temporarily.
>>> And it only needs (would need) explicit suppressing here because you can't
>>> easily recognize being in the context of a page fault handler from the
>>> batching functions (other than recognizing being in the context of an
>>> interrupt handler, which is what would allow removing the flush calls from
>>> highmem_32.c).
>>>       
>> I'm not sure what your concern is here.  If batching is currently 
>> enabled, then the flush will push out anything pending immediately.  If 
>> batching is disabled, then the flush will be a noop and return immediately.
>>     
>
> Latency, as before. The page fault should have to take longer than it really
> needs, and the flushing of a pending batch clearly doesn't belong to the
> page fault itself.
>   

Yes, I can see that.  But in practice the batches are pretty small; the 
cap is only 32 entries to start with, and there are very few operations 
which can really get close to that.  Large mprotects and munmaps of 
present pages are the only way to make large batches, and they're 
uncommon and expensive operations anyway.

    J
