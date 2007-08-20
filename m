Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbXHTKiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbXHTKiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 06:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbXHTKh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 06:37:59 -0400
Received: from [192.55.52.93] ([192.55.52.93]:46744 "EHLO mga11.intel.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbXHTKh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 06:37:58 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 06:37:58 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,284,1183359600"; 
   d="scan'208";a="285141940"
Subject: [PATCH] [-mm] FS: file name must be unique in the same dir in
	procfs
From: Zhang Rui <rui.zhang@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: text/plain
Date: Mon, 20 Aug 2007 18:28:19 +0800
Message-Id: <1187605699.2920.147.camel@acpi-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Files name must be unique in the same directory.

Bug is reported here: 
http://bugzilla.kernel.org/show_bug.cgi?id=8798

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 fs/proc/generic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.23-rc3/fs/proc/generic.c
===================================================================
--- linux-2.6.23-rc3.orig/fs/proc/generic.c
+++ linux-2.6.23-rc3/fs/proc/generic.c
@@ -523,6 +523,7 @@ static const struct inode_operations pro
 
 static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
 {
+	struct proc_dir_entry * tmp = NULL;
 	unsigned int i;
 	
 	i = get_inode_number();
@@ -547,6 +548,13 @@ static int proc_register(struct proc_dir
 	}
 
 	spin_lock(&proc_subdir_lock);
+	for(tmp = dir->subdir; tmp; tmp = tmp->next)
+		if(!strcmp(dp->name, tmp->name)) {
+			spin_unlock(&proc_subdir_lock);
+			release_inode_number(i);
+			return -EEXIST;
+		}
+
 	dp->next = dir->subdir;
 	dp->parent = dir;
 	dir->subdir = dp;
