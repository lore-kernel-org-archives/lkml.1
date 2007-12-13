Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbXLMNOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbXLMNOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXLMNOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:14:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbXLMNOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:14:09 -0500
Date: Thu, 13 Dec 2007 14:12:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071213131242.GD28340@elte.hu>
References: <20071211182528.GA5597@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071212134158.GA5547@linux.vnet.ibm.com> <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071213114336.GA5400@linux.vnet.ibm.com> <20071213125509.GA28340@elte.hu> <20071213130231.GB16905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213130231.GB16905@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> > >  static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
> > >  {
> > > +	sa->attr.owner = NULL;
> > >  	sa->attr.name = name;
> > 
> > i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs 
> > initialize the owner field to NULL automatically?
> > 
> 
> Going through git log, it seems that commit 
> 7b595756ec1f49e0049a9e01a1298d53a7faaa15 deemed attribute->owner as 
> unnecessary. I guess that answers the question.

thx. The only open question seems to be: Vincent had sysfs crashes 
without the CFS patchset as well.

Wouldnt it be prudent to backport the core bits of the above commit 
(attached below), to make sure the owner field is never utilized. 
(because it seems it's so easy and common to not maintain it properly) 

Vincent, does the patch below resolve the non-CFS crashes?

	Ingo

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 618b8ae..3c5574a 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -175,25 +175,20 @@ static int open(struct inode * inode, struct file * file)
 	if (!sysfs_get_active(attr_sd))
 		return -ENODEV;
 
-	/* Grab the module reference for this attribute */
-	error = -ENODEV;
-	if (!try_module_get(attr->attr.owner))
-		goto err_sput;
-
 	error = -EACCES;
 	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
-		goto err_mput;
+		goto err_out;
 	if ((file->f_mode & FMODE_READ) && !(attr->read || attr->mmap))
-		goto err_mput;
+		goto err_out;
 
 	error = -ENOMEM;
 	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
 	if (!bb)
-		goto err_mput;
+		goto err_out;
 
 	bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!bb->buffer)
-		goto err_mput;
+		goto err_out;
 
 	mutex_init(&bb->mutex);
 	file->private_data = bb;
@@ -203,9 +198,7 @@ static int open(struct inode * inode, struct file * file)
 	sysfs_get(attr_sd);
 	return 0;
 
- err_mput:
-	module_put(attr->attr.owner);
- err_sput:
+ err_out:
 	sysfs_put_active(attr_sd);
 	kfree(bb);
 	return error;
@@ -214,13 +207,11 @@ static int open(struct inode * inode, struct file * file)
 static int release(struct inode * inode, struct file * file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
 	struct bin_buffer *bb = file->private_data;
 
 	if (bb->mmapped)
 		sysfs_put_active_two(attr_sd);
 	sysfs_put(attr_sd);
-	module_put(attr->attr.owner);
 	kfree(bb->buffer);
 	kfree(bb);
 	return 0;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index d673d9b..a84b734 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -241,7 +241,6 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
@@ -251,11 +250,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
-	/* Grab the module reference for this attribute */
-	error = -ENODEV;
-	if (!try_module_get(attr->owner))
-		goto err_sput;
-
 	/* if the kobject has no ktype, then we assume that it is a subsystem
 	 * itself, and use ops for it.
 	 */
@@ -272,7 +266,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 * or the subsystem have no operations.
 	 */
 	if (!ops)
-		goto err_mput;
+		goto err_out;
 
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
@@ -280,7 +274,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 */
 	if (file->f_mode & FMODE_WRITE) {
 		if (!(inode->i_mode & S_IWUGO) || !ops->store)
-			goto err_mput;
+			goto err_out;
 	}
 
 	/* File needs read support.
@@ -289,7 +283,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 */
 	if (file->f_mode & FMODE_READ) {
 		if (!(inode->i_mode & S_IRUGO) || !ops->show)
-			goto err_mput;
+			goto err_out;
 	}
 
 	/* No error? Great, allocate a buffer for the file, and store it
@@ -298,7 +292,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	error = -ENOMEM;
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
 	if (!buffer)
-		goto err_mput;
+		goto err_out;
 
 	init_MUTEX(&buffer->sem);
 	buffer->needs_read_fill = 1;
@@ -310,9 +304,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	sysfs_get(attr_sd);
 	return 0;
 
- err_mput:
-	module_put(attr->owner);
- err_sput:
+ err_out:
 	sysfs_put_active_two(attr_sd);
 	return error;
 }
@@ -320,12 +312,9 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 static int sysfs_release(struct inode * inode, struct file * filp)
 {
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct sysfs_buffer *buffer = filp->private_data;
 
 	sysfs_put(attr_sd);
-	/* After this point, attr should not be accessed. */
-	module_put(attr->owner);
 
 	if (buffer) {
 		if (buffer->page)

