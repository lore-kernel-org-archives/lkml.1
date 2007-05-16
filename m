Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbXEPIHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbXEPIHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXEPIHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:07:40 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:37955 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbXEPIHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:07:38 -0400
Date: Wed, 16 May 2007 10:06:01 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 11/14] VFS whiteout handling
In-Reply-To: <20070514094358.GM4139@in.ibm.com>
Message-ID: <Pine.LNX.4.61.0705160957540.9570@yvahk01.tjqt.qr>
References: <20070514093722.GB4139@in.ibm.com> <20070514094358.GM4139@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 15:13, Bharata B Rao wrote:
> 
>+/*
>+ * Dummy default file-operations:
>+ * Never open a whiteout. This is always a bug.
>+ */
>+static int whiteout_no_open(struct inode *irrelevant, struct file *dontcare)
>+{
>+	printk("Attemp to open a whiteout!\n");
>+	WARN_ON(1);
>+	return -ENXIO;
>+}

Eww, really WARN_ON? ENXIO should be enough.
(FWIW, spello fix -> "Attempted to open a whiteout")

>+static int
>+vfs_unlink_whiteout(struct inode *dir, struct dentry **dp)

One line.

>+static int
>+__hash_one_len(const char *name, int len, struct qstr *this)
>+{
>+	unsigned long hash;
>+	unsigned int c;

I doubt it will make a difference - "unsigned char c";

>+
>+	hash = init_name_hash();
>+	while (len--) {
>+		c = *(const unsigned char *)name++;
>+		if (c == '/' || c == '\0')
>+			return -EINVAL;
>+		hash = partial_name_hash(c, hash);
>+	}
>+	this->hash = end_name_hash(hash);
>+	return 0;
>+}
>+
>+static int do_unlink_whiteouts(struct dentry *dentry)
>+{
>[...]
>+	if (!IS_DEADDIR(inode)) {
>+		res = file->f_op->readdir(file, (void *)file->f_path.dentry,
>+					  unlink_whiteouts_filldir);

I think this cast can go.

>--- a/fs/readdir.c
>+++ b/fs/readdir.c
>@@ -148,6 +148,11 @@ static int filldir(void * __buf, const c
> 	unsigned long d_ino;
> 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 2, sizeof(long));
> 
>+#ifdef CONFIG_UNION_MOUNT
>+	if (d_type == DT_WHT)
>+		return 0;
>+#endif /* CONFIG_UNION_MOUNT */
>+

DT_WHT is always available, is not it? In that case, would not it
be simpler to get rid of the #if/#endif.

>@@ -233,6 +238,11 @@ static int filldir64(void * __buf, const
> 	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
> 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(u64));
> 
>+#ifdef CONFIG_UNION_MOUNT
>+	if (d_type == DT_WHT)
>+		return 0;
>+#endif /* CONFIG_UNION_MOUNT */
>+
> 	buf->error = -EINVAL;	/* only used if we fail.. */
> 	if (reclen > buf->count)
> 		return -EINVAL;

>--- a/fs/union.c
>+++ b/fs/union.c
> 
> #define attach_mnt_union(mnt,nd) do { /* empty */ } while (0)
>@@ -54,6 +58,8 @@ extern int union_relookup_topmost(struct
> #define union_copy_file(dentry1,mnt1,dentry2,mnt2) ({ (0); })
> #define union_copyup(x,y) ({ (0); })
> #define union_relookup_topmost(x,y) ({ (0); })
>+#define union_dir_is_empty(x) ({ (1); })
>+#define present_in_lower(x, y)	({ (0); })

These could just be
  #define something  0


	Jan
-- 
