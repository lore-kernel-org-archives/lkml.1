Return-Path: <linux-kernel-owner+w=401wt.eu-S1763021AbYBNAOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763021AbYBNAOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933689AbYBNAOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:14:15 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38015 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbYBNAOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:14:12 -0500
Date: Wed, 13 Feb 2008 16:14:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Stephen Hemminger 
	<"stephen.hemminger@vyatta.com"@mail.vyatta.com>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       netdev@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       herbert@gondor.apana.org.au, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] remove rcu_assign_pointer(NULL) penalty with type/macro safety
Message-ID: <20080214001404.GQ12393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080213220024.GA30729@linux.vnet.ibm.com> <20080213143537.1b806790@extreme> <20080213224134.GK12393@linux.vnet.ibm.com> <20080213144233.05e860cb@extreme> <20080213233744.GO12393@linux.vnet.ibm.com> <20080213155158.1b621359@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080213155158.1b621359@extreme>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 03:51:58PM -0800, Stephen Hemminger wrote:
> On Wed, 13 Feb 2008 15:37:44 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Feb 13, 2008 at 02:42:33PM -0800, Stephen Hemminger wrote:
> > > On Wed, 13 Feb 2008 14:41:34 -0800
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > On Wed, Feb 13, 2008 at 02:35:37PM -0800, Stephen Hemminger wrote:
> > > > > On Wed, 13 Feb 2008 14:00:24 -0800
> > > > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > Hello!
> > > > > > 
> > > > > > This is an updated version of the patch posted last November:
> > > > > > 
> > > > > > 	http://archives.free.net.ph/message/20071201.003721.cd6ff17c.en.html
> > > > > > 
> > > > > > This new version permits arguments with side effects, for example:
> > > > > > 
> > > > > > 	rcu_assign_pointer(global_p, p++);
> > > > > > 
> > > > > > and also verifies that the arguments are pointers, while still avoiding
> > > > > > the unnecessary memory barrier when assigning NULL to a pointer.
> > > > > > This memory-barrier avoidance means that rcu_assign_pointer() is now only
> > > > > > permitted for pointers (not array indexes), and so this version emits a
> > > > > > compiler warning if the first argument is not a pointer.  I built a "make
> > > > > > allyesconfig" version on an x86 system, and received no such warnings.
> > > > > > If RCU is ever applied to array indexes, then the second patch in this
> > > > > > series should be applied, and the resulting rcu_assign_index() be used.
> > > > > > 
> > > > > > Given the rather surprising history of subtlely broken implementations of
> > > > > > rcu_assign_pointer(), I took the precaution of generating a full set of
> > > > > > test cases and verified that memory barriers and compiler warnings were
> > > > > > emitted when required.  I guess it is the simple things that get you...
> > > > > > 
> > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > > ---
> > > > > > 
> > > > > >  rcupdate.h |   16 ++++++++++++----
> > > > > >  1 file changed, 12 insertions(+), 4 deletions(-)
> > > > > > 
> > > > > > diff -urpNa -X dontdiff linux-2.6.24/include/linux/rcupdate.h linux-2.6.24-rap/include/linux/rcupdate.h
> > > > > > --- linux-2.6.24/include/linux/rcupdate.h	2008-01-24 14:58:37.000000000 -0800
> > > > > > +++ linux-2.6.24-rap/include/linux/rcupdate.h	2008-02-13 13:36:47.000000000 -0800
> > > > > > @@ -270,12 +270,20 @@ extern struct lockdep_map rcu_lock_map;
> > > > > >   * structure after the pointer assignment.  More importantly, this
> > > > > >   * call documents which pointers will be dereferenced by RCU read-side
> > > > > >   * code.
> > > > > > + *
> > > > > > + * Throws a compiler warning for non-pointer arguments.
> > > > > > + *
> > > > > > + * Does not insert a memory barrier for a NULL pointer.
> > > > > >   */
> > > > > >  
> > > > > > -#define rcu_assign_pointer(p, v)	({ \
> > > > > > -						smp_wmb(); \
> > > > > > -						(p) = (v); \
> > > > > > -					})
> > > > > > +#define rcu_assign_pointer(p, v)	\
> > > > > > +	({ \
> > > > > > +		typeof(*p) *_________p1 = (v); \
> > > > > > +		\
> > > > > > +		if (!__builtin_constant_p(v) || (_________p1 != NULL)) \
> > > > > > +			smp_wmb(); \
> > > > > > +		(p) = _________p1; \
> > > > > > +	})
> > > > > >  
> > > > > >  /**
> > > > > >   * synchronize_sched - block until all CPUs have exited any non-preemptive
> > > > > 
> > > > > Will this still work if p is unsigned long?
> > > > 
> > > > Hello, Steve,
> > > > 
> > > > If p is unsigned long, then use rcu_assign_index() from the next patch in
> > > > the set.  Looks like Andrew has applied it to -mm -- so please make sure
> > > > that he is aware if you do use it.
> > > 
> > > Make sure fib_trie still works and doesn't get warnings.
> > 
> > Ah.  It does take a bit to get fib_trie into one's build -- allyesconfig
> > doesn't cut it.  Please accept my apologies for my confusion!!!
> > 
> > Once fib_trie is configured, I do indeed get:
> > 
> >     net/ipv4/fib_trie.c: In function ‘node_set_parent’:
> >     net/ipv4/fib_trie.c:182: warning: comparison between pointer and integer
> > 
> > So, given that node->parent is an unsigned long, I changed node_set_parent()
> > to the following:
> > 
> > static inline void node_set_parent(struct node *node, struct tnode *ptr)
> > {
> > 	rcu_assign_index(node->parent, (unsigned long)ptr | NODE_TYPE(node));
> > }
> > 
> > This removes the warnings.  I am a little ambivalent about this, as
> > this is really a pointer in disguise rather than an array index, but
> > patch below.  I suppose that another option would be to make node->parent
> > be a void* and provide appropriate accessor functions/macros.
> > 
> > Thoughts?
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Maybe cast both sides to void * in this case:
> 
> static inline void node_set_parent(struct node *node, struct tnode *ptr)
> {
>  	rcu_assign_pointer((void *) node->parent, (void *)((unsigned long)ptr | NODE_TYPE(node)));
> }

That gets me the following:

	net/ipv4/fib_trie.c: In function ‘node_set_parent’:
	net/ipv4/fib_trie.c:182: error: invalid lvalue in assignment

However, as with much in computing, an extra level of indirection fixes
things.  Your call as to whether or not the cure is preferable to the
disease.  ;-)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 fib_trie.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25-rc1/net/ipv4/fib_trie.c linux-2.6.25-rc1-fib_trie-warn.compile/net/ipv4/fib_trie.c
--- linux-2.6.25-rc1/net/ipv4/fib_trie.c	2008-02-13 14:38:12.000000000 -0800
+++ linux-2.6.25-rc1-fib_trie-warn.compile/net/ipv4/fib_trie.c	2008-02-13 16:10:07.000000000 -0800
@@ -179,8 +179,8 @@ static inline struct tnode *node_parent_
 
 static inline void node_set_parent(struct node *node, struct tnode *ptr)
 {
-	rcu_assign_pointer(node->parent,
-			   (unsigned long)ptr | NODE_TYPE(node));
+	rcu_assign_pointer((*(void **)&node->parent),
+			   (void *)((unsigned long)ptr | NODE_TYPE(node)));
 }
 
 static inline struct node *tnode_get_child(struct tnode *tn, unsigned int i)
