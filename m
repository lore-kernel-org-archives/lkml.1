Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbXCEEmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbXCEEmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 23:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXCEEmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 23:42:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:56077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbXCEEmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 23:42:01 -0500
Date: Mon, 5 Mar 2007 05:42:00 +0100
From: Nick Piggin <npiggin@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070305044200.GA31098@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de> <20070304.201142.41654149.davem@davemloft.net> <20070305042724.GB19783@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305042724.GB19783@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 05:27:24AM +0100, Nick Piggin wrote:
> On Sun, Mar 04, 2007 at 08:11:42PM -0800, David Miller wrote:
> > One minor nit:
> > 
> > > +struct dentry_hash {
> > > +	unsigned int shift;
> > > +	unsigned long mask;
> > > +	struct hlist_head *table;
> > > +};
> > 
> > I don't see any reason to make 'mask' an unsigned long
> > and this makes this structure take up 8 bytes more than
> > necessary on 64-bit.
> 
> You're right, the mask is currently just an int, so my patch should
> not be messing with that. Thanks.
> 
> The other thing you'll have to be careful of when looking at doing
> an implementation, is that I think I forgot to use the RCU accessors
> (rcu_assign_pointer, rcu_dereference) when assigning and loading
> the new/old hash table pointers.

Also, now that I think of it, if resize performance is far far less
important than read-side performance, then you should be able to get
away without the additional smp_rmb() that I add to the read-side
in the algorithm I described.

All you have to do is introduce an additional RCU grace period between
assigning the old pointer to the current table, and the current pointer
to the new table. This will still ensure that an (old_table == NULL &&
cur_table == new_table) condition is impossible (that condition would
mean that one of our active tables is invisible to the reader).

This should truely reduce read-side fastpath overhead to just a single,
predictable branch, an extra read_mostly load or two and the rcu_blah()
bits.

