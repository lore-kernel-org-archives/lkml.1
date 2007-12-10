Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXLJBSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXLJBSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 20:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXLJBSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 20:18:17 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:50161 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbXLJBSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 20:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=RNiZR3tBaC+vpRtT7tKWwN3XMIequRLS0yKG2uMrdXsV+yYbknltengwJSIEruw5W946SOAvaqDX/pX5D96e6N9bBeeX4CMJlDTr/2gETM6TEw2SfypepnNHep+f03DK+zDpFVLGRpKdimZ+wItzUh0gcIMsealCFOKA68ithCk=
Message-Id: <20071210011800.543055487@gmail.com>
References: <20071210011741.039692330@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 09 Dec 2007 21:17:42 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Per Liden <per.liden@ericsson.com>,
       Jon Maloy <jon.maloy@ericsson.com>,
       Allan Stephens <allan.stephens@windriver.com>,
       tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kevin Winchester <kjwinchester@gmail.com>
Subject: [patch 1/1] Convert the semaphore to a mutex in net/tipc/socket.c
Content-Disposition: inline; filename=tipc-socket-sem-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Per Liden <per.liden@ericsson.com>
Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Allan Stephens <allan.stephens@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org

Note also that in the release method, down_interruptible() was being called
without checking the return value.  I converted it to mutex_lock_interruptible()
and made the interrupted case return -ERESTARTSYS, as was done for all other
calls to down_interruptible() in the file.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>

---
 net/tipc/socket.c |   56 +++++++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

Index: v2.6.24-rc4/net/tipc/socket.c
===================================================================
--- v2.6.24-rc4.orig/net/tipc/socket.c
+++ v2.6.24-rc4/net/tipc/socket.c
@@ -63,7 +63,7 @@
 struct tipc_sock {
 	struct sock sk;
 	struct tipc_port *p;
-	struct semaphore sem;
+	struct mutex lock;
 };
 
 #define tipc_sk(sk) ((struct tipc_sock*)sk)
@@ -217,7 +217,7 @@ static int tipc_create(struct net *net, 
 	tsock->p = port;
 	port->usr_handle = tsock;
 
-	init_MUTEX(&tsock->sem);
+	mutex_init(&tsock->lock);
 
 	dbg("sock_create: %x\n",tsock);
 
@@ -253,9 +253,10 @@ static int release(struct socket *sock)
 	dbg("sock_delete: %x\n",tsock);
 	if (!tsock)
 		return 0;
-	down_interruptible(&tsock->sem);
+	if (mutex_lock_interruptible(&tsock->lock))
+		return -ERESTARTSYS;
 	if (!sock->sk) {
-		up(&tsock->sem);
+		mutex_unlock(&tsock->lock);
 		return 0;
 	}
 
@@ -288,7 +289,7 @@ static int release(struct socket *sock)
 		atomic_dec(&tipc_queue_size);
 	}
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 
 	sock_put(sk);
 
@@ -315,7 +316,7 @@ static int bind(struct socket *sock, str
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	int res;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	if (unlikely(!uaddr_len)) {
@@ -346,7 +347,7 @@ static int bind(struct socket *sock, str
 		res = tipc_withdraw(tsock->p->ref, -addr->scope,
 				    &addr->addr.nameseq);
 exit:
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -367,7 +368,7 @@ static int get_name(struct socket *sock,
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	u32 res;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	*uaddr_len = sizeof(*addr);
@@ -380,7 +381,7 @@ static int get_name(struct socket *sock,
 		res = tipc_ownidentity(tsock->p->ref, &addr->addr.id);
 	addr->addr.name.domain = 0;
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -477,7 +478,7 @@ static int send_msg(struct kiocb *iocb, 
 		}
 	}
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	if (needs_conn) {
@@ -523,7 +524,7 @@ static int send_msg(struct kiocb *iocb, 
 		}
 		if (likely(res != -ELINKCONG)) {
 exit:
-			up(&tsock->sem);
+			mutex_unlock(&tsock->lock);
 			return res;
 		}
 		if (m->msg_flags & MSG_DONTWAIT) {
@@ -562,9 +563,8 @@ static int send_packet(struct kiocb *ioc
 	if (unlikely(dest))
 		return send_msg(iocb, sock, m, total_len);
 
-	if (down_interruptible(&tsock->sem)) {
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
-	}
 
 	do {
 		if (unlikely(sock->state != SS_CONNECTED)) {
@@ -578,7 +578,7 @@ static int send_packet(struct kiocb *ioc
 		res = tipc_send(tsock->p->ref, m->msg_iovlen, m->msg_iov);
 		if (likely(res != -ELINKCONG)) {
 exit:
-			up(&tsock->sem);
+			mutex_unlock(&tsock->lock);
 			return res;
 		}
 		if (m->msg_flags & MSG_DONTWAIT) {
@@ -846,7 +846,7 @@ static int recv_msg(struct kiocb *iocb, 
 
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
 
@@ -981,7 +981,7 @@ static int recv_stream(struct kiocb *ioc
 
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
 
@@ -1293,7 +1293,7 @@ static int connect(struct socket *sock, 
 	   return res;
    }
 
-   if (down_interruptible(&tsock->sem))
+   if (mutex_lock_interruptible(&tsock->lock))
 	   return -ERESTARTSYS;
 
    /* Wait for destination's 'ACK' response */
@@ -1317,7 +1317,7 @@ static int connect(struct socket *sock, 
 	   sock->state = SS_DISCONNECTING;
    }
 
-   up(&tsock->sem);
+   mutex_unlock(&tsock->lock);
    return res;
 }
 
@@ -1365,7 +1365,7 @@ static int accept(struct socket *sock, s
 		     (flags & O_NONBLOCK)))
 		return -EWOULDBLOCK;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	if (wait_event_interruptible(*sock->sk->sk_sleep,
@@ -1412,7 +1412,7 @@ static int accept(struct socket *sock, s
 		}
 	}
 exit:
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -1434,7 +1434,7 @@ static int shutdown(struct socket *sock,
 
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
 
@@ -1518,7 +1518,7 @@ static int setsockopt(struct socket *soc
 	if ((res = get_user(value, (u32 __user *)ov)))
 		return res;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	switch (opt) {
@@ -1541,7 +1541,7 @@ static int setsockopt(struct socket *soc
 		res = -EINVAL;
 	}
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 
@@ -1574,7 +1574,7 @@ static int getsockopt(struct socket *soc
 	if ((res = get_user(len, ol)))
 		return res;
 
-	if (down_interruptible(&tsock->sem))
+	if (mutex_lock_interruptible(&tsock->lock))
 		return -ERESTARTSYS;
 
 	switch (opt) {
@@ -1607,7 +1607,7 @@ static int getsockopt(struct socket *soc
 		res = put_user(sizeof(value), ol);
 	}
 
-	up(&tsock->sem);
+	mutex_unlock(&tsock->lock);
 	return res;
 }
 

-- 
