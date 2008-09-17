Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYIQNlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYIQNlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYIQNlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:41:04 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:48940 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYIQNlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:41:02 -0400
Date: Wed, 17 Sep 2008 13:08:05 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg K-H <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH]sysfs: Don't emit a warning when sysfs_rename_link() fails.
Message-ID: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
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

Hi Greg, hi Eric,

the recent sysfs tagged directory changes switched device_rename() to
sysfs_rename_link() - which is a good thing but AFAICS re-introduces
the scary warnings when a netdevice is renamed to something that
already exists (which I tried to fix with
36ce6dad6e3cb3f050ed41e0beac0070d2062b25).

The following patch switches sysfs_rename_link() to non-warning symlink
creation again. It is on top of the current driver core series.

sysfs: Don't emit a warning when sysfs_rename_link() fails.

From: Cornelia Huck <cornelia.huck@de.ibm.com>

sysfs_rename_link() will be printing a scary looking warning
if a link of the same name already exists. Callers of
device_rename() don't want to see this warning since they
already handle the failure themselves, so let's use the not
warning variant of sysfs_do_create_link().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 fs/sysfs/symlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/sysfs/symlink.c
===================================================================
--- linux-2.6.orig/fs/sysfs/symlink.c
+++ linux-2.6/fs/sysfs/symlink.c
@@ -135,7 +135,7 @@ int sysfs_rename_link(struct kobject *ko
 			const char *old, const char *new)
 {
 	sysfs_delete_link(kobj, targ, old);
-	return sysfs_create_link(kobj, targ, new);
+	return sysfs_do_create_link(kobj, targ, new, 0);
 }
 
 static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
