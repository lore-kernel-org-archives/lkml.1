Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYI2XcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYI2XcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYI2XcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:32:18 -0400
Received: from waste.org ([66.93.16.53]:51486 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYI2XcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:32:17 -0400
Subject: [RFC PATCH 2/2] Shrink compat_ioctl.c
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1222730830.23159.12.camel@calx>
References: <1222730830.23159.12.camel@calx>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 18:29:51 -0500
Message-Id: <1222730991.23159.15.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compat-ioctl: further compactify table

Most entries use the basic compat handler, which means for most
entries it's redundant. Rather than store a handler for each entry, we
split the table so that there are two entry types, the 'basic stuff'
and the handler pointer.

At build time, the table is sorted so that each entry with a handler
pointer is two entries, handler pointer first. At init time we re-sort
the list so that all the handler pointers are at the end of the table
and each basic entry tracks the index that the corresponding handler
pointer is at.

This cuts the size of most entries in half, so the table goes from
~12k to ~7k.

diff -r b055e64aea17 -r 6841f3ce32be fs/compat_ioctl.c
--- a/fs/compat_ioctl.c	Mon Sep 29 17:28:41 2008 -0500
+++ b/fs/compat_ioctl.c	Mon Sep 29 17:28:44 2008 -0500
@@ -1825,21 +1825,26 @@
 					unsigned long, struct file *);
 
 struct ioctl_trans {
-	ioctl_trans_handler_t handler;
-	unsigned int cmd;
-	unsigned short next;
+	union {
+		struct {
+			unsigned int cmd;
+			short handle; /* index of entry containing fn ptr */
+			short next; /* index of next entry in hash chain */
+		} e;
+		ioctl_trans_handler_t handler;
+	} u;
 };
 
-#define HANDLE_IOCTL(cmd,handler) \
-	{ (ioctl_trans_handler_t)(handler), (cmd)},
+#define HANDLE_IOCTL(command, fn) \
+	{{ .handler = (ioctl_trans_handler_t)(fn) }},	\
+	{{ .e = { .cmd = (command), .handle = 1 }}},
+
+/* argument is an unsigned long integer, not a pointer */
+#define ULONG_IOCTL(cmd) HANDLE_IOCTL(cmd, sys_ioctl)
 
 /* pointer to compatible structure or no argument */
-#define COMPATIBLE_IOCTL(cmd) \
-	{ do_ioctl32_pointer, (cmd) },
-
-/* argument is an unsigned long integer, not a pointer */
-#define ULONG_IOCTL(cmd) \
-	{ (ioctl_trans_handler_t)sys_ioctl, (cmd) },
+#define COMPATIBLE_IOCTL(command) \
+	{{ .e = { .cmd = (command) }}},
 
 /* ioctl should not be warned about even if it's not implemented.
    Valid reasons to use this:
@@ -2814,8 +2819,8 @@
 		break;
 	}
 
-	for (t = ioctl32_hash(cmd); t >= 0; t = ioctl_table[t].next) {
-		if (ioctl_table[t].cmd == cmd)
+	for (t = ioctl32_hash(cmd); t >= 0; t = ioctl_table[t].u.e.next) {
+		if (ioctl_table[t].u.e.cmd == cmd)
 			goto found_handler;
 	}
 
@@ -2836,12 +2841,13 @@
 	goto out_fput;
 
  found_handler:
-	if (ioctl_table[t].handler) {
-		lock_kernel();
-		error = ioctl_table[t].handler(fd, cmd, arg, filp);
-		unlock_kernel();
-		goto out_fput;
-	}
+	lock_kernel();
+	if (ioctl_table[t].u.e.handle)
+		error = ioctl_table[ioctl_table[t].u.e.handle].u.handler(fd, cmd, arg, filp);
+	else
+		error = do_ioctl32_pointer(fd, cmd, arg, filp);
+	unlock_kernel();
+	goto out_fput;
 
  do_ioctl:
 	error = do_vfs_ioctl(filp, fd, cmd, arg);
@@ -2853,23 +2859,38 @@
 
 static int __init init_sys32_ioctl(void)
 {
-	int i;
+	int i, top;
 	unsigned long hash;
 	struct ioctl_trans t;
 
+	/* walk table backward moving handler entries to the end */
+	top = ARRAY_SIZE(ioctl_table) - 1;
+	for (i = top; i >= 0; i--)
+		if (ioctl_table[i].u.e.handle) {
+			/* next entry down is a handler pointer, swap to top */
+			t = ioctl_table[top];
+			ioctl_table[top] = ioctl_table[i - 1];
+			ioctl_table[i - 1] = t;
+			/* fix up handle index for current entry */
+			ioctl_table[i].u.e.handle = top;
+			/* update top and skip next entry */
+			top--;
+			i--;
+		}
+
 	/* hash-order table in-place */
-	for (i = 0; i < ARRAY_SIZE(ioctl_table); i++) {
-		hash = ioctl32_hash(ioctl_table[i].cmd);
+	for (i = 0; i <= top; i++) {
+		hash = ioctl32_hash(ioctl_table[i].u.e.cmd);
 		t = ioctl_table[hash];
 		ioctl_table[hash] = ioctl_table[i];
 		ioctl_table[i] = t;
 	}
 
 	/* link entries outside of hash area */
-	for (i = IOCTL_HASHSIZE; i < ARRAY_SIZE(ioctl_table); i++) {
-		hash = ioctl32_hash(ioctl_table[i].cmd);
-		ioctl_table[i].next = ioctl_table[hash].next;
-		ioctl_table[hash].next = i;
+	for (i = IOCTL_HASHSIZE; i <= top; i++) {
+		hash = ioctl32_hash(ioctl_table[i].u.e.cmd);
+		ioctl_table[i].u.e.next = ioctl_table[hash].u.e.next;
+		ioctl_table[hash].u.e.next = i;
 	}
 	return 0;
 }

-- 
Mathematics is the supreme nostalgia of our time.

