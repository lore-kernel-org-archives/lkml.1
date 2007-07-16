Return-Path: <linux-kernel-owner+w=401wt.eu-S1765872AbXGPOEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765872AbXGPOEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765648AbXGPOCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:02:39 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:14371 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765637AbXGPOCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WRWoHoQk2KgML99vI5IZiZ2+YbvLTWgWUsM17uX2agcPHlA5GtcfiWtVQFyj6WuyPjHrAP2YhMzhIOauH8vxuyda8StXZ8AGmTn0EKyabBqMwMfU3lWViVW5S5cwfWH90KvVUcdF/x0U8zbpCJI2JeRKRNXjp6QsRoD2Lxx4ijA=
Date: Mon, 16 Jul 2007 22:52:30 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/10] sysfs: fix error handling in create_files()
Message-ID: <20070716135230.GC2040@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current error handling in create_files() attempts to remove
all attributes passed by argument by remove_files(). But it should
only remove the attributes that have been successfully added.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/sysfs/group.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

Index: 2.6-mm/fs/sysfs/group.c
===================================================================
--- 2.6-mm.orig/fs/sysfs/group.c
+++ 2.6-mm/fs/sysfs/group.c
@@ -30,13 +30,19 @@ static void remove_files(struct sysfs_di
 static int create_files(struct sysfs_dirent *dir_sd,
 			const struct attribute_group *grp)
 {
-	struct attribute *const* attr;
-	int error = 0;
+	int i;
+	int error;
+
+	for (i = 0; grp->attrs[i]; i++) {
+		error = sysfs_add_file(dir_sd, grp->attrs[i], SYSFS_KOBJ_ATTR);
+		if (error)
+			goto error;
+	}
+	return 0;
+error:
+	while (i--)
+		sysfs_hash_and_remove(dir_sd, grp->attrs[i]->name);
 
-	for (attr = grp->attrs; *attr && !error; attr++)
-		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
-	if (error)
-		remove_files(dir_sd, grp);
 	return error;
 }
 
