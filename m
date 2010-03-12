Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab0CLNLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:11:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63530 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab0CLNLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:11:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r/5kVf99YxODNK3dJAXLr8dghOc5AeY0rNmEIkUQ6beCd935XBCic9s9e8xs+QEDXU
         P1H+K3Cg8hER8oi+/5237JtQaSROgCrSVs9zf59Q7iv78szZWgRgZlQDZecmC2BOLp/e
         FqX/PfdY8xRHSR9acRLWXwO5EWCf9otDt9y/o=
MIME-Version: 1.0
In-Reply-To: <1268392276.3141.4.camel@edumazet-laptop>
References: <20100311134556.GA6344@linux.vnet.ibm.com>
	 <20100311161751.GA3804@hack>
	 <2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com>
	 <20100312.000705.225033546.davem@davemloft.net>
	 <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com>
	 <1268392276.3141.4.camel@edumazet-laptop>
Date: Fri, 12 Mar 2010 21:11:02 +0800
Message-ID: <2375c9f91003120511j6f33592cl12cb2617a27351ec@mail.gmail.com>
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, paulmck@linux.vnet.ibm.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 7:11 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 12 mars 2010 à 16:59 +0800, Américo Wang a écrit :
>> On Fri, Mar 12, 2010 at 4:07 PM, David Miller <davem@davemloft.net> wrote:
>> > From: Américo Wang <xiyou.wangcong@gmail.com>
>> > Date: Fri, 12 Mar 2010 15:56:03 +0800
>> >
>> >> Ok, after decoding the lockdep output, it looks like that
>> >> netif_receive_skb() should call rcu_read_lock_bh() instead of rcu_read_lock()?
>> >> But I don't know if all callers of netif_receive_skb() are in softirq context.
>> >
>> > Normally, netif_receive_skb() is invoked from softirq context.
>> >
>> > However, via netpoll it can be invoked essentially from any context.
>> >
>> > But, when this happens, the networking receive path makes amends such
>> > that this works fine.  That's what the netpoll_receive_skb() check in
>> > netif_receive_skb() is for.  That check makes it bail out early if the
>> > call to netif_receive_skb() is via a netpoll invocation.
>> >
>>
>> Oh, I see. This means we should call rcu_read_lock_bh() instead.
>> If Paul has no objections, I will send a patch for this.
>>
>
> Nope, its calling rcu_read_lock() from interrupt context and it should
> stay as is (we dont need to disable bh, this has a cpu cost)
>

Oh, but lockdep complains about rcu_read_lock(), it said
rcu_read_lock() can't be used in softirq context.

Am I missing something?
