Return-Path: <linux-kernel-owner+w=401wt.eu-S934072AbXCTV1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbXCTV1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXCTV1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:27:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55057 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbXCTV0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:26:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] swsusp: fix error paths in snapshot_open
Date: Tue, 20 Mar 2007 22:26:42 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
References: <200703122214.02657.rjw@sisk.pl> <20070319173127.72c3419d.akpm@linux-foundation.org> <200703202218.16820.rjw@sisk.pl>
In-Reply-To: <200703202218.16820.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202226.42673.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

We forget to increase device_available if there's an error in
snapshot_open(), so the snapshot device cannot be open at all after
snapshot_open() has returned an error.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/user.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.21-rc4-mm1/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/power/user.c	2007-03-20 21:19:31.000000000 +0100
+++ linux-2.6.21-rc4-mm1/kernel/power/user.c	2007-03-20 21:35:59.000000000 +0100
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

