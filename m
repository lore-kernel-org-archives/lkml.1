Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbYDTKkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbYDTKkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYDTKjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:39:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56240 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYDTKjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:39:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/36] kobject: catch kobjects that are not initialized
Date: Sun, 20 Apr 2008 03:45:31 -0700
Message-Id: <1208688366-9252-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add warnings to kobject_put() to catch kobjects that are cleaned up but
were never initialized to begin with.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 0d03252..60ae9e8 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -592,8 +592,15 @@ static void kobject_release(struct kref *kref)
  */
 void kobject_put(struct kobject *kobj)
 {
-	if (kobj)
+	if (kobj) {
+		if (!kobj->state_initialized) {
+			printk(KERN_WARNING "kobject: '%s' (%p): is not "
+			       "initialized, yet kobject_put() is being "
+			       "called.\n", kobject_name(kobj), kobj);
+			WARN_ON(1);
+		}
 		kref_put(&kobj->kref, kobject_release);
+	}
 }
 
 static void dynamic_kobj_release(struct kobject *kobj)
-- 
1.5.4.5

