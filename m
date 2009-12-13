Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbZLMDaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbZLMDaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 22:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbZLMDaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 22:30:14 -0500
Received: from lists.laptop.org ([18.85.2.145]:51797 "HELO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757728AbZLMDaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 22:30:13 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Dec 2009 22:30:13 EST
Date: Sat, 12 Dec 2009 22:26:07 -0500
From: Michael Stone <michael@laptop.org>
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, Michael Stone <michael@laptop.org>
Subject: [PATCH] Security: Implement RLIMIT_NETWORK.
Message-ID: <20091213032607.GA4332@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1260674379-4262-1-git-send-email-michael@laptop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Bernstein has observed [1] that security-conscious userland processes
may benefit from the ability to irrevocably remove their ability to create,
bind, connect to, or send messages except in the case of previously connected
sockets or AF_UNIX filesystem sockets. We provide this facility by implementing
support for a new rlimit called RLIMIT_NETWORK.

This facility is particularly attractive to security platforms like OLPC
Bitfrost [2] and to isolation programs like Rainbow [3] and Plash [4].

[1]: http://cr.yp.to/unix/disablenetwork.html
[2]: http://wiki.laptop.org/go/OLPC_Bitfrost
[3]: http://wiki.laptop.org/go/Rainbow
[4]: http://plash.beasts.org/

Signed-off-by: Michael Stone <michael@laptop.org>
Tested-by: Bernie Innocenti <bernie@codewiz.org>
---
  fs/proc/base.c                 |    1 +
  include/asm-generic/resource.h |    4 ++-
  kernel/ptrace.c                |    3 ++
  net/socket.c                   |   53 ++++++++++++++++++++++++++++++----------
  net/unix/af_unix.c             |   28 +++++++++++++++++++-
  5 files changed, 73 insertions(+), 16 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index af643b5..7a153f1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -474,6 +474,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
  	[RLIMIT_NICE] = {"Max nice priority", NULL},
  	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
  	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
+	[RLIMIT_NETWORK] = {"Network access permitted", "boolean"},
  };
  
  /* Display limits for a process */
diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
index 587566f..2bed565 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -45,7 +45,8 @@
  					   0-39 for nice level 19 .. -20 */
  #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
  #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+#define RLIMIT_NETWORK		16	/* permit network access */
+#define RLIM_NLIMITS		17
  
  /*
   * SuS says limits have to be unsigned.
@@ -87,6 +88,7 @@
  	[RLIMIT_NICE]		= { 0, 0 },				\
  	[RLIMIT_RTPRIO]		= { 0, 0 },				\
  	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
+	[RLIMIT_NETWORK]	= {  RLIM_INFINITY,  RLIM_INFINITY },	\
  }
  
  #endif	/* __KERNEL__ */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 23bd09c..e3d2c63 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -22,6 +22,7 @@
  #include <linux/pid_namespace.h>
  #include <linux/syscalls.h>
  #include <linux/uaccess.h>
+#include <asm/resource.h>
  
  
  /*
@@ -151,6 +152,8 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
  		dumpable = get_dumpable(task->mm);
  	if (!dumpable && !capable(CAP_SYS_PTRACE))
  		return -EPERM;
+	if (!current->signal->rlim[RLIMIT_NETWORK].rlim_cur)
+		return -EPERM;
  
  	return security_ptrace_access_check(task, mode);
  }
diff --git a/net/socket.c b/net/socket.c
index b94c3dd..a2e2873 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -90,6 +90,7 @@
  
  #include <asm/uaccess.h>
  #include <asm/unistd.h>
+#include <asm/resource.h>
  
  #include <net/compat.h>
  #include <net/wext.h>
@@ -576,6 +577,12 @@ static inline int __sock_sendmsg(struct kiocb *iocb, struct socket *sock,
  	if (err)
  		return err;
  
+	err = -EPERM;
+	if (sock->sk->sk_family != AF_UNIX &&
+		!current->signal->rlim[RLIMIT_NETWORK].rlim_cur &&
+		(msg->msg_name != NULL || msg->msg_namelen != 0))
+		return err;
+
  	return sock->ops->sendmsg(iocb, sock, msg, size);
  }
  
@@ -1227,6 +1234,11 @@ static int __sock_create(struct net *net, int family, int type, int protocol,
  	if (err)
  		return err;
  
+	err = (family == AF_UNIX ||
+		current->signal->rlim[RLIMIT_NETWORK].rlim_cur) ? 0 : -EPERM;
+	if (err)
+		return err;
+
  	/*
  	 *	Allocate the socket and allow the family to set things up. if
  	 *	the protocol is 0, the family is instructed to select an appropriate
@@ -1465,19 +1477,29 @@ SYSCALL_DEFINE3(bind, int, fd, struct sockaddr __user *, umyaddr, int, addrlen)
  	int err, fput_needed;
  
  	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (sock) {
-		err = move_addr_to_kernel(umyaddr, addrlen, (struct sockaddr *)&address);
-		if (err >= 0) {
-			err = security_socket_bind(sock,
-						   (struct sockaddr *)&address,
-						   addrlen);
-			if (!err)
-				err = sock->ops->bind(sock,
-						      (struct sockaddr *)
-						      &address, addrlen);
-		}
-		fput_light(sock->file, fput_needed);
-	}
+	if (!sock)
+		goto out;
+
+	err = move_addr_to_kernel(umyaddr, addrlen, (struct sockaddr *)&address);
+	if (err < 0)
+		goto out_fput;
+
+	err = security_socket_bind(sock,
+				   (struct sockaddr *)&address,
+				   addrlen);
+	if (err)
+		goto out_fput;
+
+	err = (((struct sockaddr *)&address)->sa_family == AF_UNIX ||
+		current->signal->rlim[RLIMIT_NETWORK].rlim_cur) ? 0 : -EPERM;
+	if (err)
+		goto out_fput;
+
+	err = sock->ops->bind(sock, (struct sockaddr *) &address, addrlen);
+
+out_fput:
+	fput_light(sock->file, fput_needed);
+out:
  	return err;
  }
  
@@ -1639,6 +1661,11 @@ SYSCALL_DEFINE3(connect, int, fd, struct sockaddr __user *, uservaddr,
  	if (err)
  		goto out_put;
  
+	err = (((struct sockaddr *)&address)->sa_family == AF_UNIX ||
+		current->signal->rlim[RLIMIT_NETWORK].rlim_cur) ? 0 : -EPERM;
+	if (err)
+		goto out_put;
+
  	err = sock->ops->connect(sock, (struct sockaddr *)&address, addrlen,
  				 sock->file->f_flags);
  out_put:
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f255119..3bbc945 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -99,6 +99,7 @@
  #include <linux/fs.h>
  #include <linux/slab.h>
  #include <asm/uaccess.h>
+#include <asm/resource.h>
  #include <linux/skbuff.h>
  #include <linux/netdevice.h>
  #include <net/net_namespace.h>
@@ -797,6 +798,11 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
  		goto out;
  	addr_len = err;
  
+	err = (current->signal->rlim[RLIMIT_NETWORK].rlim_cur ||
+		sunaddr->sun_path[0]) ? 0 : -EPERM;
+	if (err)
+		goto out;
+
  	mutex_lock(&u->readlock);
  
  	err = -EINVAL;
@@ -934,6 +940,11 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
  			goto out;
  		alen = err;
  
+		err = (current->signal->rlim[RLIMIT_NETWORK].rlim_cur ||
+		       sunaddr->sun_path[0]) ? 0 : -EPERM;
+		if (err)
+			goto out;
+
  		if (test_bit(SOCK_PASSCRED, &sock->flags) &&
  		    !unix_sk(sk)->addr && (err = unix_autobind(sock)) != 0)
  			goto out;
@@ -1033,8 +1044,13 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
  		goto out;
  	addr_len = err;
  
-	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr &&
-	    (err = unix_autobind(sock)) != 0)
+	err = (current->signal->rlim[RLIMIT_NETWORK].rlim_cur ||
+		sunaddr->sun_path[0]) ? 0 : -EPERM;
+	if (err)
+		goto out;
+
+	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr
+		&& (err = unix_autobind(sock)) != 0)
  		goto out;
  
  	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
@@ -1370,6 +1386,11 @@ static int unix_dgram_sendmsg(struct kiocb *kiocb, struct socket *sock,
  		if (err < 0)
  			goto out;
  		namelen = err;
+
+		err = -EPERM;
+		if (!current->signal->rlim[RLIMIT_NETWORK].rlim_cur &&
+			!sunaddr->sun_path[0])
+			goto out;
  	} else {
  		sunaddr = NULL;
  		err = -ENOTCONN;
@@ -1520,6 +1541,9 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
  	if (msg->msg_namelen) {
  		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
  		goto out_err;
+		/* RLIMIT_NETWORK requires no change here since connection-less
+		 * unix stream sockets are not supported.
+		 * See Documentation/rlimit_network.txt for details. */
  	} else {
  		sunaddr = NULL;
  		err = -ENOTCONN;
-- 
1.5.6.5

