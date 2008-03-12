Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbYCLIMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbYCLIMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 04:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYCLIMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 04:12:30 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58417 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYCLIM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 04:12:29 -0400
Date: Wed, 12 Mar 2008 11:12:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Q: (stupid) can't we "fix" hlist_for_each_entry() ?
Message-ID: <20080312081201.GA278@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hlist_for_each_entry/hlist_for_each_entry_rcu doesn't actually need 4
arguments, it could be

#define hlist_for_each_entry_rcu(pos, head, member)		 			\
	for (pos = hlist_entry((head)->first, typeof(*(pos)), member);			\
	     rcu_dereference(pos) != hlist_entry(NULL, typeof(*(pos)), member) &&	\
		({ prefetch((pos)->member.next); 1; });					\
	     (pos) = hlist_entry((pos)->member.next, typeof(*(pos)), member))

Or,

#define hlist_for_each_entry_rcu(pos, head, member)		 			\
	for (pos = (void*)(head)->first;						\
	     rcu_dereference(pos) && ({ prefetch(((hlist_node*)pos)->next); 1; }) &&	\
		({ (pos) = hlist_entry((void*)(pos), typeof(*(pos)), member)); 1; });	\
	     (pos) = (void*)(pos)->member.next)

Q: is it worth "fixing" ?

If yes, what is the "right" way to do this? These macros are spread all over
the kernel...

Oleg.

