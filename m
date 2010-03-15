Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936035Ab0COJjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:39:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47008 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935701Ab0COJjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GPWGlX5cDEXK2268zAj0mLcN9srrBtbQ3SN4DKoRkvp1mmHogzkhfSo6iLWQHxCvsZ
         U/AmO39IZ/NDj3Rb9OisHnXCGYu/iWTsSumxIBbEnLzIwsTkmSXEMxXgpmkv5qW6IEsm
         wsuLlN9Fhs0pcPPCTw+VJ/MHJSBEfCvAn6pKY=
MIME-Version: 1.0
In-Reply-To: <2375c9f91003142010g61841666iad53c24f39036acf@mail.gmail.com>
References: <20100311134556.GA6344@linux.vnet.ibm.com>
	 <20100312.000705.225033546.davem@davemloft.net>
	 <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com>
	 <1268392276.3141.4.camel@edumazet-laptop>
	 <2375c9f91003120511j6f33592cl12cb2617a27351ec@mail.gmail.com>
	 <1268401058.3141.9.camel@edumazet-laptop> <20100313053356.GC3704@hack>
	 <20100313215838.GB6805@linux.vnet.ibm.com>
	 <20100315010802.GB2735@hack>
	 <2375c9f91003142010g61841666iad53c24f39036acf@mail.gmail.com>
Date: Mon, 15 Mar 2010 17:39:20 +0800
Message-ID: <2375c9f91003150239m1abc765bh59eb51c948eed592@mail.gmail.com>
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       David Miller <davem@davemloft.net>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/15 Américo Wang <xiyou.wangcong@gmail.com>:
> 2010/3/15 Américo Wang <xiyou.wangcong@gmail.com>:
>> On Sat, Mar 13, 2010 at 01:58:38PM -0800, Paul E. McKenney wrote:
>>>On Sat, Mar 13, 2010 at 01:33:56PM +0800, Américo Wang wrote:
>>>> On Fri, Mar 12, 2010 at 02:37:38PM +0100, Eric Dumazet wrote:
>>>> >Le vendredi 12 mars 2010 à 21:11 +0800, Américo Wang a écrit :
>>>> >
>>>> >> Oh, but lockdep complains about rcu_read_lock(), it said
>>>> >> rcu_read_lock() can't be used in softirq context.
>>>> >>
>>>> >> Am I missing something?
>>>> >
>>>> >Well, lockdep might be dumb, I dont know...
>>>> >
>>>> >I suggest you read rcu_read_lock_bh kernel doc :
>>>> >
>>>> >/**
>>>> > * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical
>>>> >section
>>>> > *
>>>> > * This is equivalent of rcu_read_lock(), but to be used when updates
>>>> > * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
>>>> > * consider completion of a softirq handler to be a quiescent state,
>>>> > * a process in RCU read-side critical section must be protected by
>>>> > * disabling softirqs. Read-side critical sections in interrupt context
>>>> > * can use just rcu_read_lock().
>>>> > *
>>>> > */
>>>> >
>>>> >
>>>> >Last sentence being perfect :
>>>> >
>>>> >Read-side critical sections in interrupt context
>>>> >can use just rcu_read_lock().
>>>> >
>>>>
>>>> Yeah, right, then it is more likely to be a bug of rcu lockdep.
>>>> Paul is looking at it.
>>>
>>>Except that it seems to be working correctly for me...
>>>
>>
>> Hmm, then I am confused. The only possibility here is that this is
>> a lockdep bug...
>>
>
> I believe so...
>
> Peter, this looks odd:
>
>  kernel:  (usbfs_mutex){+.?...}, at: [<ffffffff8146419f>]
> netif_receive_skb+0xe7/0x819
>
> netif_receive_skb() never has a chance to take usbfs_mutex. How can this
> comes out?
>

Ok, I think I found what lockdep really complains about, it is that we took
spin_lock in netpoll_poll_lock() which is in hardirq-enabled environment,
later, we took another spin_lock with spin_lock_irqsave() in netpoll_rx(),
so lockdep thought we broke the locking rule.

I don't know why netpoll_rx() needs irq disabled, it looks like that no one
takes rx_lock in hardirq context. So can we use spin_lock(&rx_lock)
instead? Or am I missing something here? Eric? David?

Thanks!
