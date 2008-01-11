Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbYAKN2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbYAKN2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 08:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbYAKN2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 08:28:08 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:44003 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758832AbYAKN2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 08:28:07 -0500
Date: Fri, 11 Jan 2008 14:28:04 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Jeremy Kerr <jk@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ps3fb: fix deadlock on kexec()
In-Reply-To: <Pine.LNX.4.64.0801111417450.12038@vixen.sonytel.be>
Message-ID: <Pine.LNX.4.64.0801111427160.12536@vixen.sonytel.be>
References: <Pine.LNX.4.64.0801111417450.12038@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-166629635-1200058084=:12536"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-166629635-1200058084=:12536
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

From: Jeremy Kerr <jk@ozlabs.org>

Since the introduction of the acquire_console_sem calls in
0333d83509c7d8496c8965b5ba9bc0c98e83c259, kexecing can cause the
kernel to deadlock:

 ps3fb_shutdown()
  -> unregister_framebuffer()
  -> fb_notifier_call_chain(FB_EVENT_FB_UNBIND)
  -> fbcon_fb_unbind()
  -> unbind_con_driver()
  -> bind_con_driver()
	[ acquires console_sem ]
  -> fbcon_deinit()
  -> fbops->fb_release(newinfo, 0)
  -> ps3fb_release()
  -> ps3fb_sync()
	[ acquires console_sem ]

This change avoids the deadlock by moving the acquire_console_sem()
out of ps3fb_sync(), and puts it into the two other callsites, leaving
ps3fb_release() to call ps3fb_sync() without the console semaphore.

[Geert]
  - Corrected call sequence above
  - ps3fb_release() may be called with and without console_sem held. This is an
    inconsistency that should be fixed at the fb level, but for now, try to
    acquire console_sem in ps3fb_release().

    I think it's safer to let ps3fb_release() try to acquire console_sem and
    not refresh the screen if it fails, than to call ps3fb_sync() without
    holding console_sem, as ps3fb_par may be modified at the same time, causing
    crashes or lockups.

    Besides, ps3fb_release() only calls ps3fb_sync() to refresh the screen
    when display flipping is disabled, which is an uncommon case (except during
    shutdown/kexec).

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/video/ps3fb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -443,8 +443,6 @@ static int ps3fb_sync(struct fb_info *in
 	u32 ddr_line_length, xdr_line_length;
 	u64 ddr_base, xdr_base;
 
-	acquire_console_sem();
-
 	if (frame > par->num_frames - 1) {
 		dev_dbg(info->device, "%s: invalid frame number (%u)\n",
 			__func__, frame);
@@ -464,7 +462,6 @@ static int ps3fb_sync(struct fb_info *in
 			 xdr_line_length);
 
 out:
-	release_console_sem();
 	return error;
 }
 
@@ -479,7 +476,10 @@ static int ps3fb_release(struct fb_info 
 	if (atomic_dec_and_test(&ps3fb.f_count)) {
 		if (atomic_read(&ps3fb.ext_flip)) {
 			atomic_set(&ps3fb.ext_flip, 0);
-			ps3fb_sync(info, 0);	/* single buffer */
+			if (!try_acquire_console_sem()) {
+				ps3fb_sync(info, 0);	/* single buffer */
+				release_console_sem();
+			}
 		}
 	}
 	return 0;
@@ -865,7 +865,9 @@ static int ps3fb_ioctl(struct fb_info *i
 			break;
 
 		dev_dbg(info->device, "PS3FB_IOCTL_FSEL:%d\n", val);
+		acquire_console_sem();
 		retval = ps3fb_sync(info, val);
+		release_console_sem();
 		break;
 
 	default:
@@ -885,7 +887,9 @@ static int ps3fbd(void *arg)
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (ps3fb.is_kicked) {
 			ps3fb.is_kicked = 0;
+			acquire_console_sem();
 			ps3fb_sync(info, 0);	/* single buffer */
+			release_console_sem();
 		}
 		schedule();
 	}

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-166629635-1200058084=:12536--
