Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbYCLMyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbYCLMyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 08:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYCLMyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 08:54:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48238 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYCLMyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 08:54:06 -0400
Date: Wed, 12 Mar 2008 05:53:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: (stupid) can't we "fix" hlist_for_each_entry() ?
Message-ID: <20080312125348.GA1487@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080312081201.GA278@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312081201.GA278@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 11:12:01AM +0300, Oleg Nesterov wrote:
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

I have already come out in favor: http://lwn.net/Articles/262464/
answer to Quick Quiz 3.  ;-)

The first option above looks more straightforward to me.

> If yes, what is the "right" way to do this? These macros are spread all over
> the kernel...

Peter's approach looked reasonable to me.

							Thanx, Paul
