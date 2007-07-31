Return-Path: <linux-kernel-owner+w=401wt.eu-S1762517AbXGaQN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762517AbXGaQN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXGaQNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:13:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48129 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbXGaQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:13:49 -0400
Date: Tue, 31 Jul 2007 21:56:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] Introduce U16_MAX and U32_MAX
Message-ID: <alpine.LFD.0.999.0707312153500.28746@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


... in kernel.h and clean up home-grown macros elsewhere in the tree.

Leave out the one in reiserfs_fs.h as it is in the userspace-visible part
of that header. Still, #undef the (equivalent) kernel version there to
avoid seeing "redefined, previous definition was here" gcc warnings.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

[ On top of previously posted netconsole patches. ]

 drivers/net/netconsole.c    |    7 +++----
 include/linux/kernel.h      |    3 +++
 include/linux/reiserfs_fs.h |    1 +
 net/ipv4/tcp_illinois.c     |    2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 69ef1eb..47a8094 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -34,6 +34,7 @@
  *
  ****************************************************************/
 
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -389,7 +390,6 @@ static ssize_t store_local_port(struct netconsole_target *nt,
 				size_t count)
 {
 	long local_port;
-#define __U16_MAX	((__u16) ~0U)
 
 	if (nt->enabled) {
 		printk(KERN_ERR "netconsole: target (%s) is enabled, "
@@ -398,7 +398,7 @@ static ssize_t store_local_port(struct netconsole_target *nt,
 		return -EINVAL;
 	}
 
-	local_port = strtol10_check_range(buf, 0, __U16_MAX);
+	local_port = strtol10_check_range(buf, 0, U16_MAX);
 	if (local_port < 0)
 		return local_port;
 
@@ -412,7 +412,6 @@ static ssize_t store_remote_port(struct netconsole_target *nt,
 				 size_t count)
 {
 	long remote_port;
-#define __U16_MAX	((__u16) ~0U)
 
 	if (nt->enabled) {
 		printk(KERN_ERR "netconsole: target (%s) is enabled, "
@@ -421,7 +420,7 @@ static ssize_t store_remote_port(struct netconsole_target *nt,
 		return -EINVAL;
 	}
 
-	remote_port = strtol10_check_range(buf, 0, __U16_MAX);
+	remote_port = strtol10_check_range(buf, 0, U16_MAX);
 	if (remote_port < 0)
 		return remote_port;
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4300bb4..e9221de 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -30,6 +30,9 @@ extern const char linux_proc_banner[];
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
 
+#define U16_MAX		((u16) ~0U)
+#define U32_MAX		((u32) ~0U)
+
 #define STACK_MAGIC	0xdeadbeef
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 180a9d8..e452c69 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1225,6 +1225,7 @@ struct treepath var = {.path_length = ILLEGAL_PATH_ELEMENT_OFFSET, .reada = 0,}
 #define MAX_US_INT 0xffff
 
 // reiserfs version 2 has max offset 60 bits. Version 1 - 32 bit offset
+#undef	U32_MAX
 #define U32_MAX (~(__u32)0)
 
 static inline loff_t max_reiserfs_offset(struct inode *inode)
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index cc5de6f..227abcd 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -12,6 +12,7 @@
  * Copyright (C) 2007 Stephen Hemminger <shemminger@linux-foundation.org>
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/inet_diag.h>
@@ -23,7 +24,6 @@
 #define ALPHA_MIN	((3*ALPHA_SCALE)/10)	/* ~0.3 */
 #define ALPHA_MAX	(10*ALPHA_SCALE)	/* 10.0 */
 #define ALPHA_BASE	ALPHA_SCALE		/* 1.0 */
-#define U32_MAX		((u32)~0U)
 #define RTT_MAX		(U32_MAX / ALPHA_MAX)	/* 3.3 secs */
 
 #define BETA_SHIFT	6
