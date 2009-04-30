Return-Path: <linux-kernel-owner+w=401wt.eu-S934245AbZD3R4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245AbZD3R4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933172AbZD3RdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:33:08 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:57475 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbZD3RdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:33:07 -0400
Date: Thu, 30 Apr 2009 10:30:35 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: [PATCH 2/2] configfs: Rework configfs_depend_item() locking
	and make lockdep happy
Message-ID: <20090430173035.GB2762@mail.oracle.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <1233166713-9668-1-git-send-email-louis.rilling@kerlabs.com> <1233166713-9668-3-git-send-email-louis.rilling@kerlabs.com> <20090429185231.GE4743@mail.oracle.com> <20090430091828.GB13896@hawkmoon.kerlabs.com> <20090430172014.GA2762@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430172014.GA2762@mail.oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49F9E06F.011D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 10:20:14AM -0700, Joel Becker wrote:
> On Thu, Apr 30, 2009 at 11:18:28AM +0200, Louis Rilling wrote:
> > Agreed, I was going to suggest something like this. Actually I'd push the
> > initialization of s_type down to configfs_new_dirent(), so that s_type either
> > is always NULL, or always shows the correct type of object.
> 
> 	0, not "NULL", but yeah I think that's a good plan.

	Like this.  Please review the comment change mostly.


diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 63d8815..8e48b52 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -167,8 +167,8 @@ configfs_adjust_dir_dirent_depth_after_populate(struct configfs_dirent *sd)
 /*
  * Allocates a new configfs_dirent and links it to the parent configfs_dirent
  */
-static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * parent_sd,
-						void * element)
+static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent *parent_sd,
+						   void *element, int type)
 {
 	struct configfs_dirent * sd;
 
@@ -180,6 +180,7 @@ static struct configfs_dirent *configfs_new_dirent(struct configfs_dirent * pare
 	INIT_LIST_HEAD(&sd->s_links);
 	INIT_LIST_HEAD(&sd->s_children);
 	sd->s_element = element;
+	sd->s_type = type;
 	configfs_init_dirent_depth(sd);
 	spin_lock(&configfs_dirent_lock);
 	if (parent_sd->s_type & CONFIGFS_USET_DROPPING) {
@@ -225,19 +226,12 @@ int configfs_make_dirent(struct configfs_dirent * parent_sd,
 {
 	struct configfs_dirent * sd;
 
-	sd = configfs_new_dirent(parent_sd, element);
+	sd = configfs_new_dirent(parent_sd, element, type);
 	if (IS_ERR(sd))
 		return PTR_ERR(sd);
 
-	/*
-	 * We need configfs_dirent_lock so that configfs_depend_prep()
-	 * can see s_type accurately on other CPUs.
-	 */
-	spin_lock(&configfs_dirent_lock);
 	sd->s_mode = mode;
-	sd->s_type = type;
 	sd->s_dentry = dentry;
-	spin_unlock(&configfs_dirent_lock);
 	if (dentry) {
 		dentry->d_fsdata = configfs_get(sd);
 		dentry->d_op = &configfs_dentry_ops;
@@ -1034,11 +1028,10 @@ static int configfs_dump(struct configfs_dirent *sd, int level)
  * dead, as well as items in the middle of attachment since they virtually
  * do not exist yet. This completes the locking out of racing mkdir() and
  * rmdir().
- * Note: items in the middle of attachment start with s_type = 0
- * (configfs_new_dirent()), and configfs_make_dirent() (called from
- * create_dir()) sets s_type = CONFIGFS_DIR|CONFIGFS_USET_CREATING. In both
- * cases the item is ignored.  configfs_make_dirent() is locked out from
- * updating s_type by configfs_dirent_lock.
+ * Note: subdirectories in the middle of attachment start with s_type =
+ * CONFIGFS_DIR|CONFIGFS_USET_CREATING set by create_dir().  When
+ * CONFIGFS_USET_CREATING is set, we ignore the item.  The actual set of
+ * s_type is in configfs_new_dirent(), which has configfs_dirent_lock.
  *
  * If the target is not found, -ENOENT is bubbled up.
  *
@@ -1514,7 +1507,7 @@ static int configfs_dir_open(struct inode *inode, struct file *file)
 	 */
 	err = -ENOENT;
 	if (configfs_dirent_is_ready(parent_sd)) {
-		file->private_data = configfs_new_dirent(parent_sd, NULL);
+		file->private_data = configfs_new_dirent(parent_sd, NULL, 0);
 		if (IS_ERR(file->private_data))
 			err = PTR_ERR(file->private_data);
 		else

-- 

"There is no sincerer love than the love of food."  
         - George Bernard Shaw 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
