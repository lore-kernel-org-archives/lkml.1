Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbZEMQpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbZEMQpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbZEMQpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:45:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60158 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbZEMQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:45:04 -0400
Subject: Re: [patch 00/13] devtmpfs patches
From: Kay Sievers <kay.sievers@vrfy.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: David Howells <dhowells@redhat.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1242225358.9974.26.camel@localhost.localdomain>
References: <20090509143742.GA27663@kroah.com>
	 <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
	 <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
	 <1242132344.31807.48.camel@localhost.localdomain>
	 <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com>
	 <1242142528.31807.80.camel@localhost.localdomain>
	 <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com>
	 <1242168913.6711.9.camel@poy> <10761.1242220810@redhat.com>
	 <ac3eb2510905130634l75ef8f78v604c53fb4bc3167f@mail.gmail.com>
	 <ac3eb2510905130720x38de25adxc83b10aea0b86ce1@mail.gmail.com>
	 <1242225358.9974.26.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 13 May 2009 18:45:01 +0200
Message-Id: <1242233101.2893.7.camel@poy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 10:35 -0400, Stephen Smalley wrote:
> > Maybe we could do the same credential swap in sysfs, and get rid of:
> > /**
> >  * lookup_one_noperm - bad hack for sysfs
> > 
> > Seems a bit odd to have a vfs function for a single filesystem, called
> > from a single location, and annotated as "do not use". Christoph added
> > the comment a while ago, so adding him to Cc:.
> 
> Yes, that makes sense to me as well - we didn't have the credentials
> infrastructure in place at the time that lookup_one_noperm was
> introduced, but switching the credentials around a normal lookup_one_len
> call should work now.

Something like this? It seems to work fine here, but I did not test it with SELinux.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: sysfs - switch noperm lookup_one_len() hack to credentials switch
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>

Driver core actions may be requested by processes, which do not have the
proper permissions in a DAC and LSM/SELinux context to create entries in
sysfs. This replaces the vfs noperm hack with a switch to init_cred before
sysfs entries are created.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 fs/namei.c            |   22 ----------------------
 fs/sysfs/dir.c        |    7 ++++++-
 include/linux/namei.h |    1 -
 3 files changed, 6 insertions(+), 24 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1260,28 +1260,6 @@ struct dentry *lookup_one_len(const char
 	return __lookup_hash(&this, base, NULL);
 }
 
-/**
- * lookup_one_noperm - bad hack for sysfs
- * @name:	pathname component to lookup
- * @base:	base directory to lookup from
- *
- * This is a variant of lookup_one_len that doesn't perform any permission
- * checks.   It's a horrible hack to work around the braindead sysfs
- * architecture and should not be used anywhere else.
- *
- * DON'T USE THIS FUNCTION EVER, thanks.
- */
-struct dentry *lookup_one_noperm(const char *name, struct dentry *base)
-{
-	int err;
-	struct qstr this;
-
-	err = __lookup_one_len(name, &this, base, strlen(name));
-	if (err)
-		return ERR_PTR(err);
-	return __lookup_hash(&this, base, NULL);
-}
-
 int user_path_at(int dfd, const char __user *name, unsigned flags,
 		 struct path *path)
 {
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -21,6 +21,8 @@
 #include <linux/completion.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
+#include <linux/init_task.h>
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
@@ -103,6 +105,7 @@ struct dentry *sysfs_get_dentry(struct s
 
 	while (dentry->d_fsdata != sd) {
 		struct sysfs_dirent *cur;
+		const struct cred *curr_cred;
 		struct dentry *parent;
 
 		/* find the first ancestor which hasn't been looked up */
@@ -111,11 +114,13 @@ struct dentry *sysfs_get_dentry(struct s
 			cur = cur->s_parent;
 
 		/* look it up */
+		curr_cred = override_creds(&init_cred);
 		parent = dentry;
 		mutex_lock(&parent->d_inode->i_mutex);
-		dentry = lookup_one_noperm(cur->s_name, parent);
+		dentry = lookup_one_len(cur->s_name, parent, strlen(cur->s_name));
 		mutex_unlock(&parent->d_inode->i_mutex);
 		dput(parent);
+		revert_creds(curr_cred);
 
 		if (IS_ERR(dentry))
 			break;
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -75,7 +75,6 @@ extern struct file *nameidata_to_filp(st
 extern void release_open_intent(struct nameidata *);
 
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
-extern struct dentry *lookup_one_noperm(const char *, struct dentry *);
 
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);


