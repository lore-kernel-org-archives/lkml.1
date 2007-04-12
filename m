Return-Path: <linux-kernel-owner+w=401wt.eu-S1161128AbXDLIGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161128AbXDLIGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 04:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161342AbXDLIGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 04:06:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:16493 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161128AbXDLIGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 04:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=PdLSibF67q+9xMDRNnprIjcH+xlhdPYlwn2QQoDrsNFKLl+I87q7FWpsNu9MyPI9Us2WpakNv/kPj18Tu0IM3fugziJjt3pAmTGciiDNL86Y9D3iSOpIcyPetgGnymb94KTT155GLioDRwSC82VHwBnBMy+b6N4RyDS5ORmo/OE=
Date: Thu, 12 Apr 2007 17:06:35 +0900
From: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       cornelia.huck@de.ibm.com
Subject: [PATCH] sysfs: make lockdep ignore s_active
Message-ID: <20070412080635.GH10619@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

s_active is released by the thread doing the final sysfs_put() which
can be different from the thread which did sysfs_deactivate().  Make
lockdep think that s_active is unlocked immediately after it's write
locked.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---

Greg, this patch fixes lockdep error reported by Cornelia.  Please add
this to the patch series.  Andrew, this is the same one you took
earlier only with comments added.

Thanks.

 fs/sysfs/dir.c   |    7 ++++++-
 fs/sysfs/sysfs.h |    5 +++++
 2 files changed, 11 insertions(+), 1 deletion(-)

Index: work/fs/sysfs/dir.c
===================================================================
--- work.orig/fs/sysfs/dir.c
+++ work/fs/sysfs/dir.c
@@ -25,8 +25,13 @@ void release_sysfs_dirent(struct sysfs_d
 	/* If @sd is being released after deletion, s_active is write
 	 * locked.  If @sd is cursor for directory walk or being
 	 * released prematurely, s_active has no reader or writer.
+	 *
+	 * sysfs_deactivate() lies to lockdep that s_active is
+	 * unlocked immediately.  Lie one more time to cover the
+	 * previous lie.
 	 */
-	down_write_trylock(&sd->s_active);
+	if (!down_write_trylock(&sd->s_active))
+		rwsem_acquire(&sd->s_active.dep_map, 0, 0, _RET_IP_);
 	up_write(&sd->s_active);
 
 	if (sd->s_type & SYSFS_KOBJ_LINK)
Index: work/fs/sysfs/sysfs.h
===================================================================
--- work.orig/fs/sysfs/sysfs.h
+++ work/fs/sysfs/sysfs.h
@@ -171,6 +171,11 @@ static inline void sysfs_put_active_two(
 static inline void sysfs_deactivate(struct sysfs_dirent *sd)
 {
 	down_write(&sd->s_active);
+
+	/* s_active will be unlocked by the thread doing the final put
+	 * on @sd.  Lie to lockdep.
+	 */
+	rwsem_release(&sd->s_active.dep_map, 1, _RET_IP_);
 }
 
 static inline int sysfs_is_shadowed_inode(struct inode *inode)
