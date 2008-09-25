Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYIYD4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYIYD4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 23:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYIYD4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 23:56:25 -0400
Received: from mercury.realtime.net ([205.238.132.86]:58193 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYIYD4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 23:56:24 -0400
In-Reply-To: <1222291005.8277.86.camel@pasglop>
References: <200809231743.23828.ossthema@de.ibm.com> <20080915100406.342e027a@bull.net> <200809240958.m8O9wM7k010996@sullivan.realtime.net> <20080924143055.6102f317@bull.net> <0fa2693104ff3250114d82837911b9e8@bga.com> <1222291005.8277.86.camel@pasglop>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <9eea138fe97eb1e63e5169a4d7647883@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Christoph Raisch <RAISCH@de.ibm.com>, linuxppc-dev@ozlabs.org,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Sebastien Dugue <sebastien.dugue@bull.net>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with hardirq preemption
Date: Wed, 24 Sep 2008 22:56:54 -0500
To: benh@kernel.crashing.org
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 24, 2008, at 4:16 PM, Benjamin Herrenschmidt wrote:
> On Wed, 2008-09-24 at 11:42 -0500, Milton Miller wrote:
>>
>> I was trying to understand why the mask and early eoi, but I guess its
>> to handle other more limited interrupt controllers where the 
>> interrupts
>> stack in hardware instead of software.
>
> No Milton, we must do it that way, because the EOI must be done on the
> right CPU even on XICS, or we won't get the CPU priority back properly.

Ben and I had a online chat, and he pointed out I needed to be more 
specific in saying what I was thinking.

>> I think the flows we want on xics are:
>>
>> (non-threaded)
>> 	getirq (implicit source specific mask until eoi)
>> 	handle interrupt
>> 	eoi (implicit cpu priority restore)
>>
>> (threaded)
>> 	getirq (implicit source specific mask until eoi)
>> 	explicit cpu priority restore
>> 	handle interrupt
>> 	eoi (implicit cpu priority restore to same as explicit level)


cpu takes interrupt, checks soft disabled
if so,
	set hard disabled
else
	call get_irq
	if threaded
		write cppr to restore this cpu irq dispatch state to non-interrupt
		mark irq thread as irq pending
	else
		handle interrupt
		eoi (cppr = base)

irq thread will
	handle interrupt
	eoi
	wait for marked pending again

The part Ben did not follow was that the cppr write to base priority is 
done by the interrupted cpu (like the mask and eoi in the current flow) 
and only the final eoi (where the mask is in the existing flow) is done 
on which ever cpu happens to run the irq thread.


(optional) As I was discussing with Paul, when taking an irq when 
soft-disabled but still hard enabled, it is possible to write the cppr 
such that it would reject the pending irq and have it be considered for 
dispatch to another cpu.   But it would increase pathlength on both the 
go-to-hard-disabled and return-from-hard-disabled and the hardware will 
have some latency as it will likely send it back to the io source until 
it retrys, so we would only want to do this if the hard-disable period 
is sufficiently long.

milton

