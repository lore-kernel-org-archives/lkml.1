Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbXLEIrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbXLEIrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbXLEIq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 03:46:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51564 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbXLEIqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 03:46:55 -0500
Date: Wed, 5 Dec 2007 08:46:47 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mark.fasheh@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] remove nonsense force-casts from ocfs2
Message-ID: <20071205084647.GH8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	endianness annotations in networking code had been in place for
quite a while; in particular, sin_port and s_addr are annotated as
big-endian.  Code in ocfs2 had __force casts added apparently to shut the
sparse warnings up; of course, these days they only serve to *produce*
warnings for no reason whatsoever...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index d84bd15..ee50c96 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -72,14 +72,6 @@
 
 #include "tcp_internal.h"
 
-/* 
- * The linux network stack isn't sparse endian clean.. It has macros like
- * ntohs() which perform the endian checks and structs like sockaddr_in
- * which aren't annotated.  So __force is found here to get the build
- * clean.  When they emerge from the dark ages and annotate the code
- * we can remove these.
- */
-
 #define SC_NODEF_FMT "node %s (num %u) at %u.%u.%u.%u:%u"
 #define SC_NODEF_ARGS(sc) sc->sc_node->nd_name, sc->sc_node->nd_num,	\
 			  NIPQUAD(sc->sc_node->nd_ipv4_address),	\
@@ -1500,7 +1492,7 @@ static void o2net_start_connect(struct work_struct *work)
 
 	myaddr.sin_family = AF_INET;
 	myaddr.sin_addr.s_addr = mynode->nd_ipv4_address;
-	myaddr.sin_port = (__force u16)htons(0); /* any port */
+	myaddr.sin_port = htons(0); /* any port */
 
 	ret = sock->ops->bind(sock, (struct sockaddr *)&myaddr,
 			      sizeof(myaddr));
@@ -1701,11 +1693,11 @@ static int o2net_accept_one(struct socket *sock)
 	if (ret < 0)
 		goto out;
 
-	node = o2nm_get_node_by_ip((__force __be32)sin.sin_addr.s_addr);
+	node = o2nm_get_node_by_ip(sin.sin_addr.s_addr);
 	if (node == NULL) {
 		mlog(ML_NOTICE, "attempt to connect from unknown node at "
 		     "%u.%u.%u.%u:%d\n", NIPQUAD(sin.sin_addr.s_addr),
-		     ntohs((__force __be16)sin.sin_port));
+		     ntohs(sin.sin_port));
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1714,7 +1706,7 @@ static int o2net_accept_one(struct socket *sock)
 		mlog(ML_NOTICE, "unexpected connect attempted from a lower "
 		     "numbered node '%s' at " "%u.%u.%u.%u:%d with num %u\n",
 		     node->nd_name, NIPQUAD(sin.sin_addr.s_addr),
-		     ntohs((__force __be16)sin.sin_port), node->nd_num);
+		     ntohs(sin.sin_port), node->nd_num);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1725,7 +1717,7 @@ static int o2net_accept_one(struct socket *sock)
 		mlog(ML_CONN, "attempt to connect from node '%s' at "
 		     "%u.%u.%u.%u:%d but it isn't heartbeating\n",
 		     node->nd_name, NIPQUAD(sin.sin_addr.s_addr),
-		     ntohs((__force __be16)sin.sin_port));
+		     ntohs(sin.sin_port));
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1742,7 +1734,7 @@ static int o2net_accept_one(struct socket *sock)
 		mlog(ML_NOTICE, "attempt to connect from node '%s' at "
 		     "%u.%u.%u.%u:%d but it already has an open connection\n",
 		     node->nd_name, NIPQUAD(sin.sin_addr.s_addr),
-		     ntohs((__force __be16)sin.sin_port));
+		     ntohs(sin.sin_port));
 		goto out;
 	}
 
