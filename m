Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbYHRJN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbYHRJN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 05:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYHRJNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 05:13:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:7675 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYHRJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 05:13:50 -0400
Message-ID: <48A93D49.2000601@colorfullife.com>
Date: Mon, 18 Aug 2008 11:13:45 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       oleg@tv-sign.ru, dipankar@in.ibm.com, rostedt@goodmis.org,
       dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH tip/core/rcu] classic RCU locking and memory-barrier cleanups
References: <20080805162144.GA8297@linux.vnet.ibm.com> <489936E5.7020509@colorfullife.com> <20080807031806.GA6910@linux.vnet.ibm.com>
In-Reply-To: <20080807031806.GA6910@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>
>> Right now, I try to understand the current code first - and some of it 
>> doesn't make much sense.
>>
>> There are three per-cpu lists:
>> ->nxt
>> ->cur
>> ->done.
>>
>> Obviously, there must be a quiescent state between cur and done.
>> But why does the code require a quiescent state between nxt and cur?
>> I think that's superflous. The only thing that is required is that all cpus 
>> have moved their callbacks from nxt to cur. That doesn't need a quiescent 
>> state, this operation could be done in hard interrupt as well.
>>     
>
> The deal is that we have to put incoming callbacks somewhere while
> the batch in ->cur waits for an RCU grace period.  That somewhere is
> ->nxt.  So to be painfully pedantic, the callbacks in ->nxt are not
> waiting for an RCU grace period.  Instead, they are waiting for the
> callbacks in ->cur to get out of the way.
>
>   
Ok, thanks.
If I understand the new code in tip/rcu correctly, you have rewritten 
that block anyway.

I'll try to implement my proposal - on paper, it looks far simpler than 
the current code.
On the one hand, a state machine that keeps track of a global state:
- collect the callbacks in a nxt list.
- wait for quiecent
- destroy the callbacks in the nxt list.
(actually, there will be 5 states, 2 additional for "start the next rcu 
cycle immediately")

On the other hand a cpu bitmap that keeps track of the cpus that have 
completed the work that must be done after a state change.
The last cpu advances the global state.

The state machine could be seq_lock protected, the cpu bitmap could be 
either hierarchical or flat or for uniprocessor just a nop.

Do you have any statistics about rcu_check_callbacks? On my single-cpu 
system, around 2/3 of the calls are from "normal" context, i.e. 
rcu_qsctr_inc() is called.

--
    Manfred
