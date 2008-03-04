Return-Path: <linux-kernel-owner+w=401wt.eu-S935210AbYCDXZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210AbYCDXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934869AbYCDXTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:19:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:42790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935022AbYCDXTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:19:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/8] kobject: properly initialize ksets
Date: Tue,  4 Mar 2008 15:18:47 -0800
Message-Id: <1204672732-3127-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080304231519.GC3073@suse.de>
References: <20080304231519.GC3073@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kset_initialize was calling kobject_init_internal() which didn't
initialize the kobject as well as kobject_init() was.  So have
kobject_init() call kobject_init_internal() and move the logic to
initalize the kobject there.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index d784dae..0d03252 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -153,6 +153,10 @@ static void kobject_init_internal(struct kobject *kobj)
 		return;
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
+	kobj->state_in_sysfs = 0;
+	kobj->state_add_uevent_sent = 0;
+	kobj->state_remove_uevent_sent = 0;
+	kobj->state_initialized = 1;
 }
 
 
@@ -289,13 +293,8 @@ void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
 		dump_stack();
 	}
 
-	kref_init(&kobj->kref);
-	INIT_LIST_HEAD(&kobj->entry);
+	kobject_init_internal(kobj);
 	kobj->ktype = ktype;
-	kobj->state_in_sysfs = 0;
-	kobj->state_add_uevent_sent = 0;
-	kobj->state_remove_uevent_sent = 0;
-	kobj->state_initialized = 1;
 	return;
 
 error:
-- 
1.5.4.3

