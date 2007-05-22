Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbXEVVpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbXEVVpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934316AbXEVVo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:44:58 -0400
Received: from outbound-mail-63.bluehost.com ([69.89.21.23]:46576 "HELO
	outbound-mail-63.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758520AbXEVVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:44:57 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: [PATCH 2/2] make fbcon unregister when unloaded
Date: Tue, 22 May 2007 14:44:52 -0700
User-Agent: KMail/1.9.6
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>
References: <200705171423.46748.jesse.barnes@intel.com> <200705171532.28799.jesse.barnes@intel.com> <1179444190.5092.4.camel@daplas>
In-Reply-To: <1179444190.5092.4.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221444.52675.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 17, 2007, Antonino A. Daplas wrote:
> On Thu, 2007-05-17 at 15:32 -0700, Jesse Barnes wrote:
> > Randy just informed me that the patch limits are bigger now, so here
> > are the actual patches.
> >
> > This patch allows for proper console unregistration via the VT layer,
> > and updates the FB layer to use it.  This makes debugging new console
> > drivers much easier, since you can properly clean them up before
> > unloading. Antonio already checked it out (and suggested a tweak for
> > the fbcon side) so I think it's on its way already via the FB tree.
>
> Sorry, I was busy and got sidetracked so I wasn't able to work on this
> for 2 weeks.  Yes, this should work for now, at least for debugging
> purposes. I'll work on refining on fbcon side, hopefully for
> 2.6.22-2.6.23 time frame.

When unloaded, the fbcon driver should unregister itself from the VT
subsystem using unbind_con_driver.  This patch makes it use the newly
exported function to do just that.

Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

diff -Napur -X /home/jbarnes/dontdiff --exclude=Makefile linux-2.6.22-rc2/drivers/video/console/fbcon.c linux-2.6.22-rc2-modesetting/drivers/video/console/fbcon.c
--- linux-2.6.22-rc2/drivers/video/console/fbcon.c	2007-05-18 21:06:17.000000000 -0700
+++ linux-2.6.22-rc2-modesetting/drivers/video/console/fbcon.c	2007-05-22 14:26:20.000000000 -0700
@@ -2937,6 +2937,21 @@ static int fbcon_mode_deleted(struct fb_
 	return found;
 }
 
+static int fbcon_fb_unbind(int idx)
+{
+	int i;
+
+        for (i = 0; i < MAX_NR_CONSOLES; i++) {
+                /* Assure we do not unbind other drivers */
+                if (idx == con2fb_map[i])
+                        /* can be optimize to minimize multiple calls to
+			   unbind_con_driver() */
+                        unbind_con_driver(&fb_con, i, i, 0); 
+        }
+
+	return 0;
+}
+
 static int fbcon_fb_unregistered(int idx)
 {
 	int i;
@@ -3114,6 +3129,9 @@ static int fbcon_event_notify(struct not
 		mode = event->data;
 		ret = fbcon_mode_deleted(info, mode);
 		break;
+	case FB_EVENT_FB_UNBIND:
+		ret = fbcon_fb_unbind(info->node);
+		break;
 	case FB_EVENT_FB_REGISTERED:
 		ret = fbcon_fb_registered(info->node);
 		break;
diff -Napur -X /home/jbarnes/dontdiff --exclude=Makefile linux-2.6.22-rc2/drivers/video/fbmem.c linux-2.6.22-rc2-modesetting/drivers/video/fbmem.c
--- linux-2.6.22-rc2/drivers/video/fbmem.c	2007-05-18 21:06:17.000000000 -0700
+++ linux-2.6.22-rc2-modesetting/drivers/video/fbmem.c	2007-05-22 14:10:35.000000000 -0700
@@ -1400,6 +1400,8 @@ unregister_framebuffer(struct fb_info *f
 	if (!registered_fb[i])
 		return -EINVAL;
 
+	event.info = fb_info;
+	fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
 	if (fb_info->pixmap.addr &&
 	    (fb_info->pixmap.flags & FB_PIXMAP_DEFAULT))
 		kfree(fb_info->pixmap.addr);
diff -Napur -X /home/jbarnes/dontdiff --exclude=Makefile linux-2.6.22-rc2/include/linux/fb.h linux-2.6.22-rc2-modesetting/include/linux/fb.h
--- linux-2.6.22-rc2/include/linux/fb.h	2007-05-18 21:06:17.000000000 -0700
+++ linux-2.6.22-rc2-modesetting/include/linux/fb.h	2007-05-22 14:11:00.000000000 -0700
@@ -529,6 +529,9 @@ struct fb_cursor_user {
 #define FB_EVENT_CONBLANK               0x0C
 /*      Get drawing requirements        */
 #define FB_EVENT_GET_REQ                0x0D
+/*      Unbind from the console if possible */
+#define FB_EVENT_FB_UNBIND              0x0E
+
 
 struct fb_event {
 	struct fb_info *info;
