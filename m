Return-Path: <linux-kernel-owner+w=401wt.eu-S1161690AbXEAKWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161690AbXEAKWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161686AbXEAKWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:22:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161677AbXEAKWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:22:36 -0400
Subject: [GFS2] bz 236008: Kernel gpf doing cat /debugfs/gfs2/xxx (lock
	dump) [24/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Robert Peterson <rpeterso@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:18:02 +0100
Message-Id: <1178014682.5462.177.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7a0079d9e3fe8826475a08785f3d348c4b509774 Mon Sep 17 00:00:00 2001
From: Robert Peterson <rpeterso@redhat.com>
Date: Tue, 17 Apr 2007 11:37:11 -0500
Subject: [PATCH] [GFS2] bz 236008: Kernel gpf doing cat /debugfs/gfs2/xxx (lock dump)

This is for Bugzilla Bug 236008: Kernel gpf doing cat /debugfs/gfs2/xxx
(lock dump) seen at the "gfs2 summit".  This also fixes the bug that caused
garbage to be printed by the "initialized at" field.  I apologize for the
kludge, but that code will all be ripped out anyway when the official
sprint_symbol function becomes available in the Linux kernel.  I also
changed some formatting so that spaces are replaced by proper tabs.

Signed-off-by: Robert Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index d2e3094..b075f93 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1765,15 +1765,20 @@ static void gfs2_print_symbol(struct glock_iter *gi, const char *fmt,
 {
 /* when sprint_symbol becomes available in the new kernel, replace this */
 /* function with:
-        char buffer[KSYM_SYMBOL_LEN];
+	char buffer[KSYM_SYMBOL_LEN];
 
-        sprint_symbol(buffer, address);
-        print_dbg(gi, fmt, buffer);
+	sprint_symbol(buffer, address);
+	print_dbg(gi, fmt, buffer);
 */
-        if (gi)
-                print_dbg(gi, fmt, address);
-        else
-                print_symbol(fmt, address);
+	char buffer[256];
+
+	if (gi) {
+		memset(buffer, 0, sizeof(buffer));
+		sprintf(buffer, "%p", address);
+		print_dbg(gi, fmt, buffer);
+	}
+	else
+		print_symbol(fmt, address);
 }
 
 /**
@@ -1993,14 +1998,19 @@ int __init gfs2_glock_init(void)
 
 static int gfs2_glock_iter_next(struct glock_iter *gi)
 {
+	read_lock(gl_lock_addr(gi->hash));
 	while (1) {
 		if (!gi->hb_list) {  /* If we don't have a hash bucket yet */
 			gi->hb_list = &gl_hash_table[gi->hash].hb_list;
 			if (hlist_empty(gi->hb_list)) {
+				read_unlock(gl_lock_addr(gi->hash));
 				gi->hash++;
+				read_lock(gl_lock_addr(gi->hash));
 				gi->hb_list = NULL;
-				if (gi->hash >= GFS2_GL_HASH_SIZE)
+				if (gi->hash >= GFS2_GL_HASH_SIZE) {
+					read_unlock(gl_lock_addr(gi->hash));
 					return 1;
+				}
 				else
 					continue;
 			}
@@ -2011,7 +2021,9 @@ static int gfs2_glock_iter_next(struct glock_iter *gi)
 			}
 		} else {
 			if (gi->gl->gl_list.next == NULL) {
+				read_unlock(gl_lock_addr(gi->hash));
 				gi->hash++;
+				read_lock(gl_lock_addr(gi->hash));
 				gi->hb_list = NULL;
 				continue;
 			}
@@ -2021,6 +2033,7 @@ static int gfs2_glock_iter_next(struct glock_iter *gi)
 		if (gi->gl)
 			break;
 	}
+	read_unlock(gl_lock_addr(gi->hash));
 	return 0;
 }
 
-- 
1.5.1.2



