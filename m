Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZKOQEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZKOQEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 11:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZKOQEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 11:04:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55185 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZKOQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 11:04:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 3/4] compat_ioctl: simplify lookup table
Date: Sun, 15 Nov 2009 16:04:09 +0000
Message-Id: <1258301050-26900-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258301050-26900-1-git-send-email-arnd@arndb.de>
References: <1258301050-26900-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19KuH3YZYOyVUX5cQ282/mT/k3wtmhW2EE+pJU
 kNPaQLY/JJVCPE5xmZm+a2pNwsT6Ce6KiqM4JXtc8yTtwQavoX
 POfBH7A370iKzeCjqyxkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compat_ioctl table now only contains entries for
COMPATIBLE_IOCTL, so we only need to know if a number
is listed in it or now.

As an optimization, we hash the table entries with a
reversible transformation to get a more uniform distribution
over it, sort the table at startup and then guess the
position in the table when an ioctl number gets called
to do a linear search from there.

With the current set of ioctl numbers and the chosen
transformation function, we need an average of four
steps to find if a number is in the set, all of the
accesses within one or two cache lines.

This at least as good as the previous hash table
approach but saves 8.5 kb of kernel memory.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |   87 +++++++++++++++++++++++++----------------------------
 1 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index d8039c3..61ce31f 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -111,6 +111,8 @@
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/video.h>
 
+#include <linux/sort.h>
+
 #ifdef CONFIG_SPARC
 #include <asm/fbio.h>
 #endif
@@ -1048,15 +1050,13 @@ static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
 }
 #endif
 
+/*
+ * simple reversible transform to make our table more evenly
+ * distributed after sorting.
+ */
+#define XFORM(i) (((i) ^ ((i) << 27) ^ ((i) << 17)) & 0xffffffff)
 
-struct ioctl_trans {
-	unsigned long cmd;
-	struct ioctl_trans *next;
-};
-
-/* pointer to compatible structure or no argument */
-#define COMPATIBLE_IOCTL(cmd) { (cmd), },
-
+#define COMPATIBLE_IOCTL(cmd) XFORM(cmd),
 /* ioctl should not be warned about even if it's not implemented.
    Valid reasons to use this:
    - It is implemented with ->compat_ioctl on some device, but programs
@@ -1066,7 +1066,7 @@ struct ioctl_trans {
    Most other reasons are not valid. */
 #define IGNORE_IOCTL(cmd) COMPATIBLE_IOCTL(cmd)
 
-static struct ioctl_trans ioctl_start[] = {
+static unsigned int ioctl_pointer[] = {
 /* compatible ioctls first */
 COMPATIBLE_IOCTL(0x4B50)   /* KDGHWCLK - not in the kernel, but don't complain */
 COMPATIBLE_IOCTL(0x4B51)   /* KDSHWCLK - not in the kernel, but don't complain */
@@ -1710,14 +1710,6 @@ IGNORE_IOCTL(FBIOGCURSOR32)
 #endif
 };
 
-#define IOCTL_HASHSIZE 256
-static struct ioctl_trans *ioctl32_hash_table[IOCTL_HASHSIZE];
-
-static inline unsigned long ioctl32_hash(unsigned long cmd)
-{
-	return (((cmd >> 6) ^ (cmd >> 4) ^ cmd)) % IOCTL_HASHSIZE;
-}
-
 /*
  * Convert common ioctl arguments based on their command number
  *
@@ -1861,12 +1853,33 @@ static void compat_ioctl_error(struct file *filp, unsigned int fd,
 		free_page((unsigned long)path);
 }
 
+static int compat_ioctl_check_table(unsigned int xcmd)
+{
+	int i;
+	const int max = ARRAY_SIZE(ioctl_pointer) - 1;
+
+	BUILD_BUG_ON(max >= (1 << 16));
+
+	/* guess initial offset into table, assuming a
+	   normalized distribution */
+	i = ((xcmd >> 16) * max) >> 16;
+
+	/* do linear search up first, until greater or equal */
+	while (ioctl_pointer[i] < xcmd && i < max)
+		i++;
+
+	/* then do linear search down */
+	while (ioctl_pointer[i] > xcmd && i > 0)
+		i--;
+
+	return ioctl_pointer[i] == xcmd;
+}
+
 asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 				unsigned long arg)
 {
 	struct file *filp;
 	int error = -EBADF;
-	struct ioctl_trans *t;
 	int fput_needed;
 
 	filp = fget_light(fd, &fput_needed);
@@ -1923,10 +1936,8 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 		break;
 	}
 
-	for (t = ioctl32_hash_table[ioctl32_hash(cmd)]; t; t = t->next) {
-		if (t->cmd == cmd)
-			goto found_handler;
-	}
+	if (compat_ioctl_check_table(XFORM(cmd)))
+		goto found_handler;
 
 	error = do_ioctl_trans(fd, cmd, arg, filp);
 	if (error == -ENOIOCTLCMD) {
@@ -1949,35 +1960,19 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	return error;
 }
 
-static void ioctl32_insert_translation(struct ioctl_trans *trans)
+static int __init init_sys32_ioctl_cmp(const void *p, const void *q)
 {
-	unsigned long hash;
-	struct ioctl_trans *t;
-
-	hash = ioctl32_hash (trans->cmd);
-	if (!ioctl32_hash_table[hash])
-		ioctl32_hash_table[hash] = trans;
-	else {
-		t = ioctl32_hash_table[hash];
-		while (t->next)
-			t = t->next;
-		trans->next = NULL;
-		t->next = trans;
-	}
+	unsigned int a, b;
+	a = *(unsigned int *)p;
+	b = *(unsigned int *)q;
+
+	return a - b;
 }
 
 static int __init init_sys32_ioctl(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ioctl_start); i++) {
-		if (ioctl_start[i].next) {
-			printk("ioctl translation %d bad\n",i);
-			return -1;
-		}
-
-		ioctl32_insert_translation(&ioctl_start[i]);
-	}
+	sort(ioctl_pointer, ARRAY_SIZE(ioctl_pointer), sizeof(*ioctl_pointer),
+		init_sys32_ioctl_cmp, NULL);
 	return 0;
 }
 __initcall(init_sys32_ioctl);
-- 
1.6.3.3

