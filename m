Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbZBZNwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbZBZNwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZBZNwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:52:05 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:46840 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbZBZNv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:51:59 -0500
Message-ID: <49A69E67.9090601@linux.vnet.ibm.com>
Date: Thu, 26 Feb 2009 14:51:35 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/4] seq_file: add function to write binary data
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

seq_write() can be used to construct seq_files containing arbitrary
data. Required by the gcov-profiling interface to synthesize binary
profiling data files.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---

 fs/seq_file.c            |   20 ++++++++++++++++++++
 include/linux/seq_file.h |    1 +
 2 files changed, 21 insertions(+)

Index: linux-2.6.29-rc6/fs/seq_file.c
===================================================================
--- linux-2.6.29-rc6.orig/fs/seq_file.c
+++ linux-2.6.29-rc6/fs/seq_file.c
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
Index: linux-2.6.29-rc6/include/linux/seq_file.h
===================================================================
--- linux-2.6.29-rc6.orig/include/linux/seq_file.h
+++ linux-2.6.29-rc6/include/linux/seq_file.h
@@ -43,6 +43,7 @@ int seq_release(struct inode *, struct f
 int seq_escape(struct seq_file *, const char *, const char *);
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
+int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));


