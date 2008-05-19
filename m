Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYESIox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYESIox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYESIoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:44:12 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:30142 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758525AbYESIoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:44:11 -0400
Message-ID: <48313DD8.5020103@de.ibm.com>
Date: Mon, 19 May 2008 10:44:08 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: [PATCH 4/7] seq_file: add function to write binary data
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

seq_write() can be used to construct seq_files containing arbitrary
data. Required by the gcov-profiling interface to synthesize binary
profiling data files.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 fs/seq_file.c            |   20 ++++++++++++++++++++
 include/linux/seq_file.h |    1 +
 2 files changed, 21 insertions(+)

Index: linux-2.6.26-rc3/fs/seq_file.c
===================================================================
--- linux-2.6.26-rc3.orig/fs/seq_file.c
+++ linux-2.6.26-rc3/fs/seq_file.c
@@ -554,6 +554,26 @@ int seq_puts(struct seq_file *m, const c
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
Index: linux-2.6.26-rc3/include/linux/seq_file.h
===================================================================
--- linux-2.6.26-rc3.orig/include/linux/seq_file.h
+++ linux-2.6.26-rc3/include/linux/seq_file.h
@@ -39,6 +39,7 @@ int seq_release(struct inode *, struct f
 int seq_escape(struct seq_file *, const char *, const char *);
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
+int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));




