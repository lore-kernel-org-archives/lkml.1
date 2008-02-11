Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbYBKXhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbYBKXhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760331AbYBKXhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:37:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:55215 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760127AbYBKXhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:37:03 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 11 Feb 2008 15:37:00 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andrea@qumranet.com, vegard.nossum@gmail.com
Subject: Re: [patch] avoid kmemcheck warning in epoll
In-Reply-To: <20080211145644.d940ad07.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802111517200.27519@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0802101323140.27286@alien.or.mcafeemobile.com>
 <20080211145644.d940ad07.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Andrew Morton wrote:

> On Sun, 10 Feb 2008 13:32:01 -0800 (PST)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > Epoll calls rb_set_parent(n, n) to initialize the rb-tree node, but 
> > rb_set_parent() accesses node's pointer in its code. This creates a 
> > warning in kmemcheck (reported by Vegard Nossum) about an uninitialized 
> > memory access. The warning is harmless since the following rb-tree node 
> > insert is going to overwrite the node data. In any case I think it's 
> > better to not have that happening at all, and fix it by properly 
> > initializing the data.
> > 
> > 
> > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> > 
> > 
> > - Davide
> > 
> > 
> > ---
> >  fs/eventpoll.c         |    2 +-
> >  include/linux/rbtree.h |   12 ++++++++++++
> >  2 files changed, 13 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.mod/fs/eventpoll.c
> > ===================================================================
> > --- linux-2.6.mod.orig/fs/eventpoll.c	2008-02-10 12:36:20.000000000 -0800
> > +++ linux-2.6.mod/fs/eventpoll.c	2008-02-10 12:50:41.000000000 -0800
> > @@ -260,7 +260,7 @@
> >  /* Special initialization for the RB tree node to detect linkage */
> >  static inline void ep_rb_initnode(struct rb_node *n)
> >  {
> > -	rb_set_parent(n, n);
> > +	rb_init_node(n, n);
> >  }
> >  
> >  /* Removes a node from the RB tree and marks it for a fast is-linked check */
> > Index: linux-2.6.mod/include/linux/rbtree.h
> > ===================================================================
> > --- linux-2.6.mod.orig/include/linux/rbtree.h	2008-02-10 12:36:13.000000000 -0800
> > +++ linux-2.6.mod/include/linux/rbtree.h	2008-02-10 12:51:57.000000000 -0800
> > @@ -112,6 +112,18 @@
> >  	struct rb_node *rb_node;
> >  };
> >  
> > +/**
> > + * rb_init_node - Initializes the node internal data
> > + *
> > + * @node: Pointer to the RB-Tree node
> > + * @parent: Pointer to the parent node, or NULL
> > + *
> > + */
> > +static inline void rb_init_node(struct rb_node *node, struct rb_node *parent)
> > +{
> > +	node->rb_parent_color = (unsigned long) parent;
> > +	node->rb_left = node->rb_right = NULL;
> > +}
> 
> Is epoll the only rbtree-using code which exhibits this problem?  If so,
> what is epoll doing differently from all the others?

Dunno, but I don't think so. Epoll initializes the node to a state so that 
later on can check if the file-fd item is inserted or not. And it uses the 
"parent" information for that. But rb_set_parent() (that is used in the 
current initialization code) uses the data in the node, and this triggers 
the uninitialized memory access.
Taking a better look at it, the code (after the latest changes) has no 
more point-of-failures after the rb-tree insert, so I can probably avoid 
doing the node's parent-initialization and check altogether.
Yeah, let's that ;)

 eventpoll.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

Andrew, drop that one. I'm gonna send the new one after some test...



- Davide


