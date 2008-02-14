Return-Path: <linux-kernel-owner+w=401wt.eu-S933912AbYBNAnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbYBNAnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbYBNAm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:42:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53092 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbYBNAm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:42:56 -0500
Date: Wed, 13 Feb 2008 16:42:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Stephen Hemminger 
	<"stephen.hemminger@vyatta.com"@mail.vyatta.com>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       netdev@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       herbert@gondor.apana.org.au, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] remove rcu_assign_pointer(NULL) penalty with type/macro safety
Message-ID: <20080214004253.GR12393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080213220024.GA30729@linux.vnet.ibm.com> <20080213143537.1b806790@extreme> <20080213224134.GK12393@linux.vnet.ibm.com> <20080213144233.05e860cb@extreme> <20080213233744.GO12393@linux.vnet.ibm.com> <20080213155158.1b621359@extreme> <20080214001404.GQ12393@linux.vnet.ibm.com> <20080213162700.0a32000d@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080213162700.0a32000d@extreme>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 04:27:00PM -0800, Stephen Hemminger wrote:
> On Wed, 13 Feb 2008 16:14:04 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Feb 13, 2008 at 03:51:58PM -0800, Stephen Hemminger wrote:

[ . . . ]

> > > Maybe cast both sides to void * in this case:
> > > 
> > > static inline void node_set_parent(struct node *node, struct tnode *ptr)
> > > {
> > >  	rcu_assign_pointer((void *) node->parent, (void *)((unsigned long)ptr | NODE_TYPE(node)));
> > > }
> > 
> > That gets me the following:
> > 
> > 	net/ipv4/fib_trie.c: In function ‘node_set_parent’:
> > 	net/ipv4/fib_trie.c:182: error: invalid lvalue in assignment
> > 
> > However, as with much in computing, an extra level of indirection fixes
> > things.  Your call as to whether or not the cure is preferable to the
> > disease.  ;-)
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  fib_trie.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff -urpNa -X dontdiff linux-2.6.25-rc1/net/ipv4/fib_trie.c linux-2.6.25-rc1-fib_trie-warn.compile/net/ipv4/fib_trie.c
> > --- linux-2.6.25-rc1/net/ipv4/fib_trie.c	2008-02-13 14:38:12.000000000 -0800
> > +++ linux-2.6.25-rc1-fib_trie-warn.compile/net/ipv4/fib_trie.c	2008-02-13 16:10:07.000000000 -0800
> > @@ -179,8 +179,8 @@ static inline struct tnode *node_parent_
> >  
> >  static inline void node_set_parent(struct node *node, struct tnode *ptr)
> >  {
> > -	rcu_assign_pointer(node->parent,
> > -			   (unsigned long)ptr | NODE_TYPE(node));
> > +	rcu_assign_pointer((*(void **)&node->parent),
> > +			   (void *)((unsigned long)ptr | NODE_TYPE(node)));
> >  }
> 
> That is heading towards ugly...  Maybe not using the macro at all (for this case) would be best:
> 
> static inline void node_set_parent(struct node *node, struct tnode *ptr)
> {
> 	smp_wmb();
> 	node->parent = (unsigned long)ptr | NODE_TYPE(node);
> }

Or, alternatively, the rcu_assign_index() patch sent earlier to avoid
the bare memory barrier?

							Thanx, Paul
