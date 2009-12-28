Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbZL1AEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbZL1AEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 19:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZL1AEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 19:04:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55621 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZL1AEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 19:04:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 09:00:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
Subject: Re: [RFC PATCH] asynchronous page fault.
Message-Id: <20091228090047.280f4565.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1261912796.15854.25.camel@laptop>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	<1261912796.15854.25.camel@laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Dec 2009 12:19:56 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-12-25 at 10:51 +0900, KAMEZAWA Hiroyuki wrote:
> > Index: linux-2.6.33-rc2/lib/rbtree.c
> > ===================================================================
> > --- linux-2.6.33-rc2.orig/lib/rbtree.c
> > +++ linux-2.6.33-rc2/lib/rbtree.c
> > @@ -30,19 +30,19 @@ static void __rb_rotate_left(struct rb_n
> >  
> >         if ((node->rb_right = right->rb_left))
> >                 rb_set_parent(right->rb_left, node);
> > -       right->rb_left = node;
> > +       rcu_assign_pointer(right->rb_left, node);
> >  
> >         rb_set_parent(right, parent);
> >  
> >         if (parent)
> >         {
> >                 if (node == parent->rb_left)
> > -                       parent->rb_left = right;
> > +                       rcu_assign_pointer(parent->rb_left, right);
> >                 else
> > -                       parent->rb_right = right;
> > +                       rcu_assign_pointer(parent->rb_right, right);
> >         }
> >         else
> > -               root->rb_node = right;
> > +               rcu_assign_pointer(root->rb_node, right);
> >         rb_set_parent(node, right);
> >  }
> >  
> > @@ -53,19 +53,19 @@ static void __rb_rotate_right(struct rb_
> >  
> >         if ((node->rb_left = left->rb_right))
> >                 rb_set_parent(left->rb_right, node);
> > -       left->rb_right = node;
> > +       rcu_assign_pointer(left->rb_right, node);
> >  
> >         rb_set_parent(left, parent);
> >  
> >         if (parent)
> >         {
> >                 if (node == parent->rb_right)
> > -                       parent->rb_right = left;
> > +                       rcu_assign_pointer(parent->rb_right, left);
> >                 else
> > -                       parent->rb_left = left;
> > +                       rcu_assign_pointer(parent->rb_left, left);
> >         }
> >         else
> > -               root->rb_node = left;
> > +               rcu_assign_pointer(root->rb_node, left);
> >         rb_set_parent(node, left);
> >  }
> 
> 
> Consider the tree rotation:
> 
> 
>            Q                        P
>          /   \                    /   \
>        P       C                A       Q
>      /   \                            /   \
>    A       B                        B       C
> 
> 
> Since this comprises of 3 assignments (assuming right rotation):
> 
>   Q.left = B
>   P.right = Q
>   parent = P
> 
> it is non-atomic. This in turn means that any lock-less decent into the
> tree will be able to miss a whole subtree or worse (imagine us being at
> Q, needing to go to A, then the rotation happens, and all we can choose
> from is B or C).
> 
> Your changelog states as much.
> 
> "Even if RB-tree rotation occurs while we walk tree for look-up, we just
> miss vma without oops."
> 
> However, since this is the case, do we still need the
> rcu_assign_pointer() conversion your patch does? All I can see it do is
> slow down all RB-tree users, without any gain.
> 

Ok, I'll remove all.

Thanks,
-Kame



