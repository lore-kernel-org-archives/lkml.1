Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXGRHco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXGRHco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXGRHcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:32:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52601 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbXGRHcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:32:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/5] Freezer: Document relationship with memory shrinking
Date: Wed, 18 Jul 2007 09:30:44 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>
References: <200707180929.31511.rjw@sisk.pl>
In-Reply-To: <200707180929.31511.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707180930.45564.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

One important reason to freeze tasks, which is that we don't want them to
allocate memory after freeing it for the hibernation image, has not been
documented.  Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 Documentation/power/freezing-of-tasks.txt |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc6-mm1/Documentation/power/freezing-of-tasks.txt
===================================================================
--- linux-2.6.22-rc6-mm1.orig/Documentation/power/freezing-of-tasks.txt	2007-07-11 20:48:04.000000000 +0200
+++ linux-2.6.22-rc6-mm1/Documentation/power/freezing-of-tasks.txt	2007-07-11 20:50:24.000000000 +0200
@@ -81,7 +81,16 @@ hibernation image has been created and b
 The majority of these are user space processes, but if any of the kernel threads
 may cause something like this to happen, they have to be freezable.
 
-2. The second reason is to prevent user space processes and some kernel threads
+2. Next, to create the hibernation image we need to free a sufficient amount of
+memory (approximately 50% of available RAM) and we need to do that before
+devices are deactivated, because we generally need them for swapping out.  Then,
+after the memory for the image has been freed, we don't want tasks to allocate
+additional memory and we prevent them from doing that by freezing them earlier.
+[Of course, this also means that device drivers should not allocate substantial
+amounts of memory from their .suspend() callbacks before hibernation, but this
+is e separate issue.]
+
+3. The third reason is to prevent user space processes and some kernel threads
 from interfering with the suspending and resuming of devices.  A user space
 process running on a second CPU while we are suspending devices may, for
 example, be troublesome and without the freezing of tasks we would need some
@@ -111,7 +120,7 @@ frozen before the driver's .suspend() ca
 thawed after the driver's .resume() callback has run, so it won't be accessing
 the device while it's suspended.
 
-3. Another reason for freezing tasks is to prevent user space processes from
+4. Another reason for freezing tasks is to prevent user space processes from
 realizing that hibernation (or suspend) operation takes place.  Ideally, user
 space processes should not notice that such a system-wide operation has occurred
 and should continue running without any problems after the restore (or resume

