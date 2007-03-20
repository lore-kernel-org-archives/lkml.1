Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXCTMcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXCTMcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 08:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXCTMcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 08:32:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56986 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933045AbXCTMcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 08:32:52 -0400
Date: Tue, 20 Mar 2007 13:32:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: "reboot" swsusp mode leaves moon icon blinking
Message-ID: <20070320123245.GA19019@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

...and cause is really simple.

During resume, we do not know that "reboot" method was used, so we
assume plaform and make the led blink...

Unfortunately I see no easy solution, and this may/will cause other
problems -- in case of broken bios and user telling us not to call
that bios, we'll call it anyway.

(Ouch and I think this is regression after 2.6.20?)

Signed-off-by: Pavel Machek <pavel@suse.cz>

								Pavel

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
