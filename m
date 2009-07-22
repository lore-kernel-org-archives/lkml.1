Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZGVKMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZGVKMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZGVKMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:12:00 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:57001 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbZGVKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:10:54 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Dan Smith <danms@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v17][PATCH 54/60] c/r: add CKPT_COPY() macro
Date: Wed, 22 Jul 2009 06:00:16 -0400
Message-Id: <1248256822-23416-55-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248256822-23416-1-git-send-email-orenl@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Smith <danms@us.ibm.com>

As suggested by Dave[1], this provides us a way to make the copy-in and
copy-out processes symmetric.  CKPT_COPY_ARRAY() provides us a way to do
the same thing but for arrays.  It's not critical, but it helps us unify
the checkpoint and restart paths for some things.

Changelog:
    Mar 04:
            . Removed semicolons
            . Added build-time check for __must_be_array in CKPT_COPY_ARRAY
    Feb 27:
            . Changed CKPT_COPY() to use assignment, eliminating the need
              for the CKPT_COPY_BIT() macro
            . Add CKPT_COPY_ARRAY() macro to help copying register arrays,
              etc
            . Move the macro definitions inside the CR #ifdef
    Feb 25:
            . Changed WARN_ON() to BUILD_BUG_ON()

Signed-off-by: Dan Smith <danms@us.ibm.com>
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>

1: https://lists.linux-foundation.org/pipermail/containers/2009-February/015821.html (all the way at the bottom)
---
 include/linux/checkpoint.h |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index aeae2fa..2ee1bc2 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -211,6 +211,34 @@ extern int restore_memory_contents(struct ckpt_ctx *ctx, struct inode *inode);
 	 VM_MAPPED_COPY | VM_INSERTPAGE | VM_MIXEDMAP | VM_SAO)
 
 
+/* useful macros to copy fields and buffers to/from ckpt_hdr_xxx structures */
+#define CKPT_CPT 1
+#define CKPT_RST 2
+
+#define CKPT_COPY(op, SAVE, LIVE)				        \
+	do {							\
+		if (op == CKPT_CPT)				\
+			SAVE = LIVE;				\
+		else						\
+			LIVE = SAVE;				\
+	} while (0)
+
+/*
+ * Copy @count items from @LIVE to @SAVE if op is CKPT_CPT (otherwise,
+ * copy in the reverse direction)
+ */
+#define CKPT_COPY_ARRAY(op, SAVE, LIVE, count)				\
+	do {								\
+		(void)__must_be_array(SAVE);				\
+		(void)__must_be_array(LIVE);				\
+		BUILD_BUG_ON(sizeof(*SAVE) != sizeof(*LIVE));		\
+		if (op == CKPT_CPT)					\
+			memcpy(SAVE, LIVE, count * sizeof(*SAVE));	\
+		else							\
+			memcpy(LIVE, SAVE, count * sizeof(*SAVE));	\
+	} while (0)
+
+
 /* debugging flags */
 #define CKPT_DBASE	0x1		/* anything */
 #define CKPT_DSYS	0x2		/* generic (system) */
@@ -243,6 +271,7 @@ extern unsigned long ckpt_debug_level;
  * CKPT_DBASE is the base flags, doesn't change
  * CKPT_DFLAG is to be redfined in each source file
  */
+
 #define ckpt_debug(fmt, args...)  \
 	_ckpt_debug(CKPT_DBASE | CKPT_DFLAG, fmt, ## args)
 
-- 
1.6.0.4

