Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbXJ2VP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbXJ2VP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXJ2VPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:15:46 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42405 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbXJ2VPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:15:45 -0400
Date: Mon, 29 Oct 2007 14:15:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: SteveW@ACM.org, davem@davemloft.net, dipankar@in.ibm.com
Subject: dn_route.c momentarily exiting RCU read-side critical section
Message-ID: <20071029211540.GA12893@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

net/decnet/dn_route.c in dn_rt_cache_get_next() is as follows:

static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_route *rt)
{
	struct dn_rt_cache_iter_state *s = rcu_dereference(seq->private);

	rt = rt->u.dst.dn_next;
	while(!rt) {
		rcu_read_unlock_bh();
		if (--s->bucket < 0)
			break;

...  But what happens if seq->private is freed up right here?
...  Or what prevents this from happening?

		rcu_read_lock_bh();
		rt = dn_rt_hash_table[s->bucket].chain;
	}
	return rt;
}

Similar code is in rt_cache_get_next().

So, what am I missing here?

						Thanx, Paul
