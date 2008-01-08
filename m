Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYAHJm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYAHJm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYAHJmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:42:51 -0500
Received: from po-out-1718.google.com ([72.14.252.152]:44487 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYAHJmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=ci2CPgdDC6MDpp9zVyJ/3pM6sod3MsvMZ3EASQ6IFPKeSTo39URRRyhQOkhZmfS/Y1tnVRgIVVZEljUSBPO0sC6plSdGSMqnVyP/MWMibfikPVNjUN53FefofpoShNgsoMbLJ9m0KB3UxLQSty9nPy26mmRbcxnH3tBwYzqbweU=
Message-ID: <47834593.1000506@gmail.com>
Date: Tue, 08 Jan 2008 18:42:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Gabor Gombas <gombasg@sztaki.hu>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <20080107141300.GB12763@boogie.lpds.sztaki.hu> <47824415.80703@gmail.com> <20080107210024.GA13537@boogie.lpds.sztaki.hu>
In-Reply-To: <20080107210024.GA13537@boogie.lpds.sztaki.hu>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------010600060907090706030500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010600060907090706030500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Gabor Gombas wrote:
> On Tue, Jan 08, 2008 at 12:24:05AM +0900, Tejun Heo wrote:
> 
>> Does the attached patch fix the problem?
> 
> No, it still oopses.

Thanks.  Please apply the attached patch and report the oops.

-- 
tejun

--------------010600060907090706030500
Content-Type: text/x-patch;
 name="debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug.patch"

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
diff --git a/fs/dcache.c b/fs/dcache.c
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 3371629..f5ec27e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -96,7 +96,7 @@ static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
  *	RETURNS:
  *	Pointer to found dentry on success, ERR_PTR() value on error.
  */
-struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
+static struct dentry *__sysfs_get_dentry(struct sysfs_dirent *sd, int dbg)
 {
 	struct dentry *dentry = dget(sysfs_sb->s_root);
 
@@ -111,6 +111,8 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 
 		/* look it up */
 		parent = dentry;
+		printk("XXX: looking up %s (%p) / %s\n",
+		       parent->d_name.name, parent->d_inode, cur->s_name);
 		mutex_lock(&parent->d_inode->i_mutex);
 		dentry = lookup_one_noperm(cur->s_name, parent);
 		mutex_unlock(&parent->d_inode->i_mutex);
@@ -122,6 +124,11 @@ struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
 	return dentry;
 }
 
+struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd)
+{
+	return __sysfs_get_dentry(sd, 0);
+}
+
 /**
  *	sysfs_get_active - get an active reference to sysfs_dirent
  *	@sd: sysfs_dirent to get an active reference to
@@ -838,6 +845,14 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 
 	mutex_lock(&sysfs_rename_mutex);
 	BUG_ON(!sd->s_parent);
+	{
+		char *s = kobject_get_path(kobj, GFP_KERNEL);
+		char *p = kobject_get_path(new_parent_kobj, GFP_KERNEL);
+
+		printk("XXX: moving %s under %s\n", s, p);
+		kfree(s);
+		kfree(p);
+	}
 	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
 
 	error = 0;
@@ -845,14 +860,14 @@ int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 		goto out;	/* nothing to move */
 
 	/* get dentries */
-	old_dentry = sysfs_get_dentry(sd);
+	old_dentry = __sysfs_get_dentry(sd, 1);
 	if (IS_ERR(old_dentry)) {
 		error = PTR_ERR(old_dentry);
 		goto out;
 	}
 	old_parent = old_dentry->d_parent;
 
-	new_parent = sysfs_get_dentry(new_parent_sd);
+	new_parent = __sysfs_get_dentry(new_parent_sd, 1);
 	if (IS_ERR(new_parent)) {
 		error = PTR_ERR(new_parent);
 		goto out;
@@ -878,7 +893,6 @@ again:
 	error = 0;
 	d_add(new_dentry, NULL);
 	d_move(old_dentry, new_dentry);
-	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
 	sysfs_unlink_sibling(sd);

--------------010600060907090706030500--
