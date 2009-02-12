Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbZBLC5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbZBLC5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZBLC47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:56:59 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:42746 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbZBLC44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:56:56 -0500
Date: Wed, 11 Feb 2009 19:56:55 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate
	file is
Message-ID: <20090212025655.GA6916@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090211202601.GC3402@ldl.fc.hp.com> <20090211223903.GA21100@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211223903.GA21100@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Wed, Feb 11, 2009 at 01:26:01PM -0700, Alex Chiang wrote:
> > Give a better clue about where we might be creating duplicate
> > files by displaying the parent's name as well.
> > 
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> > ---
> > It would be nice to get a full path, but simply printing out the
> > parent is cheap and more useful than what we have now.
> 
> What happens if you don't have a parent?  will this oops if you are
> creating a duplicate device in the root of the sysfs tree?

We won't oops because if you attempt to create a device in the
root of the sysfs tree with a NULL parent, then we say that your
parent is sysfs_root:

int sysfs_create_dir(struct kobject * kobj)
{
	...
        if (kobj->parent)
		parent_sd = kobj->parent->sd;
	else
		parent_sd = &sysfs_root;
	...

But I do notice that we're not giving sysfs_root a name, so if
you do hit the WARN for a duplicate entry in sysfs_root, you get
a blank string for the location of the duplicate.

How about this instead?

From: Alex Chiang <achiang@hp.com>

sysfs: give sysfs_root a proper name; display parent in duplicate entry WARN

Name sysfs_root "/".

Make sysfs_add_one tell you _where_ you're attempting to create a
duplicate file to help debug.

Giving sysfs_root a proper name covers the case when trying to
create multiple entries with the same name in the root of the
sysfs tree.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
Still would be nicer to get a full path.

I think that in the context of a sysfs WARN, claiming that you're
trying to create a duplicate file in "/" really means "/sys" and
shouldn't be confusing. Sample output:

sysfs: duplicate filename 'alex' can not be created in /

This maybe wants to be 2 patches, and I can split it up that way
if you prefer.

---

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 82d3b79..e153bd7 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -459,7 +459,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 
 	ret = __sysfs_add_one(acxt, sd);
 	WARN(ret == -EEXIST, KERN_WARNING "sysfs: duplicate filename '%s' "
-		       "can not be created\n", sd->s_name);
+		       "cannot be created in %s\n",
+		       sd->s_name, acxt->parent_sd->s_name);
 	return ret;
 }
 
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index ab343e3..7661b8d 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -33,7 +33,7 @@ static const struct super_operations sysfs_ops = {
 };
 
 struct sysfs_dirent sysfs_root = {
-	.s_name		= "",
+	.s_name		= "/",
 	.s_count	= ATOMIC_INIT(1),
 	.s_flags	= SYSFS_DIR,
 	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
