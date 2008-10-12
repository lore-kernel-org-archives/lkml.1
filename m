Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYJLJbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYJLJbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYJLJbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:31:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65282 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYJLJbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:31:44 -0400
Message-ID: <48F1C375.5020105@cn.fujitsu.com>
Date: Sun, 12 Oct 2008 17:29:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] seq_file: Add seq_cpumask_list(), seq_nodemask_list()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


seq_cpumask_list(), seq_nodemask_list() are very like seq_cpumask(),
seq_nodemask(), but they print human readable string.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 11c85fe..eba2eab 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -465,6 +465,22 @@ int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
 }
 EXPORT_SYMBOL(seq_bitmap);
 
+int seq_bitmap_list(struct seq_file *m, unsigned long *bits,
+		unsigned int nr_bits)
+{
+	if (m->count < m->size) {
+		int len = bitmap_scnlistprintf(m->buf + m->count,
+				m->size - m->count, bits, nr_bits);
+		if (m->count + len < m->size) {
+			m->count += len;
+			return 0;
+		}
+	}
+	m->count = m->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_bitmap_list);
+
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index a1783b2..dc50bcc 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -60,6 +60,19 @@ static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
 	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
 }
 
+int seq_bitmap_list(struct seq_file *m, unsigned long *bits,
+		unsigned int nr_bits);
+
+static inline int seq_cpumask_list(struct seq_file *m, cpumask_t *mask)
+{
+	return seq_bitmap_list(m, mask->bits, NR_CPUS);
+}
+
+static inline int seq_nodemask_list(struct seq_file *m, nodemask_t *mask)
+{
+	return seq_bitmap_list(m, mask->bits, MAX_NUMNODES);
+}
+
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);
 void *__seq_open_private(struct file *, const struct seq_operations *, int);


