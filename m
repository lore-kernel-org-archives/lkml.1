Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab0CLLLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 06:11:25 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54477 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab0CLLLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 06:11:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OkfCBawA2F7wuxJC2uvmRJJrBfSplxdSA/p3qqoA3/hV+m6mlewS802gTxJu74vIoy
         yhrKiC9/OYLTovd7AWuqHarYiF13BljGytZact5PDru5UaoXVLWuQu+Pu7KYnLvrK2xy
         nn1RVf+5zzvQKCtycaKcHI6PrLsbcs8qMyG7c=
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: David Miller <davem@davemloft.net>, paulmck@linux.vnet.ibm.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com>
References: <20100311134556.GA6344@linux.vnet.ibm.com>
	 <20100311161751.GA3804@hack>
	 <2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com>
	 <20100312.000705.225033546.davem@davemloft.net>
	 <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 12:11:16 +0100
Message-ID: <1268392276.3141.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 mars 2010 à 16:59 +0800, Américo Wang a écrit :
> On Fri, Mar 12, 2010 at 4:07 PM, David Miller <davem@davemloft.net> wrote:
> > From: Américo Wang <xiyou.wangcong@gmail.com>
> > Date: Fri, 12 Mar 2010 15:56:03 +0800
> >
> >> Ok, after decoding the lockdep output, it looks like that
> >> netif_receive_skb() should call rcu_read_lock_bh() instead of rcu_read_lock()?
> >> But I don't know if all callers of netif_receive_skb() are in softirq context.
> >
> > Normally, netif_receive_skb() is invoked from softirq context.
> >
> > However, via netpoll it can be invoked essentially from any context.
> >
> > But, when this happens, the networking receive path makes amends such
> > that this works fine.  That's what the netpoll_receive_skb() check in
> > netif_receive_skb() is for.  That check makes it bail out early if the
> > call to netif_receive_skb() is via a netpoll invocation.
> >
> 
> Oh, I see. This means we should call rcu_read_lock_bh() instead.
> If Paul has no objections, I will send a patch for this.
> 

Nope, its calling rcu_read_lock() from interrupt context and it should
stay as is (we dont need to disable bh, this has a cpu cost)



