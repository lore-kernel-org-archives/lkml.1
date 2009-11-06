Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZKFSKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZKFSKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 13:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759491AbZKFSKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 13:10:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:53197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251AbZKFSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 13:09:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/7] net, compat_ioctl: handle more ioctls correctly
Date: Fri,  6 Nov 2009 19:09:09 +0100
Message-Id: <1257530949-9695-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257530949-9695-1-git-send-email-arnd@arndb.de>
References: <1257530949-9695-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19c5sguiJOCF0t2ApTcSlG95S6jmAVk2It95ST
 MJzzGd1CSvbfK2yuLxFNiJiV1ZOdeQ7TJeFaNf7xDgviZBU5ka
 z+oieuYfZkfxIkv9mwkuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MII ioctls and SIOCSIFNAME need to go through ifsioc conversion,
which they never did so far. Some others are not implemented in the
native path, so we can just return -EINVAL directly.

Add IFSLAVE ioctls to the EINVAL list and move it to the end to
optimize the code path for the common case.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/socket.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 2621213..688de5d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2911,11 +2911,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 		return do_siocgstamp(net, sock, cmd, argp);
 	case SIOCGSTAMPNS:
 		return do_siocgstampns(net, sock, cmd, argp);
-/* Note SIOCRTMSG is no longer, so this is safe and
- * the user would have seen just an -EINVAL anyways. */
-	case SIOCRTMSG:
-	case SIOCGIFCOUNT:
-		return -EINVAL;
 
 	case FIOSETOWN:
 	case SIOCSPGRP:
@@ -2949,8 +2944,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSIFHWBROADCAST:
 	case SIOCSHWTSTAMP:
 	case SIOCDIFADDR:
-/*	case SIOCSARP: duplicate */
-/*	case SIOCDARP: duplicate */
 	case SIOCGIFBRDADDR:
 	case SIOCSIFBRDADDR:
 	case SIOCGIFDSTADDR:
@@ -2963,7 +2956,12 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSIFTXQLEN:
 	case SIOCBRADDIF:
 	case SIOCBRDELIF:
+	case SIOCSIFNAME:
+	case SIOCGMIIPHY:
+	case SIOCGMIIREG:
+	case SIOCSMIIREG:
 		return dev_ifsioc(net, sock, cmd, argp);
+
 	case ATM_GETLINKRATE32:
 	case ATM_GETNAMES32:
 	case ATM_GETTYPE32:
@@ -3010,17 +3008,22 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSARP:
 	case SIOCGARP:
 	case SIOCDARP:
-
 	case SIOCATMARK:
-	case SIOCSIFLINK:
-	case SIOCSIFNAME:
+		return sock_do_ioctl(net, sock, cmd, arg);
+	}
+
+	/* Prevent warning from compat_sys_ioctl, these always
+	 * result in -EINVAL in the native case anyway. */
+	switch (cmd) {
+	case SIOCRTMSG:
+	case SIOCGIFCOUNT:
 	case SIOCSRARP:
 	case SIOCGRARP:
 	case SIOCDRARP:
-	case SIOCGMIIPHY:
-	case SIOCGMIIREG:
-	case SIOCSMIIREG:
-		return sock_do_ioctl(net, sock, cmd, arg);
+	case SIOCSIFLINK:
+	case SIOCGIFSLAVE:
+	case SIOCSIFSLAVE:
+		return -EINVAL;
 	}
 
 	return -ENOIOCTLCMD;
-- 
1.6.3.3

