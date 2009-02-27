Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbZB0I3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbZB0I3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZB0I3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:29:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57161 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZB0I3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:29:11 -0500
Subject: Re: correct locking in softirq
From: Peter Zijlstra <peterz@infradead.org>
To: Giacomo <delleceste@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <885896af0902262354v47ddf79ch3d62edaeb1e940bd@mail.gmail.com>
References: <885896af0902262354v47ddf79ch3d62edaeb1e940bd@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 09:29:06 +0100
Message-Id: <1235723346.4948.1352.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 08:54 +0100, Giacomo wrote:
> Good morning
> 
> Harald Welte's "The journey of a packet through the Linux 2.6.10
> network stack" article says that packet travelling inside
> linux kernel 2.6 (the receive / input part) runs in softirq context.
> 
> Hooking with netfilter's hooks in a kernel module, i need to read for
> each packet received a list of rules.
> 
> Since in input and prerouting hooks the context is softirq (perhaps
> also in forward?), I need some read lock
> feature.
> 
> I currently use RCU lists and, while reading lists I use
> 
> READ
> 
> read_lock_bh()
> 
> together with list_for_each_rcu()
> 
> When changing, or flushing, rules, I use
> 
> WRITE
> 
> spin_lock() + list_add_tail_rcu() (adding)
> 
> or spin_lock() + list_for_each_entry() (for listing and then freeing
> with list_del_rcu() and call_rcu() )
> 
> The question is:
> 
> - is the read part above correct? - do I really need _bh()? or should
> I use simply read_lock() ?
> 
> Thanks in advance

rcu_read_lock() + call_rcu() are correct, even from softirq context, and
mandatory if anything is exposed to anything other than softirq context.

rcu_read_lock_bh() + call_rcu_bh() is usable IFF the data is only ever
used from softirq.

The distinction between the two RCU variants is that the _bh variant can
have a slightly faster quiescent cycle.

