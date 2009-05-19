Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZESOZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZESOZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZESOZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:25:11 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:46723 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZESOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:25:10 -0400
Message-Id: <20090519142417.897270698@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 19 May 2009 16:24:18 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@Sun.COM>,
       Michael Ellerman <michaele@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/4] seq_file: add function to write binary data
References: <20090519142416.356254359@linux.vnet.ibm.com>
Content-Disposition: inline; filename=seq_file-add-function-to-write-binary-data.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

seq_write() can be used to construct seq_files containing arbitrary
data. Required by the gcov-profiling interface to synthesize binary
profiling data files.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---

 fs/seq_file.c            |   20 ++++++++++++++++++++
 include/linux/seq_file.h |    1 +
 2 files changed, 21 insertions(+)

Index: linux-2.6.30-rc6/fs/seq_file.c
===================================================================
--- linux-2.6.30-rc6.orig/fs/seq_file.c	2009-05-19 12:27:37.000000000 +0200
+++ linux-2.6.30-rc6/fs/seq_file.c	2009-05-19 12:41:26.000000000 +0200
@@ -640,6 +640,26 @@
 }
 EXPORT_SYMBOL(seq_puts);
 
+/**
+ * seq_write - write arbitrary data to buffer
+ * @seq: seq_file identifying the buffer to which data should be written
+ * @data: data address
+ * @len: number of bytes
+ *
+ * Return 0 on success, non-zero otherwise.
+ */
+int seq_write(struct seq_file *seq, const void *data, size_t len)
+{
+	if (seq->count + len < seq->size) {
+		memcpy(seq->buf + seq->count, data, len);
+		seq->count += len;
+		return 0;
+	}
+	seq->count = seq->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_write);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
Index: linux-2.6.30-rc6/include/linux/seq_file.h
===================================================================
--- linux-2.6.30-rc6.orig/include/linux/seq_file.h	2009-05-19 12:27:37.000000000 +0200
+++ linux-2.6.30-rc6/include/linux/seq_file.h	2009-05-19 12:41:26.000000000 +0200
@@ -43,6 +43,7 @@
 int seq_escape(struct seq_file *, const char *, const char *);
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
+int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));


