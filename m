Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbXERKLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbXERKLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXERKLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:11:08 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:28678 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbXERKLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:11:07 -0400
Message-ID: <464D7C97.2050608@sw.ru>
Date: Fri, 18 May 2007 14:14:47 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk, devel@openvz.org
Subject: [PATCH 15/15] Make /proc/self/mounts(tats) use seq_list_xxx helpers
References: <464D6E87.7060605@sw.ru>
In-Reply-To: <464D6E87.7060605@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more simple and stupid switching to the new API.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/fs/namespace.c b/fs/namespace.c
index 11f2fbf..82d4fd2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -393,22 +393,16 @@ EXPORT_SYMBOL(mnt_unpin);
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	struct mnt_namespace *n = m->private;
-	struct list_head *p;
-	loff_t l = *pos;
 
 	down_read(&namespace_sem);
-	list_for_each(p, &n->list)
-		if (!l--)
-			return list_entry(p, struct vfsmount, mnt_list);
-	return NULL;
+	return seq_list_start(&n->list, *pos);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct mnt_namespace *n = m->private;
-	struct list_head *p = ((struct vfsmount *)v)->mnt_list.next;
-	(*pos)++;
-	return p == &n->list ? NULL : list_entry(p, struct vfsmount, mnt_list);
+
+	return seq_list_next(v, &n->list, pos);
 }
 
 static void m_stop(struct seq_file *m, void *v)
@@ -423,7 +417,7 @@ static inline void mangle(struct seq_fil
 
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
-	struct vfsmount *mnt = v;
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
 	int err = 0;
 	static struct proc_fs_info {
 		int flag;
@@ -481,7 +475,7 @@ struct seq_operations mounts_op = {
 
 static int show_vfsstat(struct seq_file *m, void *v)
 {
-	struct vfsmount *mnt = v;
+	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
 	int err = 0;
 
 	/* device */
