Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYCBSg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYCBSg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 13:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYCBSgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 13:36:48 -0500
Received: from mx1.riseup.net ([204.13.164.18]:40914 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYCBSgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 13:36:47 -0500
Date: Sun, 2 Mar 2008 19:36:37 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com, tipc-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] TIPC Protocol: Convert tsock->sem in a mutex
Message-ID: <20080302183637.GB2783@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	per.liden@ericsson.com, jon.maloy@ericsson.com,
	allan.stephens@windriver.com, tipc-discussion@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TIPC Protocol: The semaphore tsock->sem is used as mutex, convert it
to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 2290903..9ae8e9f 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -43,7 +43,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fcntl.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <asm/string.h>
 #include <asm/atomic.h>
 #include <net/sock.h>
@@ -63,7 +63,7 @@
 struct tipc_sock {
 	struct sock sk;
 	struct tipc_port *p;
-	struct semaphore sem;
+	struct mutex lock;
 };
 
 #define tipc_sk(sk) ((struct tipc_sock*)sk)
@@ -217,7 +217,7 @@ static int tipc_create(struct net *net, struct socket *sock, int protocol)
 	tsock->p = port;
 	port->usr_handle = tsock;
 
-	init_MUTEX(&tsock->sem);
+	mutex_init(&tsock->lock);
 
 	dbg("sock_create: %x\n",tsock);
 
@@ -253,9 +253,9 @@ static int release(struct socket *sock)
 	dbg("sock_delete: %x\n",tsock);
 	if (!tsock)
 		return 0;
-	down(&tsock->sem);
+	mutex_lock(&tsock->lock);
 	if (!sock->sk) {
-		up(&tsock->sem);
+		mutex_unlock(&tsock->lock);
 		return 0;
 	}
 
@@ -288,7 +288,7 @@ static int release(struct socket *sock)
 		atomic_dec(&tipc_queue_size);
 	}
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 
 	sock_put(sk);
 
@@ -315,7 +315,7 @@ static int bind(struct socket *sock, struct sockaddr *uaddr, int uaddr_len)
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	int res;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	if (unlikely(!uaddr_len)) {
@@ -346,7 +346,7 @@ static int bind(struct socket *sock, struct sockaddr *uaddr, int uaddr_len)
 		res = tipc_withdraw(tsock->p->ref, -addr->scope,
 				    &addr->addr.nameseq);
 exit:
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -367,7 +367,7 @@ static int get_name(struct socket *sock, struct sockaddr *uaddr,
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	u32 res;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	*uaddr_len = sizeof(*addr);
@@ -380,7 +380,7 @@ static int get_name(struct socket *sock, struct sockaddr *uaddr,
 		res = tipc_ownidentity(tsock->p->ref, &addr->addr.id);
 	addr->addr.name.domain = 0;
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -477,7 +477,7 @@ static int send_msg(struct kiocb *iocb, struct socket *sock,
 		}
 	}
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	if (needs_conn) {
@@ -523,7 +523,7 @@ static int send_msg(struct kiocb *iocb, struct socket *sock,
 		}
 		if (likely(res != -ELINKCONG)) {
 exit:
-			up(&tsock->sem);
+			mutex_unlock(&tsock->lock);
 			return res;
 		}
 		if (m->msg_flags & MSG_DONTWAIT) {
@@ -562,7 +562,7 @@ static int send_packet(struct kiocb *iocb, struct socket *sock,
 	if (unlikely(dest))
 		return send_msg(iocb, sock, m, total_len);
 
-	if (down_interruptible(&tsock->sem)) {
+	if (mutex_lock_interruptible(&tsock->lock)) {
 		return -ERESTARTSYS;
 	}
 
@@ -578,7 +578,7 @@ static int send_packet(struct kiocb *iocb, struct socket *sock,
 		res = tipc_send(tsock->p->ref, m->msg_iovlen, m->msg_iov);
 		if (likely(res != -ELINKCONG)) {
 exit:
-			up(&tsock->sem);
+			mutex_unlock(&tsock->lock);
 			return res;
 		}
 		if (m->msg_flags & MSG_DONTWAIT) {
@@ -846,7 +846,7 @@ static int recv_msg(struct kiocb *iocb, struct socket *sock,
 
 	/* Look for a message in receive queue; wait if necessary */
 
-	if (unlikely(down_interruptible(&tsock->sem)))
+	if (unlikely(mutex_lock_interruptible(&tsock->lock)))
 		return -ERESTARTSYS;
 
 restart:
@@ -930,7 +930,7 @@ restart:
 		advance_queue(tsock);
 	}
 exit:
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -981,7 +981,7 @@ static int recv_stream(struct kiocb *iocb, struct socket *sock,
 
 	/* Look for a message in receive queue; wait if necessary */
 
-	if (unlikely(down_interruptible(&tsock->sem)))
+	if (unlikely(mutex_lock_interruptible(&tsock->lock)))
 		return -ERESTARTSYS;
 
 restart:
@@ -1077,7 +1077,7 @@ restart:
 		goto restart;
 
 exit:
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return sz_copied ? sz_copied : res;
 }
 
@@ -1293,7 +1293,7 @@ static int connect(struct socket *sock, struct sockaddr *dest, int destlen,
 	   return res;
    }
 
-   if (down_interruptible(&tsock->sem))
+   if (mutex_lock_interruptible(&tsock->lock))
 	   return -ERESTARTSYS;
 
    /* Wait for destination's 'ACK' response */
@@ -1317,7 +1317,7 @@ static int connect(struct socket *sock, struct sockaddr *dest, int destlen,
 	   sock->state = SS_DISCONNECTING;
    }
 
-   up(&tsock->sem);
+   mutex_unlock(&tsock->lock);
    return res;
 }
 
@@ -1365,7 +1365,7 @@ static int accept(struct socket *sock, struct socket *newsock, int flags)
 		     (flags & O_NONBLOCK)))
 		return -EWOULDBLOCK;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	if (wait_event_interruptible(*sock->sk->sk_sleep,
@@ -1412,7 +1412,7 @@ static int accept(struct socket *sock, struct socket *newsock, int flags)
 		}
 	}
 exit:
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -1434,7 +1434,7 @@ static int shutdown(struct socket *sock, int how)
 
 	/* Could return -EINVAL for an invalid "how", but why bother? */
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	sock_lock(tsock);
@@ -1484,7 +1484,7 @@ restart:
 
 	sock_unlock(tsock);
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -1518,7 +1518,7 @@ static int setsockopt(struct socket *sock,
 	if ((res = get_user(value, (u32 __user *)ov)))
 		return res;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	switch (opt) {
@@ -1541,7 +1541,7 @@ static int setsockopt(struct socket *sock,
 		res = -EINVAL;
 	}
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -1574,7 +1574,7 @@ static int getsockopt(struct socket *sock,
 	if ((res = get_user(len, ol)))
 		return res;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	switch (opt) {
@@ -1607,7 +1607,7 @@ static int getsockopt(struct socket *sock,
 		res = put_user(sizeof(value), ol);
 	}
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

    Ma patrie est où je suis, où personne ne me dérange, où personne
    ne me demande que je suis, d'où je viens et ce que je fais
                              (B. Traven)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
