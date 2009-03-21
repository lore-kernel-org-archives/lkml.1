Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZCUJOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZCUJOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZCUJOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:14:12 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33975 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZCUJOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:14:11 -0400
Message-ID: <49C4AFC2.500@cosmosbay.com>
Date: Sat, 21 Mar 2009 10:13:38 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
References: <20090318215812.15496a86@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org> <200903202246.15772.dmitry.torokhov@gmail.com>
In-Reply-To: <200903202246.15772.dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 21 Mar 2009 10:13:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov a écrit :
> On Thursday 19 March 2009 20:20:32 Arjan van de Ven wrote:
>>> I don't claim to understand the code in question, so it is entirely
>>> possible that the following is irrelevant.  But one other reason for
>>> synchronize_rcu() is:
>>>
>>> 1.    Make change.
>>>
>>> 2.    synchronize_rcu()
>>>
>>> 3.    Now you are guaranteed that all CPUs/tasks/whatever
>>> currently running either are not messing with you on the one hand, or
>>>       have seen the change on the other.
>> ok so this is for the case where someone is already iterating the list.
>>
>> I don't see anything in the code that assumes this..
> 
> This is something that input core guarantees to its users: by the time
> input core calls hander->start() or, in its absence, by the time
> input_register_handle() returns, events from input drivers will be
> passed into the handle being registered, i.e. the presence of the
> new item in the list is noticed by all CPUs.
> 
> Now, it is possible to stop using RCU primitives in the input core
> but I think that you'd want to figure out why synchronize_rcu()
> takes so long first, otheriwse you may find another "abuser"
> down the road.
> 

If a cpu does a loop, it nearly impossible that synchronize_rcu() can
be fast.

We had same problem in ksoftirqd(), where I had to add a call
to rcu_qsctr_inc() to unblock other threads blocked in synchronize_rcu()

http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=64ca5ab913f1594ef316556e65f5eae63ff50cee

If a driver does a loop with no call to scheduler, it might have same problem


