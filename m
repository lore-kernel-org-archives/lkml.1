Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbXEOU44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbXEOU44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbXEOU4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:56:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbXEOU4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:56:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] swsusp: Fix sysfs interface
Date: Tue, 15 May 2007 23:02:01 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Peter Moulder <Peter.Moulder@infotech.monash.edu.au>,
       Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705152302.02048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The sysfs files /sys/power/disk and /sys/power/state do not work as documented,
since they allow the user to write only a few initial characters of the
input string to trigger the option (eg. 'echo pl > /sys/power/disk' activates
the platform mode of hibernation).  Fix it.

Special thanks to Peter Moulder <Peter.Moulder@infotech.monash.edu.au> for
pointing out the problem.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/disk.c |    3 ++-
 kernel/power/main.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.21/kernel/power/disk.c
===================================================================
--- linux-2.6.21.orig/kernel/power/disk.c	2007-05-11 12:06:28.000000000 +0200
+++ linux-2.6.21/kernel/power/disk.c	2007-05-11 12:06:33.000000000 +0200
@@ -416,7 +416,8 @@ static ssize_t disk_store(struct subsyst
 
 	mutex_lock(&pm_mutex);
 	for (i = HIBERNATION_FIRST; i <= HIBERNATION_MAX; i++) {
-		if (!strncmp(buf, hibernation_modes[i], len)) {
+		if (len == strlen(hibernation_modes[i])
+		    && !strncmp(buf, hibernation_modes[i], len)) {
 			mode = i;
 			break;
 		}
Index: linux-2.6.21/kernel/power/main.c
===================================================================
--- linux-2.6.21.orig/kernel/power/main.c	2007-05-11 12:06:28.000000000 +0200
+++ linux-2.6.21/kernel/power/main.c	2007-05-11 12:07:02.000000000 +0200
@@ -289,13 +289,13 @@ static ssize_t state_store(struct subsys
 	len = p ? p - buf : n;
 
 	/* First, check if we are requested to hibernate */
-	if (!strncmp(buf, "disk", len)) {
+	if (len == 4 && !strncmp(buf, "disk", len)) {
 		error = hibernate();
 		return error ? error : n;
 	}
 
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
-		if (*s && !strncmp(buf, *s, len))
+		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
 			break;
 	}
 	if (state < PM_SUSPEND_MAX && *s)
