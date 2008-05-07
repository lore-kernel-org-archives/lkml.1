Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbYEGVgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbYEGVgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYEGVgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:36:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:57573 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbYEGVgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=I/d32G0DKqw4W9Vg4ZsZIKcs9iHESmiVMdej0teSr3hKQHZuep/tPNIcTjguS0kRg3hYAgcfaVmQbTnrAPcuyegMe7HjQq210NLd2HCUuL/hPK1NaAS+IYrgYL/UOh18w+FSfynZk0lIAds3/pRsFmd3NqxYt88zoXEi6zpSu/0=
Date: Thu, 8 May 2008 02:31:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH 3/5] Add and use seq_bitmap, seq_cpumask, seq_nodemask
Message-ID: <20080507223135.GC14375@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpuset proc code is directly playing with seq_file internals, for that add
seq_bitmap() and wrappers around it: seq_cpumask() and seq_nodemask(). They
use NR_CPUS and MAX_NUMNODES bits respectively.

Also they will be used by code /proc/irq/*/{smp_affinity,spurious} code.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/seq_file.c            |   15 +++++++++++++++
 include/linux/seq_file.h |   12 ++++++++++++
 kernel/cpuset.c          |   12 ++++--------
 3 files changed, 31 insertions(+), 8 deletions(-)

--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -554,6 +554,21 @@ int seq_puts(struct seq_file *m, const char *s)
 }
 EXPORT_SYMBOL(seq_puts);
 
+int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits)
+{
+	size_t len = bitmap_scnprintf_len(nr_bits);
+
+	if (m->count + len < m->size) {
+		bitmap_scnprintf(m->buf + m->count, m->size - m->count,
+				 bits, nr_bits);
+		m->count += len;
+		return 0;
+	}
+	m->count = m->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_bitmap);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -4,6 +4,8 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
+#include <linux/cpumask.h>
+#include <linux/nodemask.h>
 
 struct seq_operations;
 struct file;
@@ -47,6 +49,16 @@ int seq_path(struct seq_file *, struct path *, char *);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc);
+int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits);
+static inline int seq_cpumask(struct seq_file *m, cpumask_t *mask)
+{
+	return seq_bitmap(m, mask->bits, NR_CPUS);
+}
+
+static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
+{
+	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
+}
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);

