Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYLFHAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYLFHAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 02:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbYLFHA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 02:00:29 -0500
Received: from vps1.tull.net ([66.180.172.116]:52704 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754690AbYLFHA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 02:00:27 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [RFC PATCH v1 3/3] Sample refactor of socket.c to use recursive printk
Cc: <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 06 Dec 2008 18:00:23 +1100
Message-ID: <20081206070023.29149.92171.stgit@marcab.local.tull.net>
In-Reply-To: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sample refactor of socket.c to use recursive printk

Add a new function net_printk which takes a level argument
(kernel message level), format string and varargs and
calls printk with this format string and arguments:

    printk("%sNET: %v\n", level, fmt, args);

This is a proof of concept to show that recursive printk
works and is useful.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 net/socket.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)


diff --git a/net/socket.c b/net/socket.c
index 92764d8..d2e0d67 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -171,6 +171,19 @@ static DEFINE_PER_CPU(int, sockets_in_use) = 0;
 					   :unix_mkname()).
 					 */
 
+/* printk for net subsystem.
+ * Prefixes every message with NET:
+ *
+ */
+
+void net_printk(char *level, char *fmt, ...) {
+	va_list	ap;
+	va_start(ap, fmt);
+
+	printk("%sNET: %v\n", level, fmt, ap);
+	va_end(ap);
+}
+
 /**
  *	move_addr_to_kernel	-	copy a socket address into kernel space
  *	@uaddr: Address in user space
@@ -535,7 +548,7 @@ void sock_release(struct socket *sock)
 	}
 
 	if (sock->fasync_list)
-		printk(KERN_ERR "sock_release: fasync list not empty!\n");
+		net_printk(KERN_ERR, "sock_release: fasync list not empty!");
 
 	get_cpu_var(sockets_in_use)--;
 	put_cpu_var(sockets_in_use);
@@ -987,7 +1000,7 @@ static int sock_close(struct inode *inode, struct file *filp)
 	 */
 
 	if (!inode) {
-		printk(KERN_DEBUG "sock_close: NULL inode\n");
+		net_printk(KERN_DEBUG, "sock_close: NULL inode");
 		return 0;
 	}
 	sock_release(SOCKET_I(inode));
@@ -1116,7 +1129,7 @@ static int __sock_create(struct net *net, int family, int type, int protocol,
 		static int warned;
 		if (!warned) {
 			warned = 1;
-			printk(KERN_INFO "%s uses obsolete (PF_INET,SOCK_PACKET)\n",
+			net_printk(KERN_INFO, "%s uses obsolete (PF_INET,SOCK_PACKET)",
 			       current->comm);
 		}
 		family = PF_PACKET;
@@ -1134,7 +1147,7 @@ static int __sock_create(struct net *net, int family, int type, int protocol,
 	sock = sock_alloc();
 	if (!sock) {
 		if (net_ratelimit())
-			printk(KERN_WARNING "socket: no more sockets\n");
+			net_printk(KERN_WARNING, "socket: no more sockets");
 		return -ENFILE;	/* Not exactly a match, but its the
 				   closest posix thing */
 	}
@@ -2162,7 +2175,7 @@ int sock_register(const struct net_proto_family *ops)
 	int err;
 
 	if (ops->family >= NPROTO) {
-		printk(KERN_CRIT "protocol %d >= NPROTO(%d)\n", ops->family,
+		net_printk(KERN_CRIT, "protocol %d >= NPROTO(%d)", ops->family,
 		       NPROTO);
 		return -ENOBUFS;
 	}
@@ -2176,7 +2189,7 @@ int sock_register(const struct net_proto_family *ops)
 	}
 	spin_unlock(&net_family_lock);
 
-	printk(KERN_INFO "NET: Registered protocol family %d\n", ops->family);
+	net_printk(KERN_INFO, "Registered protocol family %d", ops->family);
 	return err;
 }
 
@@ -2203,7 +2216,7 @@ void sock_unregister(int family)
 
 	synchronize_rcu();
 
-	printk(KERN_INFO "NET: Unregistered protocol family %d\n", family);
+	net_printk(KERN_INFO, "Unregistered protocol family %d", family);
 }
 
 static int __init sock_init(void)

