Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYDDU5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYDDU5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYDDU5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:57:35 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:36045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYDDU5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:57:34 -0400
Subject: Re: debugfs_remove() vs. anything that is dynamic
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080404202006.GB14016@kroah.com>
References: <1207266986.19189.14.camel@johannes.berg>
	 <20080404153402.GB16923@kroah.com>
	 <1207323684.19189.54.camel@johannes.berg>
	 <20080404202006.GB14016@kroah.com>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 22:57:24 +0200
Message-Id: <1207342644.3625.4.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-04 at 13:20 -0700, Greg KH wrote:

> Then use the debugfs_create_file() function instead of the individual
> variable ones if this is the issue.  You can easily wrap them up much
> like the debugfs core does with the common wrappers to allow for the
> proper module lifetime rules to be followed.

Yeah, I was actually looking into this whole thing because I thought
that mac80211's debugfs code is too large (at about a quarter of the
binary size of the whole thing), so I'm not keen on adding more code, I
was rather wondering if it would be possible to remove a lot of the code
in favour of using simple attributes :)

> > we could NULL out that pointer on debugfs_remove() and have
> > simple_attr_read() just return -ENOENT.
> 
> Patches are always gladly accepted :)
> 
> > However, if nobody else is concerned about this, I'll just remove all
> > the wireless debugfs code instead, I just don't want to allow crashing
> > it that way.
> 
> I think you should be able to handle this in your debugfs calls, or if
> needed, we can easily add a new parameter to them to handle the module
> ownership if you are concerned about them.

No, I'm not particularly concerned about module ownership, I'm more
concerned about any dynamic objects.

This patch seems to work. My system boots (so sysfs definitely works)
and my debugfs test case returns -ENOENT on the read, even if the file
was opened previously.

I think, however, it's not correct when you have a hard-link, and the
NULLing out of i_private must be done depending on (inode->i_nlink == 1)
instead of unconditionally. I will have to test that once I figure out
if (and if yes, how) you can even create inodes with nlink>1 with simple
attributes.

--- everything.orig/fs/libfs.c	2008-04-04 22:37:18.000000000 +0200
+++ everything/fs/libfs.c	2008-04-04 22:37:37.000000000 +0200
@@ -287,6 +287,7 @@ int simple_unlink(struct inode *dir, str
 {
 	struct inode *inode = dentry->d_inode;
 
+	inode->i_private = NULL;
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	drop_nlink(inode);
 	dput(dentry);
@@ -587,7 +588,7 @@ struct simple_attr {
 	int (*set)(void *, u64);
 	char get_buf[24];	/* enough to store a u64 and "\n\0" */
 	char set_buf[24];
-	void *data;
+	void **dataptr;
 	const char *fmt;	/* format for read operation */
 	struct mutex mutex;	/* protects access to these buffers */
 };
@@ -606,7 +607,7 @@ int simple_attr_open(struct inode *inode
 
 	attr->get = get;
 	attr->set = set;
-	attr->data = inode->i_private;
+	attr->dataptr = &inode->i_private;
 	attr->fmt = fmt;
 	mutex_init(&attr->mutex);
 
@@ -642,9 +643,17 @@ ssize_t simple_attr_read(struct file *fi
 		size = strlen(attr->get_buf);
 	} else {		/* first read */
 		u64 val;
-		ret = attr->get(attr->data, &val);
-		if (ret)
+		void *data;
+
+		data = *attr->dataptr;
+		if (!data) {
+			ret = -ENOENT;
 			goto out;
+		} else {
+			ret = attr->get(data, &val);
+			if (ret)
+				goto out;
+		}
 
 		size = scnprintf(attr->get_buf, sizeof(attr->get_buf),
 				 attr->fmt, (unsigned long long)val);
@@ -664,6 +673,7 @@ ssize_t simple_attr_write(struct file *f
 	u64 val;
 	size_t size;
 	ssize_t ret;
+	void *data;
 
 	attr = file->private_data;
 	if (!attr->set)
@@ -678,10 +688,15 @@ ssize_t simple_attr_write(struct file *f
 	if (copy_from_user(attr->set_buf, buf, size))
 		goto out;
 
-	ret = len; /* claim we got the whole input */
-	attr->set_buf[size] = '\0';
-	val = simple_strtol(attr->set_buf, NULL, 0);
-	attr->set(attr->data, val);
+	data = *attr->dataptr;
+	if (!data) {
+		ret = -ENOENT;
+	} else {
+		ret = len; /* claim we got the whole input */
+		attr->set_buf[size] = '\0';
+		val = simple_strtol(attr->set_buf, NULL, 0);
+		attr->set(data, val);
+	}
 out:
 	mutex_unlock(&attr->mutex);
 	return ret;


