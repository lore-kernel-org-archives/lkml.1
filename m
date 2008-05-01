Return-Path: <linux-kernel-owner+w=401wt.eu-S1764199AbYEAVIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764199AbYEAVIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835AbYEAVIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:08:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbYEAVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:08:09 -0400
Date: Thu, 1 May 2008 17:08:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: akpm@osdl.org, Latchesar Ionkov <lucho@ionkov.net>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] fix flags length in net 9p 
Message-ID: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some files in the net/9p directory uses "int" for flags. This can
cause hard to find bugs on some architectures. This patch converts the
flags to use "long" instead.

This bug was discovered by doing an allyesconfig make on the -rt kernel
where checks are done to ensure all flags are of size sizeof(long).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 net/9p/trans_virtio.c |    2 +-
 net/9p/util.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-compile.git/net/9p/trans_virtio.c
===================================================================
--- linux-compile.git.orig/net/9p/trans_virtio.c	2008-04-09 18:45:15.000000000 -0400
+++ linux-compile.git/net/9p/trans_virtio.c	2008-05-01 17:02:25.000000000 -0400
@@ -134,7 +134,7 @@ static void p9_virtio_close(struct p9_tr
 {
 	struct virtio_chan *chan = trans->priv;
 	int count;
-	unsigned int flags;
+	unsigned long flags;

 	spin_lock_irqsave(&chan->lock, flags);
 	p9_idpool_destroy(chan->tagpool);
Index: linux-compile.git/net/9p/util.c
===================================================================
--- linux-compile.git.orig/net/9p/util.c	2008-02-14 23:09:39.000000000 -0500
+++ linux-compile.git/net/9p/util.c	2008-05-01 17:02:35.000000000 -0400
@@ -71,7 +71,7 @@ int p9_idpool_get(struct p9_idpool *p)
 {
 	int i = 0;
 	int error;
-	unsigned int flags;
+	unsigned long flags;

 retry:
 	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
@@ -102,7 +102,7 @@ EXPORT_SYMBOL(p9_idpool_get);

 void p9_idpool_put(int id, struct p9_idpool *p)
 {
-	unsigned int flags;
+	unsigned long flags;
 	spin_lock_irqsave(&p->lock, flags);
 	idr_remove(&p->pool, id);
 	spin_unlock_irqrestore(&p->lock, flags);

