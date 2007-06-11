Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbXFKOpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbXFKOpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbXFKOpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:45:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38725 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbXFKOpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:45:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] swsusp: Fix userland interface
Date: Mon, 11 Jun 2007 16:52:01 +0200
User-Agent: KMail/1.9.5
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111652.01994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[2.6.22 candidate, IMHO]
---
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix oops caused by 'cat /dev/snapshot', reported by Arkadiusz Miskiewicz, and
make it impossible to thaw tasks with the help of the swsusp userland interface
while there is a snapshot image ready to save.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4/kernel/power/user.c
===================================================================
--- linux-2.6.22-rc4.orig/kernel/power/user.c	2007-06-10 19:33:36.000000000 +0200
+++ linux-2.6.22-rc4/kernel/power/user.c	2007-06-10 19:35:59.000000000 +0200
@@ -99,6 +99,8 @@ static ssize_t snapshot_read(struct file
 	ssize_t res;
 
 	data = filp->private_data;
+	if (!data->ready)
+		return -ENODATA;
 	res = snapshot_read_next(&data->handle, count);
 	if (res > 0) {
 		if (copy_to_user(buf, data_of(data->handle), res))
@@ -163,7 +165,7 @@ static int snapshot_ioctl(struct inode *
 		break;
 
 	case SNAPSHOT_UNFREEZE:
-		if (!data->frozen)
+		if (!data->frozen || data->ready)
 			break;
 		mutex_lock(&pm_mutex);
 		thaw_processes();
