Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbXCEVnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbXCEVnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933457AbXCEVnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:43:04 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:60746 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635AbXCEVnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:43:03 -0500
Date: Mon, 5 Mar 2007 13:42:56 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] configfs: add missing mutex_unlock()
Message-ID: <20070305214256.GC20528@ca-server1.us.oracle.com>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
References: <20070304133812.GC8519@APFDCB5C> <200703041510.20127.arnd@arndb.de> <20070304151659.GA19972@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070304151659.GA19972@APFDCB5C>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	First, thank you Akinobu for discovering the bug.

On Mon, Mar 05, 2007 at 12:16:59AM +0900, Akinobu Mita wrote:
> On Sun, Mar 04, 2007 at 03:10:19PM +0100, Arnd Bergmann wrote:
> > This should be changed to jump to a new exit point, before the mutex_unlock
> > at the end of the function. Having multiple places in the function that
> > release the same lock easily leads to the kind of bug you are fixing here.
> 
> Agreed. Please see the patch below (untested).

	Jumping isn't always the solution.  The new patch, while better
than the first, still calls mutex_unlock() in two places.  The following
patch keeps it all in one code path, and keeps all dentry modification
underneath a single mutex_lock()/unlock() pair.  What do you think?  I'm
building it to test as we speak.

Joel

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 1814ba4..489c265 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1142,25 +1142,22 @@ int configfs_register_subsystem(struct configfs_subsystem *subsys)
 
 	err = -ENOMEM;
 	dentry = d_alloc(configfs_sb->s_root, &name);
-	if (!dentry)
-		goto out_release;
-
-	d_add(dentry, NULL);
+	if (dentry) {
+		d_add(dentry, NULL);
 
-	err = configfs_attach_group(sd->s_element, &group->cg_item,
-				    dentry);
-	if (!err)
-		dentry = NULL;
-	else
-		d_delete(dentry);
+		err = configfs_attach_group(sd->s_element, &group->cg_item,
+					    dentry);
+		if (err) {
+			d_delete(dentry);
+			dput(dentry);
+		}
+	}
 
 	mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
 
-	if (dentry) {
-	    dput(dentry);
-out_release:
-	    unlink_group(group);
-	    configfs_release_fs();
+	if (err) {
+		unlink_group(group);
+		configfs_release_fs();
 	}
 
 	return err;

-- 

"Nobody loves me,
 Nobody seems to care.
 Troubles and worries, people,
 You know I've had my share."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
