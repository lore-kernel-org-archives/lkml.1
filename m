Return-Path: <linux-kernel-owner+w=401wt.eu-S1422927AbXCGRdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422927AbXCGRdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422847AbXCGRQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:16:43 -0500
Received: from ns1.suse.de ([195.135.220.2]:43969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422822AbXCGRP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:58 -0500
Message-Id: <20070307171416.481686283@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stefan Seyfried <seife@suse.de>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 054/101] swsusp: Fix possible oops in userland interface
Content-Disposition: inline; filename=swsusp-fix-possible-oops-in-userland-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Seyfried <seife@suse.de>

Fix the Oops occuring when SNAPSHOT_PMOPS or SNAPSHOT_S2RAM ioctl is called on
a system without pm_ops defined (eg. a non-ACPI kernel on x86 PC).

Signed-off-by: Stefan Seyfried <seife@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/power/user.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- linux-2.6.20.1.orig/kernel/power/user.c
+++ linux-2.6.20.1/kernel/power/user.c
@@ -292,7 +292,7 @@ static int snapshot_ioctl(struct inode *
 			break;
 		}
 
-		if (pm_ops->prepare) {
+		if (pm_ops && pm_ops->prepare) {
 			error = pm_ops->prepare(PM_SUSPEND_MEM);
 			if (error)
 				goto OutS3;
@@ -311,7 +311,7 @@ static int snapshot_ioctl(struct inode *
 			device_resume();
 		}
 		resume_console();
-		if (pm_ops->finish)
+		if (pm_ops && pm_ops->finish)
 			pm_ops->finish(PM_SUSPEND_MEM);
 
  OutS3:
@@ -322,20 +322,25 @@ static int snapshot_ioctl(struct inode *
 		switch (arg) {
 
 		case PMOPS_PREPARE:
-			if (pm_ops->prepare) {
+			if (pm_ops && pm_ops->prepare)
 				error = pm_ops->prepare(PM_SUSPEND_DISK);
-			}
+			else
+				error = -ENOSYS;
 			break;
 
 		case PMOPS_ENTER:
 			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-			error = pm_ops->enter(PM_SUSPEND_DISK);
+			if (pm_ops && pm_ops->enter)
+				error = pm_ops->enter(PM_SUSPEND_DISK);
+			else
+				error = -ENOSYS;
 			break;
 
 		case PMOPS_FINISH:
-			if (pm_ops && pm_ops->finish) {
+			if (pm_ops && pm_ops->finish)
 				pm_ops->finish(PM_SUSPEND_DISK);
-			}
+			else
+				error = -ENOSYS;
 			break;
 
 		default:

--
