Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbZJIXRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbZJIXRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761635AbZJIXRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:17:30 -0400
Received: from kroah.org ([198.145.64.141]:36852 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761634AbZJIXR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:17:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:01 2009
Message-Id: <20091009231001.649051837@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:08:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [patch 12/26] ima: ecryptfs fix imbalance message
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=ima-ecryptfs-fix-imbalance-message.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 36520be8e32b49bd85a63b7b8b40cd07c3da59a5 upstream.

The unencrypted files are being measured.  Update the counters to get
rid of the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)

Reported-by: Sachin Garg
Cc: Eric Paris <eparis@redhat.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: David Safford <safford@watson.ibm.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/main.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -35,6 +35,7 @@
 #include <linux/key.h>
 #include <linux/parser.h>
 #include <linux/fs_stack.h>
+#include <linux/ima.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -118,6 +119,7 @@ int ecryptfs_init_persistent_file(struct
 	const struct cred *cred = current_cred();
 	struct ecryptfs_inode_info *inode_info =
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
+	int opened_lower_file = 0;
 	int rc = 0;
 
 	mutex_lock(&inode_info->lower_file_mutex);
@@ -134,9 +136,12 @@ int ecryptfs_init_persistent_file(struct
 			       "for lower_dentry [0x%p] and lower_mnt [0x%p]; "
 			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
 			inode_info->lower_file = NULL;
-		}
+		} else
+			opened_lower_file = 1;
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
+	if (opened_lower_file)
+		ima_counts_get(inode_info->lower_file);
 	return rc;
 }
 


