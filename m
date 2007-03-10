Return-Path: <linux-kernel-owner+w=401wt.eu-S1767784AbXCJEJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767784AbXCJEJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767790AbXCJEJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:09:38 -0500
Received: from ns.suse.de ([195.135.220.2]:36297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767779AbXCJEJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:09:29 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitriy Monakhov <dmonakhov@sw.ru>,
       Monakhov Dmitriy <dmonakhov@openvz.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] kobject: new_device->kref wasn't putted after error in kobject_move()
Date: Fri,  9 Mar 2007 20:07:32 -0800
Message-Id: <11734996641158-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11734996612279-git-send-email-gregkh@suse.de>
References: <20070310040405.GC30638@kroah.com> <11734996523796-git-send-email-gregkh@suse.de> <11734996551193-git-send-email-gregkh@suse.de> <1173499658766-git-send-email-gregkh@suse.de> <11734996612279-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitriy Monakhov <dmonakhov@sw.ru>

If error happen we jump to "out" label, in this case new_device not yet
became the parent but it wasn't putted.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index f4f6176..057921c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -385,9 +385,11 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
 		goto out;
 	old_parent = kobj->parent;
 	kobj->parent = new_parent;
+	new_parent = NULL;
 	kobject_put(old_parent);
 	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
 out:
+	kobject_put(new_parent);
 	kobject_put(kobj);
 	kfree(devpath_string);
 	kfree(devpath);
-- 
1.5.0.2

