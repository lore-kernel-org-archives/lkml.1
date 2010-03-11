Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0CKKlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:41:06 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:15475 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab0CKKlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 05:41:03 -0500
Message-ID: <4B98C7ED.607@openvz.org>
Date: Thu, 11 Mar 2010 13:37:33 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: [PATCH] inotify: Don't leak user struct on inotify release
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inotify_new_group receives a get_uid-ed user_struct and saves the
reference on group->inotify_data.user. The problem is that the free_uid
is never called on it.

Issue seem to be introduced by 63c882a0 (inotify: reimplement inotify 
using fsnotify) after 2.6.30 (so stable is in Cc)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 1afb0a1..e27960c 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -28,6 +28,7 @@
 #include <linux/path.h> /* struct path */
 #include <linux/slab.h> /* kmem_* */
 #include <linux/types.h>
+#include <linux/sched.h>
 
 #include "inotify.h"
 
@@ -146,6 +147,7 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_remove_all(&group->inotify_data.idr);
 	idr_destroy(&group->inotify_data.idr);
+	free_uid(group->inotify_data.user);
 }
 
 void inotify_free_event_priv(struct fsnotify_event_private_data *fsn_event_priv)
