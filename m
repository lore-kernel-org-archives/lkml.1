Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXCQW0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXCQW0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 18:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXCQW0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 18:26:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41616 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbXCQW0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 18:26:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/2] swsusp: Fix error paths in snapshot_open
Date: Sat, 17 Mar 2007 23:24:35 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <200703172322.33079.rjw@sisk.pl>
In-Reply-To: <200703172322.33079.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703172324.35833.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

We forget to increase device_available if there's an error in snapshot_open(),
so the snapshot device cannot be open at all after snapshot_open() has returned
an error.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.21-rc4/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc4.orig/kernel/power/user.c
+++ linux-2.6.21-rc4/kernel/power/user.c
@@ -49,12 +49,14 @@ static int snapshot_open(struct inode *i
 	if (!atomic_add_unless(&device_available, -1, 0))
 		return -EBUSY;
 
-	if ((filp->f_flags & O_ACCMODE) == O_RDWR)
+	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
+		atomic_inc(&device_available);
 		return -ENOSYS;
-
-	if(create_basic_memory_bitmaps())
+	}
+	if(create_basic_memory_bitmaps()) {
+		atomic_inc(&device_available);
 		return -ENOMEM;
-
+	}
 	nonseekable_open(inode, filp);
 	data = &snapshot_state;
 	filp->private_data = data;

