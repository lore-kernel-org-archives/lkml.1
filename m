Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbYJLJct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbYJLJct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYJLJbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:31:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56651 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYJLJbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:31:45 -0400
Message-ID: <48F1C36D.6080301@cn.fujitsu.com>
Date: Sun, 12 Oct 2008 17:29:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] seq_file: don't call bitmap_scnprintf_len()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"m->count + len < m->size" is true commonly, so bitmap_scnprintf()
is commonly called. this fix saves a call to bitmap_scnprintf_len().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/fs/seq_file.c b/fs/seq_file.c
index bd20f7f..11c85fe 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -452,17 +452,18 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
 
 int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
 {
-	size_t len = bitmap_scnprintf_len(nr_bits);
-
-	if (m->count + len < m->size) {
-		bitmap_scnprintf(m->buf + m->count, m->size - m->count,
-				 bits, nr_bits);
-		m->count += len;
-		return 0;
+	if (m->count < m->size) {
+		int len = bitmap_scnprintf(m->buf + m->count,
+				m->size - m->count, bits, nr_bits);
+		if (m->count + len < m->size) {
+			m->count += len;
+			return 0;
+		}
 	}
 	m->count = m->size;
 	return -1;
 }
+EXPORT_SYMBOL(seq_bitmap);
 
 static void *single_start(struct seq_file *p, loff_t *pos)
 {



