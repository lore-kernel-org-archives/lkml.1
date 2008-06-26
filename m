Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYFZCvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYFZCvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 22:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYFZCv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 22:51:26 -0400
Received: from gw.goop.org ([64.81.55.164]:33539 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYFZCvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 22:51:25 -0400
Message-ID: <48630420.1090102@goop.org>
Date: Wed, 25 Jun 2008 19:51:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Lameter <clameter@sgi.com>, Petr Tesarik <ptesarik@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
 with irqs disable
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>	 <20080507073017.GJ32195@elte.hu>	 <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>	 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>	 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>	 <1214241561.19392.21.camel@elijah.suse.cz>	 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>	 <1214253593.11254.30.camel@twins>	 <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com> <1214254730.11254.34.camel@twins>
In-Reply-To: <1214254730.11254.34.camel@twins>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-06-23 at 13:45 -0700, Christoph Lameter wrote:
>   
>> On Mon, 23 Jun 2008, Peter Zijlstra wrote:
>>
>>     
>>>> It is good that the locks are build with _trylock and _can_lock because 
>>>> then we can reenable interrupts while spinning.
>>>>         
>>> Well, good and bad, the turn side is that fairness schemes like ticket
>>> locks are utterly defeated.
>>>       
>> True. But maybe we can make these fairness schemes more generic so that 
>> they can go into core code?
>>     
>
> The trouble with ticket locks is that they can't handle waiters going
> away - or in this case getting preempted by irq handlers. The one who
> took the ticket must pass it on, so if you're preempted it just sits
> there being idle, until you get back to deal with the lock.
>
> But yeah, perhaps another fairness scheme might work in the generic
> code..

Thomas Friebel presented results at the Xen Summit this week showing 
that ticket locks are an absolute disaster for scalability in a virtual 
environment, for a similar reason.  It's a bit irritating if the lock 
holder vcpu gets preempted by the hypervisor, but its much worse when 
they release the lock: unless the vcpu scheduler gives a cpu to the vcpu 
with the next ticket, it can waste up to N timeslices spinning.

I'm experimenting with adding pvops hook to allow you to put in new 
spinlock implementations on the fly.  If nothing else, it will be useful 
for experimenting with different algorithms.  But it definitely seems 
like the old unfair lock algorithm played much better with a virtual 
environment, because the next cpu to get the lock is the next one the 
scheduler gives time, rather than dictating an order - and the scheduler 
should mitigate the unfairness that ticket locks were designed to solve.

    J
