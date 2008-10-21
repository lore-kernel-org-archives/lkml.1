Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYJUTR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYJUTR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYJUTPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:15:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:44731 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbYJUTPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:15:16 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.adi@gmail.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 7/7] kgdb: Make mem access function weak in kgdb.c andkgdb.h
Date: Tue, 21 Oct 2008 14:14:53 -0500
Message-Id: <1224616493-23237-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1224616493-23237-7-git-send-email-jason.wessel@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-2-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-3-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-4-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-5-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-6-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 21 Oct 2008 19:15:01.0904 (UTC) FILETIME=[51109900:01C933B1]
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
 include/linux/kgdb.h |   42 ++++++++++++++++++++++++++++++++++++++++--
 kernel/kgdb.c        |    6 +++---
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 8fdd3cb..3df90af 100644
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
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index d7a30bb..e9e0e8a 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -365,7 +365,7 @@ static void put_packet(char *buffer)
  * Convert the memory pointed to by mem into hex, placing result in buf.
  * Return a pointer to the last char put in buf (null). May return an error.
  */
-int kgdb_mem2hex(char *mem, char *buf, int count)
+int __weak kgdb_mem2hex(char *mem, char *buf, int count)
 {
 	char *tmp;
 	int err;
@@ -395,7 +395,7 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
  * 0x7d escaped with 0x7d.  Return a pointer to the character after
  * the last byte written.
  */
-static int kgdb_ebin2mem(char *buf, char *mem, int count)
+int __weak kgdb_ebin2mem(char *buf, char *mem, int count)
 {
 	int err = 0;
 	char c;
@@ -420,7 +420,7 @@ static int kgdb_ebin2mem(char *buf, char *mem, int count)
  * Return a pointer to the character AFTER the last byte written.
  * May return an error.
  */
-int kgdb_hex2mem(char *buf, char *mem, int count)
+int __weak kgdb_hex2mem(char *buf, char *mem, int count)
 {
 	char *tmp_raw;
 	char *tmp_hex;
-- 
1.6.0.2

