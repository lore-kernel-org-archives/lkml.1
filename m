Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZJBCBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZJBCBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZJBCBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:01:20 -0400
Received: from kroah.org ([198.145.64.141]:32909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbZJBBce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:07 2009
Message-Id: <20091002012407.685873743@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Armstrong <ian@iarmst.demon.co.uk>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [013/136] fbcon: only unbind from console if successfully registered
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=fbcon-only-unbind-from-console-if-successfully-registered.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ian Armstrong <ian@iarmst.demon.co.uk>

commit 2ddce3fd0acbdc1be684fb5f919ae3d2e9518aac upstream.

Attempting to unload a framebuffer module calls unregister_framebuffer()
which in turn gets fbcon to release it.  If fbcon has no framebuffers
linked to a console, it will also unbind itself from the console driver.
However, if fbcon never registered itself as a console driver, the unbind
will fail causing the framebuffer device entry to persist.  In most cases
this failure will result in an oops when attempting to access the now
non-existent device.

This patch ensures that the fbcon unbind request will succeed even if a
bind was never done.  It tracks if a successful bind ever occurred & will
only attempt to unbind if needed.  If there never was a bind, it simply
returns with no error.

Signed-off-by: Ian Armstrong <ian@iarmst.demon.co.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/console/fbcon.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -114,6 +114,7 @@ static int last_fb_vc = MAX_NR_CONSOLES 
 static int fbcon_is_default = 1; 
 static int fbcon_has_exited;
 static int primary_device = -1;
+static int fbcon_has_console_bind;
 
 #ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
 static int map_override;
@@ -544,6 +545,8 @@ static int fbcon_takeover(int show_logo)
 			con2fb_map[i] = -1;
 		}
 		info_idx = -1;
+	} else {
+		fbcon_has_console_bind = 1;
 	}
 
 	return err;
@@ -2923,6 +2926,10 @@ static int fbcon_unbind(void)
 
 	ret = unbind_con_driver(&fb_con, first_fb_vc, last_fb_vc,
 				fbcon_is_default);
+
+	if (!ret)
+		fbcon_has_console_bind = 0;
+
 	return ret;
 }
 #else
@@ -2936,6 +2943,9 @@ static int fbcon_fb_unbind(int idx)
 {
 	int i, new_idx = -1, ret = 0;
 
+	if (!fbcon_has_console_bind)
+		return 0;
+
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		if (con2fb_map[i] != idx &&
 		    con2fb_map[i] != -1) {


