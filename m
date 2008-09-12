Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYILFo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYILFo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 01:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYILFoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 01:44:21 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:46906 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYILFoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 01:44:20 -0400
X-IronPort-AV: E=Sophos;i="4.32,386,1217822400"; 
   d="scan'208";a="74991931"
Subject: [PATCH][kgdb][v2] Make mem access function weak in kgdb.c and
	kgdb.h
From: sonic zhang <sonic.adi@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       kgdb mailing list <kgdb-bugreport@lists.sourceforge.net>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 13:39:16 +0800
Message-Id: <1221197956.15380.6.camel@eight.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L1 instruction memory and MMR memory on blackfin can not be accessed by
common functions probe_kernel_read() and probe_kernel_write().
Blackfin asks for 2/4 byte align access to MMR memory and DMA access to L1
instruction memory. These functions need to be reimplemented in
architecture specific kgdb.c. Update documentation and prototypes as well.

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
---
 include/linux/kgdb.h |   42 ++++++++++++++++++++++++++++++++++++++++--
 kernel/kgdb.c        |    6 +++---
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 8fdd3cb..cb8a3d6 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -267,8 +267,46 @@ extern int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 extern void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 
 extern int kgdb_hex2long(char **ptr, unsigned long *long_val);
-extern int kgdb_mem2hex(char *mem, char *buf, int count);
-extern int kgdb_hex2mem(char *buf, char *mem, int count);
+
+/**
+ *      kgdb_mem2hex - (optional arch overide) traslate bin to hex chars
+ *      @mem: source buffer
+ *      @buf: target buffer
+ *      @count: number of bytes in mem
+ *
+ *      Archictures which do not support probe_kernel_(read|write),
+ *      can make an alternate implmentation of this function.
+ *      This function safely reads memory into hex
+ *      characters for use with the kgdb protocol.
+ */
+extern int __weak kgdb_mem2hex(char *mem, char *buf, int count);
+
+/**
+ *      kgdb_hex2mem - (optional arch overide) traslate hex chars to bin
+ *      @buf: source buffer
+ *      @mem: target buffer
+ *      @count: number of bytes in mem
+ *
+ *      Archictures which do not support probe_kernel_(read|write),
+ *      can make an alternate implmentation of this function.
+ *      This function safely writes hex characters into memory
+ *      for use with the kgdb protocol.
+ */
+extern int __weak kgdb_hex2mem(char *buf, char *mem, int count);
+
+/**
+ *      kgdb_ebin2mem - (optional arch overide) Copy the binary array
+ *	pointed to by buf into mem.
+ *      @buf: source buffer
+ *      @mem: target buffer
+ *      @count: number of bytes in mem
+ *
+ *      Archictures which do not support probe_kernel_(read|write),
+ *      can make an alternate implmentation of this function.
+ *      This function safely copys binary array into memory
+ *      for use with the kgdb protocol.
+ */
+extern int __weak kgdb_ebin2mem(char *buf, char *mem, int count);
 
 extern int kgdb_isremovedbreak(unsigned long addr);
 
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index c803730..aae578e 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -364,7 +364,7 @@ static void put_packet(char *buffer)
  * Convert the memory pointed to by mem into hex, placing result in buf.
  * Return a pointer to the last char put in buf (null). May return an error.
  */
-int kgdb_mem2hex(char *mem, char *buf, int count)
+int __weak kgdb_mem2hex(char *mem, char *buf, int count)
 {
 	char *tmp;
 	int err;
@@ -394,7 +394,7 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
  * 0x7d escaped with 0x7d.  Return a pointer to the character after
  * the last byte written.
  */
-static int kgdb_ebin2mem(char *buf, char *mem, int count)
+int __weak kgdb_ebin2mem(char *buf, char *mem, int count)
 {
 	int err = 0;
 	char c;
@@ -419,7 +419,7 @@ static int kgdb_ebin2mem(char *buf, char *mem, int count)
  * Return a pointer to the character AFTER the last byte written.
  * May return an error.
  */
-int kgdb_hex2mem(char *buf, char *mem, int count)
+int __weak kgdb_hex2mem(char *buf, char *mem, int count)
 {
 	char *tmp_raw;
 	char *tmp_hex;
-- 
1.6.0


