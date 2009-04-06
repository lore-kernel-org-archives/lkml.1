Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbZDFEaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbZDFEaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 00:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZDFEaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 00:30:07 -0400
Received: from ozlabs.org ([203.10.76.45]:41088 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbZDFEaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 00:30:06 -0400
To: <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, <gnb@sgi.com>, <jbaron@redhat.com>
Message-Id: <4a5c6b4cd1b77ebe6d60362bc982f4dc81cba85e.1238992196.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Resurrect old pr_debug() semantics as pr_devel()
Date: Mon,  6 Apr 2009 14:30:03 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_debug() used to produce zero code unless DEBUG was #defined. This is
now no longer the case in practice[1].

There are places where it's useful to have debugging printks, but we
don't want them to generate any code in production kernels.

So add a new macro, pr_devel(), for _devel_opment, to provide the old
semantics, ie. if the programmer doesn't explicitly enable debugging,
no code is produced.

[1]: You can turn CONFIG_DYNAMIC_DEBUG off, but it's enabled in at least
     one distro kernel, so it's not really a solution.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 include/linux/kernel.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d9e75ec..883cd44 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -377,6 +377,15 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
+/* pr_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define pr_devel(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_devel(fmt, ...) \
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
+#endif
+
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
 #define pr_debug(fmt, ...) \
-- 
1.6.1.2

