Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab0CLWDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:03:24 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53517 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab0CLWDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:03:22 -0500
Date: Fri, 12 Mar 2010 14:03:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.34-rc1: rcu lockdep bug?
Message-ID: <20100312220319.GC7824@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100311134556.GA6344@linux.vnet.ibm.com> <20100311161751.GA3804@hack> <2375c9f91003112356g1b4164e4pb5f63f0e0e2f310a@mail.gmail.com> <20100312.000705.225033546.davem@davemloft.net> <2375c9f91003120059g771d162fxefc21beb2ab17b4d@mail.gmail.com> <1268392276.3141.4.camel@edumazet-laptop> <2375c9f91003120511j6f33592cl12cb2617a27351ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f91003120511j6f33592cl12cb2617a27351ec@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 09:11:02PM +0800, Américo Wang wrote:
> On Fri, Mar 12, 2010 at 7:11 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le vendredi 12 mars 2010 à 16:59 +0800, Américo Wang a écrit :
> >> On Fri, Mar 12, 2010 at 4:07 PM, David Miller <davem@davemloft.net> wrote:
> >> > From: Américo Wang <xiyou.wangcong@gmail.com>
> >> > Date: Fri, 12 Mar 2010 15:56:03 +0800
> >> >
> >> >> Ok, after decoding the lockdep output, it looks like that
> >> >> netif_receive_skb() should call rcu_read_lock_bh() instead of rcu_read_lock()?
> >> >> But I don't know if all callers of netif_receive_skb() are in softirq context.
> >> >
> >> > Normally, netif_receive_skb() is invoked from softirq context.
> >> >
> >> > However, via netpoll it can be invoked essentially from any context.
> >> >
> >> > But, when this happens, the networking receive path makes amends such
> >> > that this works fine.  That's what the netpoll_receive_skb() check in
> >> > netif_receive_skb() is for.  That check makes it bail out early if the
> >> > call to netif_receive_skb() is via a netpoll invocation.
> >> >
> >>
> >> Oh, I see. This means we should call rcu_read_lock_bh() instead.
> >> If Paul has no objections, I will send a patch for this.
> >>
> >
> > Nope, its calling rcu_read_lock() from interrupt context and it should
> > stay as is (we dont need to disable bh, this has a cpu cost)
> >
> 
> Oh, but lockdep complains about rcu_read_lock(), it said
> rcu_read_lock() can't be used in softirq context.
> 
> Am I missing something?

Hmmm...  It is supposed to be OK to use rcu_read_lock() in pretty much
any context, even NMI.  I will take a look.

							Thanx, Paul
