Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbZJAOrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbZJAOrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932639AbZJAOrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:47:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65185 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbZJAOrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:47:36 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: [PATCH 1/1] Kobject: bail early if no new_parent in kobject_move()
Date: Thu,  1 Oct 2009 17:50:48 +0300
Message-Id: <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 01 Oct 2009 14:47:21.0050 (UTC) FILETIME=[149083A0:01CA42A6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Carmody <ext-phil.2.carmody@nokia.com>

In the absense of kobj->kset, new_parent would remain NULL.
NULL-dereference shenanighans then ensues in the subsequent
sysfs_move_dir(..., new_parent) call. Bail early instead.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 lib/kobject.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index b512b74..3574f94 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -471,8 +471,12 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
 		return -EINVAL;
 	new_parent = kobject_get(new_parent);
 	if (!new_parent) {
-		if (kobj->kset)
+		if (kobj->kset) {
 			new_parent = kobject_get(&kobj->kset->kobj);
+		} else {
+			error = -EINVAL;
+			goto out;
+		}
 	}
 	/* old object path */
 	devpath = kobject_get_path(kobj, GFP_KERNEL);
-- 
1.5.4.3

