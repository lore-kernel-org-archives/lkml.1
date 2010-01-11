Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486Ab0AKUXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0AKUXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402Ab0AKUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:23:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59327 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab0AKUWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:22:14 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: [PATCH 5/7] driver core: Use sysfs_rename_link in device_rename
Date: Mon, 11 Jan 2010 12:21:53 -0800
Message-Id: <1263241315-19499-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1d41g9z3q.fsf@fess.ebiederm.org>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Don't open code the renaming of symlinks in sysfs
instead use the new helper function sysfs_rename_link

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/base/core.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2820257..ba66394 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1574,22 +1574,16 @@ int device_rename(struct device *dev, char *new_name)
 	if (old_class_name) {
 		new_class_name = make_class_name(dev->class->name, &dev->kobj);
 		if (new_class_name) {
-			error = sysfs_create_link_nowarn(&dev->parent->kobj,
-							 &dev->kobj,
-							 new_class_name);
-			if (error)
-				goto out;
-			sysfs_remove_link(&dev->parent->kobj, old_class_name);
+			error = sysfs_rename_link(&dev->parent->kobj,
+						  &dev->kobj,
+						  old_class_name,
+						  new_class_name);
 		}
 	}
 #else
 	if (dev->class) {
-		error = sysfs_create_link_nowarn(&dev->class->p->class_subsys.kobj,
-						 &dev->kobj, dev_name(dev));
-		if (error)
-			goto out;
-		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
-				  old_device_name);
+		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
+					  &dev->kobj, old_device_name, new_name);
 	}
 #endif
 
-- 
1.6.5.2.143.g8cc62

