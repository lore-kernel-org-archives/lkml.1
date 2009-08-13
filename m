Return-Path: <linux-kernel-owner+w=401wt.eu-S932345AbZHMUKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbZHMUKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbZHMT7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:36 -0400
Received: from kroah.org ([198.145.64.141]:41716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbZHMT7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:28 2009
Message-Id: <20090813195128.394569326@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Igor Mammedov <niallain@gmail.com>, Jeff Layton <jlayton@redhat.com>,
       Steve French <sfrench@us.ibm.com>
Subject: [patch 26/74] cifs: fix error handling in mount-time DFS referral chasing code
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=cifs-fix-error-handling-in-mount-time-dfs-referral-chasing-code.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 7b91e2661addd8e2419cb45f6a322aa5dab9bcee upstream.

If the referral is malformed or the hostname can't be resolved, then
the current code generates an oops. Fix it to handle these errors
gracefully.

Reported-by: Sandro Mathys <sm@sandro-mathys.ch>
Acked-by: Igor Mammedov <niallain@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifs_dfs_ref.c |   12 +++++++++---
 fs/cifs/connect.c      |   13 ++++++++++---
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -55,7 +55,7 @@ void cifs_dfs_release_automount_timer(vo
  * i.e. strips from UNC trailing path that is not part of share
  * name and fixup missing '\' in the begining of DFS node refferal
  * if neccessary.
- * Returns pointer to share name on success or NULL on error.
+ * Returns pointer to share name on success or ERR_PTR on error.
  * Caller is responsible for freeing returned string.
  */
 static char *cifs_get_share_name(const char *node_name)
@@ -68,7 +68,7 @@ static char *cifs_get_share_name(const c
 	UNC = kmalloc(len+2 /*for term null and additional \ if it's missed */,
 			 GFP_KERNEL);
 	if (!UNC)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/* get share name and server name */
 	if (node_name[1] != '\\') {
@@ -87,7 +87,7 @@ static char *cifs_get_share_name(const c
 		cERROR(1, ("%s: no server name end in node name: %s",
 			__func__, node_name));
 		kfree(UNC);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	/* find sharename end */
@@ -133,6 +133,12 @@ char *cifs_compose_mount_options(const c
 		return ERR_PTR(-EINVAL);
 
 	*devname = cifs_get_share_name(ref->node_name);
+	if (IS_ERR(*devname)) {
+		rc = PTR_ERR(*devname);
+		*devname = NULL;
+		goto compose_mount_options_err;
+	}
+
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc != 0) {
 		cERROR(1, ("%s: Failed to resolve server part of %s to IP: %d",
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2563,11 +2563,20 @@ remote_path_check:
 
 			if (mount_data != mount_data_global)
 				kfree(mount_data);
+
 			mount_data = cifs_compose_mount_options(
 					cifs_sb->mountdata, full_path + 1,
 					referrals, &fake_devname);
-			kfree(fake_devname);
+
 			free_dfs_info_array(referrals, num_referrals);
+			kfree(fake_devname);
+			kfree(full_path);
+
+			if (IS_ERR(mount_data)) {
+				rc = PTR_ERR(mount_data);
+				mount_data = NULL;
+				goto mount_fail_check;
+			}
 
 			if (tcon)
 				cifs_put_tcon(tcon);
@@ -2575,8 +2584,6 @@ remote_path_check:
 				cifs_put_smb_ses(pSesInfo);
 
 			cleanup_volume_info(&volume_info);
-			FreeXid(xid);
-			kfree(full_path);
 			referral_walks_count++;
 			goto try_mount_again;
 		}


