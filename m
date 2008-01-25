Return-Path: <linux-kernel-owner+w=401wt.eu-S1763811AbYAYH5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763811AbYAYH5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762077AbYAYHg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:50080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762072AbYAYHgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 105/196] kobject: grab the kset reference in kobject_add, not kobject_init
Date: Thu, 24 Jan 2008 23:32:14 -0800
Message-Id: <1201246425-5058-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_init should not be grabing any references, but only initializing
the object.  This patch fixes this, and makes the lock hold-time shorter
for when a kset is present in the kobject.

The current kernel tree has been audited to verify that this change
should be safe.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 7919c32..4d52b6f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -133,7 +133,6 @@ void kobject_init(struct kobject * kobj)
 		return;
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
-	kobj->kset = kset_get(kobj->kset);
 }
 
 
@@ -184,7 +183,7 @@ int kobject_add(struct kobject * kobj)
 		 kobj->kset ? kobject_name(&kobj->kset->kobj) : "<NULL>" );
 
 	if (kobj->kset) {
-		spin_lock(&kobj->kset->list_lock);
+		kobj->kset = kset_get(kobj->kset);
 
 		if (!parent) {
 			parent = kobject_get(&kobj->kset->kobj);
@@ -196,7 +195,8 @@ int kobject_add(struct kobject * kobj)
 			kobject_get(parent);
 		}
 
-		list_add_tail(&kobj->entry,&kobj->kset->list);
+		spin_lock(&kobj->kset->list_lock);
+		list_add_tail(&kobj->entry, &kobj->kset->list);
 		spin_unlock(&kobj->kset->list_lock);
 		kobj->parent = parent;
 	}
-- 
1.5.3.8

