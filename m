Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYCLR2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYCLR2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYCLR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:28:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbYCLR21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:28:27 -0400
Date: Wed, 12 Mar 2008 10:27:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@lst.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: (stupid) can't we "fix" hlist_for_each_entry() ?
Message-Id: <20080312102730.b34be3c9.akpm@linux-foundation.org>
In-Reply-To: <1205315331.8514.225.camel@twins>
References: <20080312081201.GA278@tv-sign.ru>
	<1205315331.8514.225.camel@twins>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 10:48:50 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2008-03-12 at 11:12 +0300, Oleg Nesterov wrote:
> > hlist_for_each_entry/hlist_for_each_entry_rcu doesn't actually need 4
> > arguments, it could be
> > 
> > #define hlist_for_each_entry_rcu(pos, head, member)		 			\
> > 	for (pos = hlist_entry((head)->first, typeof(*(pos)), member);			\
> > 	     rcu_dereference(pos) != hlist_entry(NULL, typeof(*(pos)), member) &&	\
> > 		({ prefetch((pos)->member.next); 1; });					\
> > 	     (pos) = hlist_entry((pos)->member.next, typeof(*(pos)), member))
> > 
> > Or,
> > 
> > #define hlist_for_each_entry_rcu(pos, head, member)		 			\
> > 	for (pos = (void*)(head)->first;						\
> > 	     rcu_dereference(pos) && ({ prefetch(((hlist_node*)pos)->next); 1; }) &&	\
> > 		({ (pos) = hlist_entry((void*)(pos), typeof(*(pos)), member)); 1; });	\
> > 	     (pos) = (void*)(pos)->member.next)
> > 
> > Q: is it worth "fixing" ?
> 
> I'm in favour.
> 
> > If yes, what is the "right" way to do this? These macros are spread all over
> > the kernel...
> 
> The usual way would be to prepare a git tree for Linus to pull right
> after -rc1 I think was the best point, and at the same time supply
> Andrew with a bunch of patches fixing up the various users in his tree.

That, or create new functions with new names, migrate over to them
piecemeal and later remove the old functions.

It's a bit of a problem that there is no alternative name.

eh, send over the jumbopatch after 2.6.25 is released - I'll take care of it.
