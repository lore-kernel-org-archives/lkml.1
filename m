Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab0BUODL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:03:11 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54349 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0BUODJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:03:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=InKaclEpLSCJGlv3DnIgmMnXmuHz9a0OYGfL09uz7Cj4u40AfvRR1XnhwqvOklfaVT
         pOKdEFbyPtVdXVfPhELwytkNG39libsqLcD/ngHale0RX8UztOZgG7M25LFKoEOgVBDH
         qswThzwB2o3impV873J1yIbwDXFhUKjlaWIAk=
Date: Sun, 21 Feb 2010 16:03:00 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nsproxy: remove INIT_NSPROXY()
Message-ID: <20100221140300.GA21281@core2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove INIT_NSPROXY(), use C99 initializer.
Remove INIT_IPC_NS(), INIT_NET_NS() while I'm at it.

Note: headers trim will be done later, now it's quite pointless because
results will be invalidated by merge window.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/init_task.h     |    8 --------
 include/linux/ipc_namespace.h |    5 -----
 include/net/net_namespace.h   |    5 -----
 kernel/nsproxy.c              |   13 ++++++++++++-
 4 files changed, 12 insertions(+), 19 deletions(-)

--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -32,14 +32,6 @@ extern struct fs_struct init_fs;
 }
 
 extern struct nsproxy init_nsproxy;
-#define INIT_NSPROXY(nsproxy) {						\
-	.pid_ns		= &init_pid_ns,					\
-	.count		= ATOMIC_INIT(1),				\
-	.uts_ns		= &init_uts_ns,					\
-	.mnt_ns		= NULL,						\
-	INIT_NET_NS(net_ns)                                             \
-	INIT_IPC_NS(ipc_ns)						\
-}
 
 #define INIT_SIGHAND(sighand) {						\
 	.count		= ATOMIC_INIT(1), 				\
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -62,11 +62,6 @@ extern struct ipc_namespace init_ipc_ns;
 extern atomic_t nr_ipc_ns;
 
 extern spinlock_t mq_lock;
-#if defined(CONFIG_POSIX_MQUEUE) || defined(CONFIG_SYSVIPC)
-#define INIT_IPC_NS(ns)		.ns		= &init_ipc_ns,
-#else
-#define INIT_IPC_NS(ns)
-#endif
 
 #ifdef CONFIG_SYSVIPC
 extern int register_ipcns_notifier(struct ipc_namespace *);
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -98,14 +98,9 @@ struct net {
 extern struct net init_net;
 
 #ifdef CONFIG_NET
-#define INIT_NET_NS(net_ns) .net_ns = &init_net,
-
 extern struct net *copy_net_ns(unsigned long flags, struct net *net_ns);
 
 #else /* CONFIG_NET */
-
-#define INIT_NET_NS(net_ns)
-
 static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
 {
 	/* There is nothing to copy so this is a noop */
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -24,7 +24,18 @@
 
 static struct kmem_cache *nsproxy_cachep;
 
-struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
+struct nsproxy init_nsproxy = {
+	.count	= ATOMIC_INIT(1),
+	.uts_ns	= &init_uts_ns,
+#if defined(CONFIG_POSIX_MQUEUE) || defined(CONFIG_SYSVIPC)
+	.ipc_ns	= &init_ipc_ns,
+#endif
+	.mnt_ns	= NULL,
+	.pid_ns	= &init_pid_ns,
+#ifdef CONFIG_NET
+	.net_ns	= &init_net,
+#endif
+};
 
 static inline struct nsproxy *create_nsproxy(void)
 {
