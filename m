Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbZJUTYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbZJUTYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZJUTXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:23:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbZJUTVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:34 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 36/41] union-mount: Increment read-only users count for read-only layer
Date: Wed, 21 Oct 2009 12:19:34 -0700
Message-Id: <1256152779-10054-37-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-36-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
 <1256152779-10054-28-git-send-email-vaurora@redhat.com>
 <1256152779-10054-29-git-send-email-vaurora@redhat.com>
 <1256152779-10054-30-git-send-email-vaurora@redhat.com>
 <1256152779-10054-31-git-send-email-vaurora@redhat.com>
 <1256152779-10054-32-git-send-email-vaurora@redhat.com>
 <1256152779-10054-33-git-send-email-vaurora@redhat.com>
 <1256152779-10054-34-git-send-email-vaurora@redhat.com>
 <1256152779-10054-35-git-send-email-vaurora@redhat.com>
 <1256152779-10054-36-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Union mounts want to guarantee that the read-only layer is read-only -
and stays read-only.  Use the new superblock read-only user count.

XXX - Put common code in loopback and regular mounts in a function

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 0280e5b..505974a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1111,6 +1111,11 @@ static int do_umount(struct vfsmount *mnt, int flags)
 	spin_unlock(&vfsmount_lock);
 	if (retval)
 		security_sb_umount_busy(mnt);
+	/* If this was a union mount, we are no longer a read-only
+	 * user on the underlying mount */
+	if (mnt->mnt_flags & MNT_UNION)
+		mnt->mnt_parent->mnt_sb->s_readonly_users--;
+
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	return retval;
@@ -1511,6 +1516,10 @@ static int do_loopback(struct path *path, char *old_name, int recurse,
 		release_mounts(&umount_list);
 	}
 
+	/* If this is a union mount, add ourselves to the readonly users */
+	if (mnt_flags & MNT_UNION)
+		mnt->mnt_parent->mnt_sb->s_readonly_users++;
+
 out:
 	up_write(&namespace_sem);
 	path_put(&old_path);
@@ -1730,6 +1739,10 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
 
+	/* If this is a union mount, add ourselves to the readonly users */
+	if (mnt_flags & MNT_UNION)
+		newmnt->mnt_parent->mnt_sb->s_readonly_users++;
+
 	if (fslist) /* add to the specified expiration list */
 		list_add_tail(&newmnt->mnt_expire, fslist);
 
-- 
1.6.3.3

