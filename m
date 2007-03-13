Return-Path: <linux-kernel-owner+w=401wt.eu-S933316AbXCMVJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316AbXCMVJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXCMVJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:09:17 -0400
Received: from mail.tpi.com ([198.107.51.143]:1429 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933316AbXCMVJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:09:16 -0400
X-Greylist: delayed 2309 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 17:09:16 EDT
Message-ID: <45F709F2.80504@canonical.com>
Date: Tue, 13 Mar 2007 14:30:42 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Suspend to RAM fault in VT when resuming
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------000704060604010706010803"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000704060604010706010803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pavel,

I've chased one of the 'Suspend to RAM' resume problems to a specific
line in drivers/char/vt.c, see attached 2.6.21-rc3 diff with
TRACE_RESUME() instrumentation. The macro scr_writew resolves to '*addr
= val', which appears to be causing the problem. I've verified that the
pointer is not NULL, but don't know if its really valid. Its pretty
tough to tell what is happening, but on a Dell XPS it just hangs. A Dell
Precision blinks the keyboard lights.

Since I don't know anything about video programming, I though perhaps
you might have an opinion.

rtg
-- 
Tim Gardner tim.gardner@ubuntu.com

--------------000704060604010706010803
Content-Type: text/x-patch;
 name="vt.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vt.diff"

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index c3f8e38..43a0904 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -98,6 +98,7 @@
 #include <linux/pm.h>
 #include <linux/font.h>
 #include <linux/bitops.h>
+#include <linux/resume-trace.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -2263,7 +2264,9 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
 			if (c == 10 || c == 13)
 				continue;
 		}
+TRACE_RESUME(0);
 		scr_writew((vc->vc_attr << 8) + c, (unsigned short *)vc->vc_pos);
+TRACE_RESUME(0);
 		cnt++;
 		if (myx == vc->vc_cols - 1) {
 			vc->vc_need_wrap = 1;

--------------000704060604010706010803--
