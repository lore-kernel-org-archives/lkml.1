Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZIXAfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZIXAfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZIXAfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:35:11 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:39153 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbZIXA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:29:59 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Oren Laadan <orenl@librato.com>, Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v18 69/80] c/r: introduce checkpoint/restore methods to struct proto_ops
Date: Wed, 23 Sep 2009 19:51:49 -0400
Message-Id: <1253749920-18673-70-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds new 'proto_ops' function for checkpointing and restoring
sockets. This allows the checkpoint/restart code to compile nicely
when, e.g., AF_UNIX sockets are selected as a module.

It also adds a function 'collecting' a socket for leak-detection
during full-container checkpoint. This is useful for those sockets
that hold references to other "collectable" objects. Two examples are
AF_UNIX buffers which reference the socket of origin, and sockets that
have file descriptors in-transit.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 include/linux/net.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 4fc2ffd..b99f350 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -147,6 +147,9 @@ struct sockaddr;
 struct msghdr;
 struct module;
 
+struct ckpt_ctx;
+struct ckpt_hdr_socket;
+
 struct proto_ops {
 	int		family;
 	struct module	*owner;
@@ -191,6 +194,12 @@ struct proto_ops {
 				      int offset, size_t size, int flags);
 	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
+	int		(*checkpoint)(struct ckpt_ctx *ctx,
+				      struct socket *sock);
+	int		(*collect)(struct ckpt_ctx *ctx,
+				   struct socket *sock);
+	int		(*restore)(struct ckpt_ctx *ctx, struct socket *sock,
+				   struct ckpt_hdr_socket *h);
 };
 
 struct net_proto_family {
-- 
1.6.0.4

