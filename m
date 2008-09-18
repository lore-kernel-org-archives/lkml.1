Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYIRNJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYIRNJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYIRNJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:09:04 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:42504 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbYIRNJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:09:03 -0400
Date: Thu, 18 Sep 2008 14:28:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman), Greg K-H <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: Remove sysfs_do_create_link().
Message-ID: <20080918142806.20568dda@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m1y71pvg5d.fsf@frodo.ebiederm.org>
References: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
	<m1r67i61rh.fsf@frodo.ebiederm.org>
	<20080918090705.6985cced@gondolin.boeblingen.de.ibm.com>
	<m17i99wz7k.fsf@frodo.ebiederm.org>
	<20080918125056.03c404e8@gondolin.boeblingen.de.ibm.com>
	<m1y71pvg5d.fsf@frodo.ebiederm.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sysfs_create_link_nowarn() is gone, sysfs_do_create_link()
is an unneeded indirection: Remove it.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 fs/sysfs/symlink.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- linux-2.6.orig/fs/sysfs/symlink.c
+++ linux-2.6/fs/sysfs/symlink.c
@@ -19,8 +19,14 @@
 
 #include "sysfs.h"
 
-static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
-				const char *name, int warn)
+/**
+ *	sysfs_create_link - create symlink between two objects.
+ *	@kobj:	object whose directory we're creating the link in.
+ *	@target:	object we're pointing to.
+ *	@name:		name of the symlink.
+ */
+int sysfs_create_link(struct kobject *kobj, struct kobject *target,
+		      const char *name)
 {
 	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
@@ -60,10 +66,7 @@ static int sysfs_do_create_link(struct k
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
-	if (warn)
-		error = sysfs_add_one(&acxt, sd);
-	else
-		error = __sysfs_add_one(&acxt, sd);
+	error = sysfs_add_one(&acxt, sd);
 	sysfs_addrm_finish(&acxt);
 
 	if (error)
@@ -78,18 +81,6 @@ static int sysfs_do_create_link(struct k
 }
 
 /**
- *	sysfs_create_link - create symlink between two objects.
- *	@kobj:	object whose directory we're creating the link in.
- *	@target:	object we're pointing to.
- *	@name:		name of the symlink.
- */
-int sysfs_create_link(struct kobject *kobj, struct kobject *target,
-		      const char *name)
-{
-	return sysfs_do_create_link(kobj, target, name, 1);
-}
-
-/**
  *	sysfs_delete_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
  *	@targ:	object we're pointing to.
