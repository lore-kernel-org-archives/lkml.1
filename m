Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZLWVZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZLWVZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZLWVZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:25:06 -0500
Received: from mail.windriver.com ([147.11.1.11]:45312 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547AbZLWVVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Sonic Zhang <sonic.adi@gmail.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 10/37] kgdb: Make mem access function weak in kgdb.c and kgdb.h
Date: Wed, 23 Dec 2009 15:19:23 -0600
Message-Id: <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:08.0926 (UTC) FILETIME=[B4663FE0:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.adi@gmail.com>

L1 instruction memory and MMR memory on blackfin can not be accessed by
common functions probe_kernel_read() and probe_kernel_write().
Blackfin asks for 2/4 byte align access to MMR memory and DMA access to
L1 instruction memory. These functions need to be reimplemented in
architecture specific kgdb.c. Update documentation and prototypes as
well.

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h   |   42 ++++++++++++++++++++++++++++++++++++++++--
 kernel/debug/gdbstub.c |    6 +++---
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 6adcc29..4247950 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -267,8 +267,46 @@ extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 
 extern int kgdb_hex2long(char **ptr, unsigned long *long_val);
-extern int kgdb_mem2hex(char *mem, char *buf, int count);
-extern int kgdb_hex2mem(char *buf, char *mem, int count);
+
+/**
+ *      kgdb_mem2hex - (optional arch override) translate bin to hex chars
+ *      @mem: source buffer
+ *      @buf: target buffer
+ *      @count: number of bytes in mem
+ *
+ *      Architectures which do not support probe_kernel_(read|write),
+ *      can make an alternate implementation of this function.
+ *      This function safely reads memory into hex
+ *      characters for use with the kgdb protocol.
+ */
+extern int __weak kgdb_mem2hex(char *mem, char *buf, int count);
+
+/**
+ *      kgdb_hex2mem - (optional arch override) translate hex chars to bin
+ *      @buf: source buffer
+ *      @mem: target buffer
+ *      @count: number of bytes in mem
+ *
+ *      Architectures which do not support probe_kernel_(read|write),
+ *      can make an alternate implementation of this function.
+ *      This function safely writes hex characters into memory
+ *      for use with the kgdb protocol.
+ */
+extern int __weak kgdb_hex2mem(char *buf, char *mem, int count);
+
+/**
+ *      kgdb_ebin2mem - (optional arch override) Copy the binary array
+ *     pointed to by buf into mem.
+ *      @buf: source buffer
+ *      @mem: target buffer
+ *      @count: number of bytes in mem
+ *
+ *      Architectures which do not support probe_kernel_(read|write),
+ *      can make an alternate implementation of this function.
+ *      This function safely copies binary array into memory
+ *      for use with the kgdb protocol.
+ */
+extern int __weak kgdb_ebin2mem(char *buf, char *mem, int count);
 
 extern int kgdb_isremovedbreak(unsigned long addr);
 
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index ab29bce..bae83cc 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -208,7 +208,7 @@ void gdbstub_msg_write(const char *s, int len)
  * buf.  Return a pointer to the last char put in buf (null). May
  * return an error.
  */
-int kgdb_mem2hex(char *mem, char *buf, int count)
+int __weak kgdb_mem2hex(char *mem, char *buf, int count)
 {
 	char *tmp;
 	int err;
@@ -238,7 +238,7 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
  * mem.  Return a pointer to the character AFTER the last byte
  * written.  May return an error.
  */
-int kgdb_hex2mem(char *buf, char *mem, int count)
+int __weak kgdb_hex2mem(char *buf, char *mem, int count)
 {
 	char *tmp_raw;
 	char *tmp_hex;
@@ -296,7 +296,7 @@ int kgdb_hex2long(char **ptr, unsigned long *long_val)
  * 0x7d escaped with 0x7d.  Return a pointer to the character after
  * the last byte written.
  */
-static int kgdb_ebin2mem(char *buf, char *mem, int count)
+int __weak kgdb_ebin2mem(char *buf, char *mem, int count)
 {
 	int err = 0;
 	char c;
-- 
1.6.4.rc1

