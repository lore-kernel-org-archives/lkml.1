Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZEGMqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZEGMqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbZEGMqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:46:11 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:57516 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbZEGMqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:46:09 -0400
Message-Id: <20090507124557.870734415@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 07 May 2009 14:45:58 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/4] seq_file: add function to write binary data
References: <20090507124556.041286732@linux.vnet.ibm.com>
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

Index: linux-2.6.30-rc4/fs/seq_file.c
===================================================================
--- linux-2.6.30-rc4.orig/fs/seq_file.c
+++ linux-2.6.30-rc4/fs/seq_file.c
@@ -640,6 +640,26 @@ int seq_puts(struct seq_file *m, const c
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
Index: linux-2.6.30-rc4/include/linux/seq_file.h
===================================================================
--- linux-2.6.30-rc4.orig/include/linux/seq_file.h
+++ linux-2.6.30-rc4/include/linux/seq_file.h
@@ -43,6 +43,7 @@ int seq_release(struct inode *, struct f
 int seq_escape(struct seq_file *, const char *, const char *);
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
+int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));


