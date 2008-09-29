Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYI2X3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYI2X3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYI2X3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:29:43 -0400
Received: from waste.org ([66.93.16.53]:51413 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYI2X3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:29:42 -0400
Subject: [RFC PATCH 1/2] Shrink compat_ioctl.c
From: Matt Mackall <mpm@selenic.com>
To: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 18:27:10 -0500
Message-Id: <1222730830.23159.12.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm throwing this out untested as I don't have a mixed 64/32 system
handy at the moment.

compat_ioctl: shrink structures

Initially, compat_ioctl.c has a ~18k table of translated ioctls.
Each table entry is 24 bytes but we can shrink this to 16:

- use short table indexes rather than a pointer for .next values
- use unsigned ints for cmd numbers (they're 32-bit ioctls, after all)

In addition, there's a 2k hash table that we can do away with simply
by hashifying the main table in place at init time.

This saves about 6k data and 2k BSS.

diff -r f6d1daaf90b2 -r b055e64aea17 fs/compat_ioctl.c
--- a/fs/compat_ioctl.c	Mon Sep 29 17:28:28 2008 -0500
+++ b/fs/compat_ioctl.c	Mon Sep 29 17:28:41 2008 -0500
@@ -1825,21 +1825,21 @@
 					unsigned long, struct file *);
 
 struct ioctl_trans {
-	unsigned long cmd;
 	ioctl_trans_handler_t handler;
-	struct ioctl_trans *next;
+	unsigned int cmd;
+	unsigned short next;
 };
 
 #define HANDLE_IOCTL(cmd,handler) \
-	{ (cmd), (ioctl_trans_handler_t)(handler) },
+	{ (ioctl_trans_handler_t)(handler), (cmd)},
 
 /* pointer to compatible structure or no argument */
 #define COMPATIBLE_IOCTL(cmd) \
-	{ (cmd), do_ioctl32_pointer },
+	{ do_ioctl32_pointer, (cmd) },
 
 /* argument is an unsigned long integer, not a pointer */
 #define ULONG_IOCTL(cmd) \
-	{ (cmd), (ioctl_trans_handler_t)sys_ioctl },
+	{ (ioctl_trans_handler_t)sys_ioctl, (cmd) },
 
 /* ioctl should not be warned about even if it's not implemented.
    Valid reasons to use this:
@@ -1850,7 +1850,7 @@
    Most other reasons are not valid. */
 #define IGNORE_IOCTL(cmd) COMPATIBLE_IOCTL(cmd)
 
-static struct ioctl_trans ioctl_start[] = {
+static struct ioctl_trans ioctl_table[] = {
 /* compatible ioctls first */
 COMPATIBLE_IOCTL(0x4B50)   /* KDGHWCLK - not in the kernel, but don't complain */
 COMPATIBLE_IOCTL(0x4B51)   /* KDSHWCLK - not in the kernel, but don't complain */
@@ -2728,10 +2728,9 @@
 #endif
 };
 
-#define IOCTL_HASHSIZE 256
-static struct ioctl_trans *ioctl32_hash_table[IOCTL_HASHSIZE];
+#define IOCTL_HASHSIZE 256 /* must be less than table size */
 
-static inline unsigned long ioctl32_hash(unsigned long cmd)
+static inline unsigned int ioctl32_hash(unsigned int cmd)
 {
 	return (((cmd >> 6) ^ (cmd >> 4) ^ cmd)) % IOCTL_HASHSIZE;
 }
@@ -2770,7 +2769,7 @@
 {
 	struct file *filp;
 	int error = -EBADF;
-	struct ioctl_trans *t;
+	int t;
 	int fput_needed;
 
 	filp = fget_light(fd, &fput_needed);
@@ -2815,8 +2814,8 @@
 		break;
 	}
 
-	for (t = ioctl32_hash_table[ioctl32_hash(cmd)]; t; t = t->next) {
-		if (t->cmd == cmd)
+	for (t = ioctl32_hash(cmd); t >= 0; t = ioctl_table[t].next) {
+		if (ioctl_table[t].cmd == cmd)
 			goto found_handler;
 	}
 
@@ -2837,9 +2836,9 @@
 	goto out_fput;
 
  found_handler:
-	if (t->handler) {
+	if (ioctl_table[t].handler) {
 		lock_kernel();
-		error = t->handler(fd, cmd, arg, filp);
+		error = ioctl_table[t].handler(fd, cmd, arg, filp);
 		unlock_kernel();
 		goto out_fput;
 	}
@@ -2852,34 +2851,25 @@
 	return error;
 }
 
-static void ioctl32_insert_translation(struct ioctl_trans *trans)
-{
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
-}
-
 static int __init init_sys32_ioctl(void)
 {
 	int i;
+	unsigned long hash;
+	struct ioctl_trans t;
 
-	for (i = 0; i < ARRAY_SIZE(ioctl_start); i++) {
-		if (ioctl_start[i].next) {
-			printk("ioctl translation %d bad\n",i);
-			return -1;
-		}
+	/* hash-order table in-place */
+	for (i = 0; i < ARRAY_SIZE(ioctl_table); i++) {
+		hash = ioctl32_hash(ioctl_table[i].cmd);
+		t = ioctl_table[hash];
+		ioctl_table[hash] = ioctl_table[i];
+		ioctl_table[i] = t;
+	}
 
-		ioctl32_insert_translation(&ioctl_start[i]);
+	/* link entries outside of hash area */
+	for (i = IOCTL_HASHSIZE; i < ARRAY_SIZE(ioctl_table); i++) {
+		hash = ioctl32_hash(ioctl_table[i].cmd);
+		ioctl_table[i].next = ioctl_table[hash].next;
+		ioctl_table[hash].next = i;
 	}
 	return 0;
 }


-- 
Mathematics is the supreme nostalgia of our time.

