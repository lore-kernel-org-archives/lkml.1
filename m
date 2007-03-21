Return-Path: <linux-kernel-owner+w=401wt.eu-S965459AbXCUX6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbXCUX6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965415AbXCUX6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:58:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56841 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965410AbXCUX6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:58:44 -0400
Date: Thu, 22 Mar 2007 00:58:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: fix extra BIOS invocation during resume
Message-ID: <20070321235838.GA6547@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It causes extra moon icons blinking on x60, and breaks at least two
other systems.

During resume, we do not know that "reboot"/"shutdown" method was
used, so we assume "plaform" and call BIOS, anyway...

This is 2.6.21 material, and should fix 2 or 3 regressions from 2.6.20.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by:  "Rafael J. Wysocki" <rjw@sisk.pl>


 kernel/power/disk.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 873cdf8..dee0ff4 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -241,18 +241,11 @@ static int software_resume(void)
 		goto Done;
 	}
 
-	error = platform_prepare();
-	if (error) {
-		swsusp_free();
-		goto Thaw;
-	}
-
 	pr_debug("PM: Reading swsusp image.\n");
 
 	error = swsusp_read();
 	if (error) {
 		swsusp_free();
-		platform_finish();
 		goto Thaw;
 	}
 
@@ -270,7 +263,6 @@ static int software_resume(void)
 	enable_nonboot_cpus();
  Free:
 	swsusp_free();
-	platform_finish();
 	device_resume();
 	resume_console();
  Thaw:


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
