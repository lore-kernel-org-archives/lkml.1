Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbZENXIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbZENXIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762275AbZENW6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:58:50 -0400
Received: from kroah.org ([198.145.64.141]:46134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762167AbZENW6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:58:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:52:40 2009
Message-Id: <20090514225240.016333196@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:51:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 22/28] NFS: Fix the notifications when renaming onto an existing file
References: <20090514225126.907908936@mini.kroah.org>
Content-Disposition: inline; filename=nfs-fix-the-notifications-when-renaming-onto-an-existing-file.patch
In-Reply-To: <20090514225413.GA705@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b1e4adf4ea41bb8b5a7bfc1a7001f137e65495df upstream.

NFS appears to be returning an unnecessary "delete" notification when
we're doing an atomic rename. See

  http://bugzilla.gnome.org/show_bug.cgi?id=575684

The fix is to get rid of the redundant call to d_delete().

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dir.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1613,8 +1613,7 @@ static int nfs_rename(struct inode *old_
 		} else if (atomic_read(&new_dentry->d_count) > 1)
 			/* dentry still busy? */
 			goto out;
-	} else
-		nfs_drop_nlink(new_inode);
+	}
 
 go_ahead:
 	/*
@@ -1627,10 +1626,8 @@ go_ahead:
 	}
 	nfs_inode_return_delegation(old_inode);
 
-	if (new_inode != NULL) {
+	if (new_inode != NULL)
 		nfs_inode_return_delegation(new_inode);
-		d_delete(new_dentry);
-	}
 
 	error = NFS_PROTO(old_dir)->rename(old_dir, &old_dentry->d_name,
 					   new_dir, &new_dentry->d_name);
@@ -1639,6 +1636,8 @@ out:
 	if (rehash)
 		d_rehash(rehash);
 	if (!error) {
+		if (new_inode != NULL)
+			nfs_drop_nlink(new_inode);
 		d_move(old_dentry, new_dentry);
 		nfs_set_verifier(new_dentry,
 					nfs_save_change_attribute(new_dir));


