Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZCTF3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZCTF3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 01:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZCTF3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 01:29:01 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38539 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZCTF3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 01:29:00 -0400
Message-ID: <49C3296B.1020209@cosmosbay.com>
Date: Fri, 20 Mar 2009 06:28:11 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Arjan van de Ven <arjan@infradead.org>, dipankar@in.ibm.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
References: <20090318215812.15496a86@infradead.org> <20090319085628.GA6167@in.ibm.com> <20090319071841.63334eff@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org> <20090320044541.GE6807@linux.vnet.ibm.com>
In-Reply-To: <20090320044541.GE6807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 20 Mar 2009 06:28:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney a écrit :
> On Thu, Mar 19, 2009 at 08:20:32PM -0700, Arjan van de Ven wrote:
>> On Thu, 19 Mar 2009 19:07:50 -0700
>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>
>>> On Thu, Mar 19, 2009 at 07:18:41AM -0700, Arjan van de Ven wrote:
>>>> On Thu, 19 Mar 2009 14:26:28 +0530
>>>> Dipankar Sarma <dipankar@in.ibm.com> wrote:
>>>>
>>>>> On Wed, Mar 18, 2009 at 09:58:12PM -0700, Arjan van de Ven wrote:
>>>>>> Hi,
>>>>>>
>>>>>> the input layer does a "synchronize_rcu()" after a
>>>>>> list_add_tail_rcu(), which is costing me 1 second of boot
>>>>>> time..... And based on my understanding of the RCU concept, you
>>>>>> only need to synchronize on delete, not on addition... so I
>>>>>> think the synchronize is entirely redundant here...
>>>>> The more appropriate question is - why is synchronize_rcu() taking
>>>>> 1 second ? Any idea what the other CPUs are doing at the time
>>>>> of calling synchronize_rcu() ?
>>>> one cpu is doing a lot of i2c traffic which is a bunch of udelay()s
>>>> in loops.. then it does quite a bit of uncached memory access, and
>>>> the lot takes quite while.
>>>>
>>>>> What driver is this ? How early
>>>>> in the boot is this happening ? 
>>>> during kernel boot.
>>>>
>>>> I suppose my question is also more generic.. why synchronize when
>>>> it's not needed? At least based on my understanding of RCU (but
>>>> you're the expert), you don't need to synchronize for an add, only
>>>> between a delete and a (k)free.....
>>> I don't claim to understand the code in question, so it is entirely
>>> possible that the following is irrelevant.  But one other reason for
>>> synchronize_rcu() is:
>>>
>>> 1.	Make change.
>>>
>>> 2.	synchronize_rcu()
>>>
>>> 3.	Now you are guaranteed that all CPUs/tasks/whatever
>>> currently running either are not messing with you on the one hand, or
>>> 	have seen the change on the other.
>> ok so this is for the case where someone is already iterating the list.
>>
>> I don't see anything in the code that assumes this..
> 
> I must let the networking guys sort this out.
> 
>>> It sounds like you are seeing these delays later in boot, however,
>> yeah it's during driver init/
>>
>>> Alternatively, again assuming a single-CPU system
>> single CPU is soooo last decade ;-)
>> But seriously I no longer have systems that aren't dual core or SMT in
>> some form... 
> 
> OK, I will ask the stupid question...
> 
> Why not delay bringing up the non-boot CPUs until later in boot?
> The first patch in my earlier email (which is in mainline) will shortcut
> synchronize_rcu() whenever there is only one CPU is online, at least
> for Classic RCU and Hierarchical RCU.
> 

Hmm... point is to make linux boot as fast as possible, so ...

Use a special variant of udelay() in offending drivers that make appropriate
RCU call to increment quiescent state ?



