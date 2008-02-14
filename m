Return-Path: <linux-kernel-owner+w=401wt.eu-S933758AbYBNAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbYBNAyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762236AbYBNAyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:54:05 -0500
Received: from mail.vyatta.com ([216.93.170.194]:39355 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbYBNAyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:54:03 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.82
Date: Wed, 13 Feb 2008 16:53:56 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Hemminger 
	<"stephen.hemminger@vyatta.com"@mail.vyatta.com>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       netdev@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       herbert@gondor.apana.org.au, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] remove rcu_assign_pointer(NULL) penalty with
 type/macro safety
Message-ID: <20080213165356.11d02092@extreme>
In-Reply-To: <20080214004253.GR12393@linux.vnet.ibm.com>
References: <20080213220024.GA30729@linux.vnet.ibm.com>
	<20080213143537.1b806790@extreme>
	<20080213224134.GK12393@linux.vnet.ibm.com>
	<20080213144233.05e860cb@extreme>
	<20080213233744.GO12393@linux.vnet.ibm.com>
	<20080213155158.1b621359@extreme>
	<20080214001404.GQ12393@linux.vnet.ibm.com>
	<20080213162700.0a32000d@extreme>
	<20080214004253.GR12393@linux.vnet.ibm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 16:42:53 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Feb 13, 2008 at 04:27:00PM -0800, Stephen Hemminger wrote:
> > On Wed, 13 Feb 2008 16:14:04 -0800
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > On Wed, Feb 13, 2008 at 03:51:58PM -0800, Stephen Hemminger wrote:
> 
> [ . . . ]
> 
> > > > Maybe cast both sides to void * in this case:
> > > > 
> > > > static inline void node_set_parent(struct node *node, struct tnode *ptr)
> > > > {
> > > >  	rcu_assign_pointer((void *) node->parent, (void *)((unsigned long)ptr | NODE_TYPE(node)));
> > > > }
> > > 
> > > That gets me the following:
> > > 
> > > 	net/ipv4/fib_trie.c: In function ‘node_set_parent’:
> > > 	net/ipv4/fib_trie.c:182: error: invalid lvalue in assignment
> > > 
> > > However, as with much in computing, an extra level of indirection fixes
> > > things.  Your call as to whether or not the cure is preferable to the
> > > disease.  ;-)
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > > 
> > >  fib_trie.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff -urpNa -X dontdiff linux-2.6.25-rc1/net/ipv4/fib_trie.c linux-2.6.25-rc1-fib_trie-warn.compile/net/ipv4/fib_trie.c
> > > --- linux-2.6.25-rc1/net/ipv4/fib_trie.c	2008-02-13 14:38:12.000000000 -0800
> > > +++ linux-2.6.25-rc1-fib_trie-warn.compile/net/ipv4/fib_trie.c	2008-02-13 16:10:07.000000000 -0800
> > > @@ -179,8 +179,8 @@ static inline struct tnode *node_parent_
> > >  
> > >  static inline void node_set_parent(struct node *node, struct tnode *ptr)
> > >  {
> > > -	rcu_assign_pointer(node->parent,
> > > -			   (unsigned long)ptr | NODE_TYPE(node));
> > > +	rcu_assign_pointer((*(void **)&node->parent),
> > > +			   (void *)((unsigned long)ptr | NODE_TYPE(node)));
> > >  }
> > 
> > That is heading towards ugly...  Maybe not using the macro at all (for this case) would be best:
> > 
> > static inline void node_set_parent(struct node *node, struct tnode *ptr)
> > {
> > 	smp_wmb();
> > 	node->parent = (unsigned long)ptr | NODE_TYPE(node);
> > }
> 
> Or, alternatively, the rcu_assign_index() patch sent earlier to avoid
> the bare memory barrier?
> 
> 							Thanx, Paul

I am fine with rcu_assign_index(), and add a comment in node_set_parent.
