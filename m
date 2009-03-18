Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZCRS0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZCRS0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZCRS0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:26:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZCRS0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:26:04 -0400
Subject: [PATCH] make inotify event handles use GFP_NOFS
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, aviro@redhat.com
Content-Type: text/plain
Date: Wed, 18 Mar 2009 14:27:32 -0400
Message-Id: <1237400852.26799.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is a bandaide to shut up lockdep.  I could either figure
out lockdep classes and figure out how to reclassify inotify locks since
I believe Nick is correct when he says inotify watches pin the inode in
core so memory pressure can't evict it.  I don't want to do that as I
think the real fix is my next generation fsnotify which does zero
allocations under locks and so everything can be GFP_KERNEL.  I'm
posting this as it is clearly safe and should fix the issue.

http://marc.info/?l=linux-kernel&m=123617147432377&w=2

includes a lockdep warning that shows while we are reclaiming FS memory
and inode may get evicted which generates an IN_IGNORED message.  Half
of that code path already used GFP_NOFS but a second allocation to store
the filename was using GFP_KERNEL.  As a precaution I also moved the
audit handle_event code path to use GFP_NOFS.

This is much the same as the precaution in f04b30de3c82528 which did
something similar.

Signed-off-by: Eric Paris <eparis@redhat.com>

---

 fs/notify/inotify/inotify_user.c |    2 +-
 kernel/auditfilter.c             |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index bed766e..1634319 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -220,7 +220,7 @@ static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
 				rem = 0;
 		}
 
-		kevent->name = kmalloc(len + rem, GFP_KERNEL);
+		kevent->name = kmalloc(len + rem, GFP_NOFS);
 		if (unlikely(!kevent->name)) {
 			kmem_cache_free(event_cachep, kevent);
 			return NULL;
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index fbf24d1..a3fa2c0 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1028,7 +1028,7 @@ static void audit_update_watch(struct audit_parent *parent,
 
 		if (audit_enabled) {
 			struct audit_buffer *ab;
-			ab = audit_log_start(NULL, GFP_KERNEL,
+			ab = audit_log_start(NULL, GFP_NOFS,
 				AUDIT_CONFIG_CHANGE);
 			audit_log_format(ab, "auid=%u ses=%u",
 				audit_get_loginuid(current),
@@ -1067,7 +1067,7 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
 			e = container_of(r, struct audit_entry, rule);
 			if (audit_enabled) {
 				struct audit_buffer *ab;
-				ab = audit_log_start(NULL, GFP_KERNEL,
+				ab = audit_log_start(NULL, GFP_NOFS,
 					AUDIT_CONFIG_CHANGE);
 				audit_log_format(ab, "auid=%u ses=%u",
 					audit_get_loginuid(current),


