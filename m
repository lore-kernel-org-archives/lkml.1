Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbYBLGDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbYBLGDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYBLGD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:03:29 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:48245 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYBLGD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:03:28 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 11 Feb 2008 22:03:21 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: [patch] avoid kmemcheck warning in epoll
Message-ID: <Pine.LNX.4.64.0802112157270.6351@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Epoll calls rb_set_parent(n, n) to initialize the rb-tree node, but 
rb_set_parent() accesses node's pointer in its code. This creates a 
warning in kmemcheck (reported by Vegard Nossum) about an uninitialized 
memory access. The warning is harmless since the following rb-tree node 
insert is going to overwrite the node data. In any case I think it's 
better to not have that happening at all, and fix it by simplifying the 
code to get rid of a few lines that became superfluous after the previous 
epoll changes.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/eventpoll.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2008-02-11 15:31:02.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2008-02-11 15:32:46.000000000 -0800
@@ -257,25 +257,6 @@
 	        (p1->file < p2->file ? -1 : p1->fd - p2->fd));
 }
 
-/* Special initialization for the RB tree node to detect linkage */
-static inline void ep_rb_initnode(struct rb_node *n)
-{
-	rb_set_parent(n, n);
-}
-
-/* Removes a node from the RB tree and marks it for a fast is-linked check */
-static inline void ep_rb_erase(struct rb_node *n, struct rb_root *r)
-{
-	rb_erase(n, r);
-	rb_set_parent(n, n);
-}
-
-/* Fast check to verify that the item is linked to the main RB tree */
-static inline int ep_rb_linked(struct rb_node *n)
-{
-	return rb_parent(n) != n;
-}
-
 /* Tells us if the item is currently linked */
 static inline int ep_is_linked(struct list_head *p)
 {
@@ -283,13 +264,13 @@
 }
 
 /* Get the "struct epitem" from a wait queue pointer */
-static inline struct epitem * ep_item_from_wait(wait_queue_t *p)
+static inline struct epitem *ep_item_from_wait(wait_queue_t *p)
 {
 	return container_of(p, struct eppoll_entry, wait)->base;
 }
 
 /* Get the "struct epitem" from an epoll queue wrapper */
-static inline struct epitem * ep_item_from_epqueue(poll_table *p)
+static inline struct epitem *ep_item_from_epqueue(poll_table *p)
 {
 	return container_of(p, struct ep_pqueue, pt)->epi;
 }
@@ -411,8 +392,7 @@
 		list_del_init(&epi->fllink);
 	spin_unlock(&file->f_ep_lock);
 
-	if (ep_rb_linked(&epi->rbn))
-		ep_rb_erase(&epi->rbn, &ep->rbr);
+	rb_erase(&epi->rbn, &ep->rbr);
 
 	spin_lock_irqsave(&ep->lock, flags);
 	if (ep_is_linked(&epi->rdllink))
@@ -728,7 +708,6 @@
 		goto error_return;
 
 	/* Item initialization follow here ... */
-	ep_rb_initnode(&epi->rbn);
 	INIT_LIST_HEAD(&epi->rdllink);
 	INIT_LIST_HEAD(&epi->fllink);
 	INIT_LIST_HEAD(&epi->pwqlist);
