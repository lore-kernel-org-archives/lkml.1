Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZKENT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZKENT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZKENT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:19:27 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:33323 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbZKENT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:19:26 -0500
Message-ID: <4AF2D0E0.1040903@gmail.com>
Date: Thu, 05 Nov 2009 14:19:28 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: paulmck@linux.vnet.ibm.com,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder	Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AF0B0D2.4030905@gmail.com> <20091104214844.GA6714@linux.vnet.ibm.com> <4AF2C266.1010603@gmail.com>
In-Reply-To: <4AF2C266.1010603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 05 Nov 2009 14:19:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson a écrit :
> Paul E. McKenney wrote:
>> On Tue, Nov 03, 2009 at 05:38:10PM -0500, William Allen Simpson wrote:
>>> Documentation/RCU/checklist.txt #7 says:
>>>
>>>   One exception to this rule: rcu_read_lock() and rcu_read_unlock()
>>>   may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
>>>   in cases where local bottom halves are already known to be
>>>   disabled, for example, in irq or softirq context.  Commenting
>>>   such cases is a must, of course!  And the jury is still out on
>>>   whether the increased speed is worth it.
>>
>> I strongly suggest using the matching primitives unless you have a
>> really strong reason not to.
>>
> Eric gave contrary advice.  But he also suggested (in an earlier message)
> clearing the secrets with a timer, which could be a separate context --
> although much later in time.
> 
> As you suggest, I'll use the _bh suffix everywhere until every i is dotted
> and t is crossed.  Then, check for efficiency later after thorough
> analysis by experts such as yourself.
> 
> This code will be hit on every SYN and SYNACK that has a cookie option.
> But it's just prior to a CPU intensive sha_transform -- in comparison,
> it's trivial.
>

I think you misunderstood my advice ;)

In the same function, you *cannot* use both variants like your last patch did :

		spin_lock(&tcp_secret_locker);  

...

		rcu_read_lock_bh();
		memcpy(&xvp->cookie_bakery[0],
		       &rcu_dereference(tcp_secret_generating)->secrets[0],
		       sizeof(tcp_secret_generating->secrets));
		rcu_read_unlock_bh();



Reasoning is :

If you need _bh() for the rcu_read_lock_bh(), thats because you know
soft irq can happen anytime (they are not masked).

Then you also need _bh for the spin_lock() call, or risk deadlock.

-> tcp_cookie_generator();
spin_lock();
-> interrupt  -> softirq -> SYN frame received -> tcp_cookie_generator() -> spin_lock(); hang



Your choices are :
------------------

1) Caller took care of disabling softirqs (or is only called from softirq handler),
then _bh suffixes are not necessary in tcp_cookie_generator().
 -> spin_lock() & rcu_read_lock();

2) You dont know what called you (process context or softirq context)
-> you MUST use _bh prefixes on spin_lock_bh() & rcu_read_lock_bh();


