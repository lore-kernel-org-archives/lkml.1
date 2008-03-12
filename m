Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYCLJt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYCLJt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 05:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYCLJtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 05:49:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59482 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbYCLJte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 05:49:34 -0400
Subject: Re: Q: (stupid) can't we "fix" hlist_for_each_entry() ?
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080312081201.GA278@tv-sign.ru>
References: <20080312081201.GA278@tv-sign.ru>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 10:48:50 +0100
Message-Id: <1205315331.8514.225.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 11:12 +0300, Oleg Nesterov wrote:
> hlist_for_each_entry/hlist_for_each_entry_rcu doesn't actually need 4
> arguments, it could be
> 
> #define hlist_for_each_entry_rcu(pos, head, member)		 			\
> 	for (pos = hlist_entry((head)->first, typeof(*(pos)), member);			\
> 	     rcu_dereference(pos) != hlist_entry(NULL, typeof(*(pos)), member) &&	\
> 		({ prefetch((pos)->member.next); 1; });					\
> 	     (pos) = hlist_entry((pos)->member.next, typeof(*(pos)), member))
> 
> Or,
> 
> #define hlist_for_each_entry_rcu(pos, head, member)		 			\
> 	for (pos = (void*)(head)->first;						\
> 	     rcu_dereference(pos) && ({ prefetch(((hlist_node*)pos)->next); 1; }) &&	\
> 		({ (pos) = hlist_entry((void*)(pos), typeof(*(pos)), member)); 1; });	\
> 	     (pos) = (void*)(pos)->member.next)
> 
> Q: is it worth "fixing" ?

I'm in favour.

> If yes, what is the "right" way to do this? These macros are spread all over
> the kernel...

The usual way would be to prepare a git tree for Linus to pull right
after -rc1 I think was the best point, and at the same time supply
Andrew with a bunch of patches fixing up the various users in his tree.

