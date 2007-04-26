Return-Path: <linux-kernel-owner+w=401wt.eu-S932975AbXDZGGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbXDZGGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXDZGGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:06:11 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:41519 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbXDZGGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:06:09 -0400
Date: Thu, 26 Apr 2007 02:06:06 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 04/12] SELinux: rename selinux_netlabel.h to netlabel.h
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260205220.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>

In the beginning I named the file selinux_netlabel.h to avoid potential
namespace colisions.  However, over time I have realized that there are several
other similar cases of multiple header files with the same name so I'm changing
the name to something which better fits with existing naming conventions.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/hooks.c                    |    2 +-
 security/selinux/include/netlabel.h         |  121 +++++++++++++++++++++++++++
 security/selinux/include/selinux_netlabel.h |  121 ---------------------------
 security/selinux/ss/services.c              |    2 +-
 4 files changed, 123 insertions(+), 123 deletions(-)
 create mode 100644 security/selinux/include/netlabel.h
 delete mode 100644 security/selinux/include/selinux_netlabel.h

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d41e24d..7f8d0b1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -77,7 +77,7 @@
 #include "objsec.h"
 #include "netif.h"
 #include "xfrm.h"
-#include "selinux_netlabel.h"
+#include "netlabel.h"
 
 #define XATTR_SELINUX_SUFFIX "selinux"
 #define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
diff --git a/security/selinux/include/netlabel.h b/security/selinux/include/netlabel.h
new file mode 100644
index 0000000..218e3f7
--- /dev/null
+++ b/security/selinux/include/netlabel.h
@@ -0,0 +1,121 @@
+/*
+ * SELinux interface to the NetLabel subsystem
+ *
+ * Author : Paul Moore <paul.moore@hp.com>
+ *
+ */
+
+/*
+ * (c) Copyright Hewlett-Packard Development Company, L.P., 2006
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#ifndef _SELINUX_NETLABEL_H_
+#define _SELINUX_NETLABEL_H_
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/net.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+
+#include "avc.h"
+#include "objsec.h"
+
+#ifdef CONFIG_NETLABEL
+void selinux_netlbl_cache_invalidate(void);
+
+void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec,
+				      int family);
+void selinux_netlbl_sk_security_init(struct sk_security_struct *ssec,
+				     int family);
+void selinux_netlbl_sk_security_clone(struct sk_security_struct *ssec,
+				      struct sk_security_struct *newssec);
+
+int selinux_netlbl_skbuff_getsid(struct sk_buff *skb, u32 base_sid, u32 *sid);
+
+void selinux_netlbl_sock_graft(struct sock *sk, struct socket *sock);
+int selinux_netlbl_socket_post_create(struct socket *sock);
+int selinux_netlbl_inode_permission(struct inode *inode, int mask);
+int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
+				struct sk_buff *skb,
+				struct avc_audit_data *ad);
+int selinux_netlbl_socket_setsockopt(struct socket *sock,
+				     int level,
+				     int optname);
+#else
+static inline void selinux_netlbl_cache_invalidate(void)
+{
+	return;
+}
+
+static inline void selinux_netlbl_sk_security_reset(
+	                                       struct sk_security_struct *ssec,
+					       int family)
+{
+	return;
+}
+static inline void selinux_netlbl_sk_security_init(
+	                                       struct sk_security_struct *ssec,
+					       int family)
+{
+	return;
+}
+static inline void selinux_netlbl_sk_security_clone(
+	                                    struct sk_security_struct *ssec,
+					    struct sk_security_struct *newssec)
+{
+	return;
+}
+
+static inline int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
+					       u32 base_sid,
+					       u32 *sid)
+{
+	*sid = SECSID_NULL;
+	return 0;
+}
+
+static inline void selinux_netlbl_sock_graft(struct sock *sk,
+					     struct socket *sock)
+{
+	return;
+}
+static inline int selinux_netlbl_socket_post_create(struct socket *sock)
+{
+	return 0;
+}
+static inline int selinux_netlbl_inode_permission(struct inode *inode,
+						  int mask)
+{
+	return 0;
+}
+static inline int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
+					      struct sk_buff *skb,
+					      struct avc_audit_data *ad)
+{
+	return 0;
+}
+static inline int selinux_netlbl_socket_setsockopt(struct socket *sock,
+						   int level,
+						   int optname)
+{
+	return 0;
+}
+#endif /* CONFIG_NETLABEL */
+
+#endif
diff --git a/security/selinux/include/selinux_netlabel.h b/security/selinux/include/selinux_netlabel.h
deleted file mode 100644
index 218e3f7..0000000
--- a/security/selinux/include/selinux_netlabel.h
+++ /dev/null
@@ -1,121 +0,0 @@
-/*
- * SELinux interface to the NetLabel subsystem
- *
- * Author : Paul Moore <paul.moore@hp.com>
- *
- */
-
-/*
- * (c) Copyright Hewlett-Packard Development Company, L.P., 2006
- *
- * This program is free software;  you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY;  without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
- * the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program;  if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- */
-
-#ifndef _SELINUX_NETLABEL_H_
-#define _SELINUX_NETLABEL_H_
-
-#include <linux/types.h>
-#include <linux/fs.h>
-#include <linux/net.h>
-#include <linux/skbuff.h>
-#include <net/sock.h>
-
-#include "avc.h"
-#include "objsec.h"
-
-#ifdef CONFIG_NETLABEL
-void selinux_netlbl_cache_invalidate(void);
-
-void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec,
-				      int family);
-void selinux_netlbl_sk_security_init(struct sk_security_struct *ssec,
-				     int family);
-void selinux_netlbl_sk_security_clone(struct sk_security_struct *ssec,
-				      struct sk_security_struct *newssec);
-
-int selinux_netlbl_skbuff_getsid(struct sk_buff *skb, u32 base_sid, u32 *sid);
-
-void selinux_netlbl_sock_graft(struct sock *sk, struct socket *sock);
-int selinux_netlbl_socket_post_create(struct socket *sock);
-int selinux_netlbl_inode_permission(struct inode *inode, int mask);
-int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
-				struct sk_buff *skb,
-				struct avc_audit_data *ad);
-int selinux_netlbl_socket_setsockopt(struct socket *sock,
-				     int level,
-				     int optname);
-#else
-static inline void selinux_netlbl_cache_invalidate(void)
-{
-	return;
-}
-
-static inline void selinux_netlbl_sk_security_reset(
-	                                       struct sk_security_struct *ssec,
-					       int family)
-{
-	return;
-}
-static inline void selinux_netlbl_sk_security_init(
-	                                       struct sk_security_struct *ssec,
-					       int family)
-{
-	return;
-}
-static inline void selinux_netlbl_sk_security_clone(
-	                                    struct sk_security_struct *ssec,
-					    struct sk_security_struct *newssec)
-{
-	return;
-}
-
-static inline int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
-					       u32 base_sid,
-					       u32 *sid)
-{
-	*sid = SECSID_NULL;
-	return 0;
-}
-
-static inline void selinux_netlbl_sock_graft(struct sock *sk,
-					     struct socket *sock)
-{
-	return;
-}
-static inline int selinux_netlbl_socket_post_create(struct socket *sock)
-{
-	return 0;
-}
-static inline int selinux_netlbl_inode_permission(struct inode *inode,
-						  int mask)
-{
-	return 0;
-}
-static inline int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
-					      struct sk_buff *skb,
-					      struct avc_audit_data *ad)
-{
-	return 0;
-}
-static inline int selinux_netlbl_socket_setsockopt(struct socket *sock,
-						   int level,
-						   int optname)
-{
-	return 0;
-}
-#endif /* CONFIG_NETLABEL */
-
-#endif
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index c8913c5..f4129f5 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -53,7 +53,7 @@
 #include "conditional.h"
 #include "mls.h"
 #include "objsec.h"
-#include "selinux_netlabel.h"
+#include "netlabel.h"
 #include "xfrm.h"
 #include "ebitmap.h"
 
-- 
1.5.0.6

