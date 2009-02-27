Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbZB0Q77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbZB0Q77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 11:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZB0Q7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 11:59:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50435 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbZB0Q7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 11:59:44 -0500
Date: Fri, 27 Feb 2009 08:59:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Giacomo <delleceste@gmail.com>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
Subject: Re: correct locking in softirq
Message-ID: <20090227165942.GC6758@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <885896af0902262354v47ddf79ch3d62edaeb1e940bd@mail.gmail.com> <1235723346.4948.1352.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235723346.4948.1352.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 09:29:06AM +0100, Peter Zijlstra wrote:
> On Fri, 2009-02-27 at 08:54 +0100, Giacomo wrote:
> > Good morning
> > 
> > Harald Welte's "The journey of a packet through the Linux 2.6.10
> > network stack" article says that packet travelling inside
> > linux kernel 2.6 (the receive / input part) runs in softirq context.
> > 
> > Hooking with netfilter's hooks in a kernel module, i need to read for
> > each packet received a list of rules.
> > 
> > Since in input and prerouting hooks the context is softirq (perhaps
> > also in forward?), I need some read lock
> > feature.
> > 
> > I currently use RCU lists and, while reading lists I use
> > 
> > READ
> > 
> > read_lock_bh()
> > 
> > together with list_for_each_rcu()
> > 
> > When changing, or flushing, rules, I use
> > 
> > WRITE
> > 
> > spin_lock() + list_add_tail_rcu() (adding)
> > 
> > or spin_lock() + list_for_each_entry() (for listing and then freeing
> > with list_del_rcu() and call_rcu() )
> > 
> > The question is:
> > 
> > - is the read part above correct? - do I really need _bh()? or should
> > I use simply read_lock() ?
> > 
> > Thanks in advance
> 
> rcu_read_lock() + call_rcu() are correct, even from softirq context, and
> mandatory if anything is exposed to anything other than softirq context.
> 
> rcu_read_lock_bh() + call_rcu_bh() is usable IFF the data is only ever
> used from softirq.

If "softirq" also includes sections of local_bh_disable()ed code in
process context, also including irq-disabled code, agreed!

> The distinction between the two RCU variants is that the _bh variant can
> have a slightly faster quiescent cycle.

Especially when under heavy interrupt/softirq load.  If a given
CPU is totally consumed handling interrupts and softirqs in a
non-CONFIG_PREEMPT_RT kernel, then the call_rcu() variant might never
invoke its callback, while the call_rcu_bh() variant would still be
able to do so in a timely fashion.  The _bh() variant was inspired by
simulate DoS attacks, work by Robert Olsson and Dipankar Sarma.

							Thanx, Paul
