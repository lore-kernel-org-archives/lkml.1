Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZJTFto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZJTFto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZJTFtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:49:43 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49370 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZJTFtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:49:42 -0400
Date: Mon, 19 Oct 2009 23:49:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH 1/3] Fix updating of named attribute groups
Message-ID: <20091020054946.GD29158@parisc-linux.org>
References: <20091020054740.GC29158@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020054740.GC29158@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Matthew Wilcox <willy@linux.intel.com>
Date: Sat, 17 Oct 2009 15:47:43 -0400
Subject: [PATCH 1/3] Fix updating of named attribute groups

The current code tries to create a subdirectory, even if the caller is
trying to update an existing group.  If the caller wants to update a named
group, we need to call sysfs_get_dirent() which bumps the reference count
on the dirent, so move the sysfs_get() into the other two arms of the 'if'.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/sysfs/group.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index fe61194..0c4d342 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -69,12 +69,19 @@ static int internal_create_group(struct kobject *kobj, int update,
 		return -EINVAL;
 
 	if (grp->name) {
-		error = sysfs_create_subdir(kobj, grp->name, &sd);
-		if (error)
-			return error;
-	} else
-		sd = kobj->sd;
-	sysfs_get(sd);
+		if (update) {
+			sd = sysfs_get_dirent(kobj->sd, grp->name);
+			if (!sd)
+				return -ENOENT;
+		} else {
+			error = sysfs_create_subdir(kobj, grp->name, &sd);
+			if (error)
+				return error;
+			sysfs_get(sd);
+		}
+	} else {
+		sd = sysfs_get(kobj->sd);
+	}
 	error = create_files(sd, kobj, grp, update);
 	if (error) {
 		if (grp->name)
-- 
1.6.3.3


-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
