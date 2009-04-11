Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZDKPEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZDKPEU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 11:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZDKPEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 11:04:08 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59380 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZDKPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 11:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=aBs6MTLiDpFA+4VbhexZV3EXuoTD2BSC1HlBRD2ZFja1S0VlgH4Sb5BASE0EixZ9Ls
         U4B6ZcX0vb99ys93DXDqk6gipRGMBXroStPzUYWf5uty6OO5GVzaCkgIciSOAOWfU8MJ
         zgOzmezaO5q/qJASpISnACgNdX7xDlGNcD2PA=
Date: Sat, 11 Apr 2009 17:04:00 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Pavel Roskin <proski@gnu.org>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and
	mm->mmap_sem ...} causes Xfbdev not working
Message-ID: <20090411150359.GA8265@linux>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Krzysztof Helt <krzysztof.h1@poczta.fm>,
	Eric Miao <eric.y.miao@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrey Borzenkov <arvidjaar@gmail.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	linux-fbdev-devel@lists.sourceforge.net,
	linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Pavel Roskin <proski@gnu.org>
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com> <20090409125850.GA2727@linux> <20090410222122.87be60f6.krzysztof.h1@poczta.fm> <20090410220521.GB21294@linux> <20090411080415.7fe924a2.krzysztof.h1@poczta.fm> <49E05C36.9040204@s5r6.in-berlin.de> <20090411110840.GA7108@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411110840.GA7108@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 01:08:41PM +0200, Andrea Righi wrote:
> On Sat, Apr 11, 2009 at 11:00:38AM +0200, Stefan Richter wrote:
> > Krzysztof Helt wrote:
> > > On Sat, 11 Apr 2009 00:05:22 +0200
> > > Andrea Righi <righi.andrea@gmail.com> wrote:
> > > 
> > >> mmmh... I may have missed something, but the common fb_mmap() should
> > >> acquire mm->mmap_sem and then info->lock, while fb_ioctl() can do that
> > >> in reverse order (info->lock first and then mm->mmap_sem) causing the
> > >> circular locking dependency. Are you sure that pushing info->lock down
> > >> each driver's fb_mmap will fix the problem?
> > > 
> > > Right. The fb_mmap is called with the mmap_sem already held.
> > > I will try other possibilities like breaking info->lock() into two
> > > mutexex.
> > 
> > I had to deal with interaction of mmap_sem with a driver lock twice yet.
> > I solved it cheaply by replacing mutex_lock(driver_mutex) by
> > mutex_trylock(driver_mutex).
> > 
> > The obvious drawback is that thic changes kernel behaviour visibly to
> > userspace:  Under contention, the ioctl/read/write fails with -EAGAIN
> > instead of being blocked until the other thread finished its
> > ioctl/read/write/mmap on the same fd (if the driver mutex is
> > instantiated per fd, like in my case).
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8449fc3ae58bf8ee5acbd2280754cde67b5db128
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=638570b54346f140bc09b986d93e76025d35180f
> > 
> > (In these two drivers, the change of behaviour is irrelevant to real
> > userspace clients.)
> 
> I've looked at the code again. I think the main problem here (at last
> the last one reported) is that fb_notifier_call_chain() is called with
> info->lock held, i.e. in do_fb_ioctl() => FBIOPUT_VSCREENINFO =>
> fb_set_var() and the some notifier callbacks, like fbcon_event_notify(),
> try to re-acquire info->lock again.
> 
> Probably we can just remove the lock/unlock_fb_info() in all the fb
> notifier callbacks' and be sure to always call fb_notifier_call_chain()
> with info->lock held.
> 
> Something like this (untested). I'll test it later and re-submit if it
> makes sense.

Tested intelfb and X11 with fbdev. It seems to work fine, but I may be
unable to test the mode switching right now:

  intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.

It would be great if someone could help me to test this patch (against
latest Linus' git - no need to revert 66c1ca).

Thanks,
-Andrea

---
fbdev: fix info->lock deadlock in fbcon_event_notify()

fb_notifier_call_chain() is called with info->lock held, i.e. in
do_fb_ioctl() => FBIOPUT_VSCREENINFO => fb_set_var() and the some
notifier callbacks, like fbcon_event_notify(), try to re-acquire
info->lock again.

Remove the lock/unlock_fb_info() in all the framebuffer notifier
callbacks' and be sure to always call fb_notifier_call_chain() with
info->lock held.

Reported-by: Pavel Roskin <proski@gnu.org>
Reported-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 drivers/video/backlight/backlight.c |    3 --
 drivers/video/backlight/lcd.c       |    3 --
 drivers/video/console/fbcon.c       |   55 ++---------------------------------
 drivers/video/fbmem.c               |   19 ++++++++++++
 4 files changed, 22 insertions(+), 58 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index dd37cbc..157057c 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -35,8 +35,6 @@ static int fb_notifier_callback(struct notifier_block *self,
 		return 0;
 
 	bd = container_of(self, struct backlight_device, fb_notif);
-	if (!lock_fb_info(evdata->info))
-		return -ENODEV;
 	mutex_lock(&bd->ops_lock);
 	if (bd->ops)
 		if (!bd->ops->check_fb ||
@@ -49,7 +47,6 @@ static int fb_notifier_callback(struct notifier_block *self,
 			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
-	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 0bb13df..b644947 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -40,8 +40,6 @@ static int fb_notifier_callback(struct notifier_block *self,
 	if (!ld->ops)
 		return 0;
 
-	if (!lock_fb_info(evdata->info))
-		return -ENODEV;
 	mutex_lock(&ld->ops_lock);
 	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
 		if (event == FB_EVENT_BLANK) {
@@ -53,7 +51,6 @@ static int fb_notifier_callback(struct notifier_block *self,
 		}
 	}
 	mutex_unlock(&ld->ops_lock);
-	unlock_fb_info(evdata->info);
 	return 0;
 }
 
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 2cd500a..471a9a6 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -2263,9 +2263,12 @@ static void fbcon_generic_blank(struct vc_data *vc, struct fb_info *info,
 	}
 
 
+	if (!lock_fb_info(info))
+		return;
 	event.info = info;
 	event.data = &blank;
 	fb_notifier_call_chain(FB_EVENT_CONBLANK, &event);
+	unlock_fb_info(info);
 }
 
 static int fbcon_blank(struct vc_data *vc, int blank, int mode_switch)
@@ -2956,8 +2959,6 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 {
 	int i, idx;
 
-	if (!lock_fb_info(info))
-		return -ENODEV;
 	idx = info->node;
 	for (i = first_fb_vc; i <= last_fb_vc; i++) {
 		if (con2fb_map[i] == idx)
@@ -2985,8 +2986,6 @@ static int fbcon_fb_unregistered(struct fb_info *info)
 	if (primary_device == idx)
 		primary_device = -1;
 
-	unlock_fb_info(info);
-
 	if (!num_registered_fb)
 		unregister_con_driver(&fb_con);
 
@@ -3027,11 +3026,8 @@ static int fbcon_fb_registered(struct fb_info *info)
 {
 	int ret = 0, i, idx;
 
-	if (!lock_fb_info(info))
-		return -ENODEV;
 	idx = info->node;
 	fbcon_select_primary(info);
-	unlock_fb_info(info);
 
 	if (info_idx == -1) {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
@@ -3152,53 +3148,23 @@ static int fbcon_event_notify(struct notifier_block *self,
 
 	switch(action) {
 	case FB_EVENT_SUSPEND:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_suspended(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_RESUME:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_resumed(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_modechanged(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_CHANGE_ALL:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_set_all_vcs(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_MODE_DELETE:
 		mode = event->data;
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		ret = fbcon_mode_deleted(info, mode);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_FB_UNBIND:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		idx = info->node;
-		unlock_fb_info(info);
 		ret = fbcon_fb_unbind(idx);
 		break;
 	case FB_EVENT_FB_REGISTERED:
@@ -3217,29 +3183,14 @@ static int fbcon_event_notify(struct notifier_block *self,
 		con2fb->framebuffer = con2fb_map[con2fb->console - 1];
 		break;
 	case FB_EVENT_BLANK:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_fb_blanked(info, *(int *)event->data);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_NEW_MODELIST:
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_new_modelist(info);
-		unlock_fb_info(info);
 		break;
 	case FB_EVENT_GET_REQ:
 		caps = event->data;
-		if (!lock_fb_info(info)) {
-			ret = -ENODEV;
-			goto done;
-		}
 		fbcon_get_requirement(info, caps);
-		unlock_fb_info(info);
 		break;
 	}
 done:
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 2ac32e6..d412a1d 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1097,8 +1097,11 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			return -EINVAL;
 		con2fb.framebuffer = -1;
 		event.data = &con2fb;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		event.info = info;
 		fb_notifier_call_chain(FB_EVENT_GET_CONSOLE_MAP, &event);
+		unlock_fb_info(info);
 		ret = copy_to_user(argp, &con2fb, sizeof(con2fb)) ? -EFAULT : 0;
 		break;
 	case FBIOPUT_CON2FBMAP:
@@ -1115,8 +1118,11 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 			break;
 		}
 		event.data = &con2fb;
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		event.info = info;
 		ret = fb_notifier_call_chain(FB_EVENT_SET_CONSOLE_MAP, &event);
+		unlock_fb_info(info);
 		break;
 	case FBIOBLANK:
 		if (!lock_fb_info(info))
@@ -1521,7 +1527,10 @@ register_framebuffer(struct fb_info *fb_info)
 	registered_fb[i] = fb_info;
 
 	event.info = fb_info;
+	if (!lock_fb_info(fb_info))
+		return -ENODEV;
 	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
+	unlock_fb_info(fb_info);
 	return 0;
 }
 
@@ -1555,8 +1564,12 @@ unregister_framebuffer(struct fb_info *fb_info)
 		goto done;
 	}
 
+
+	if (!lock_fb_info(fb_info))
+		return -ENODEV;
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
+	unlock_fb_info(fb_info);
 
 	if (ret) {
 		ret = -EINVAL;
@@ -1590,6 +1603,8 @@ void fb_set_suspend(struct fb_info *info, int state)
 {
 	struct fb_event event;
 
+	if (!lock_fb_info(info))
+		return;
 	event.info = info;
 	if (state) {
 		fb_notifier_call_chain(FB_EVENT_SUSPEND, &event);
@@ -1598,6 +1613,7 @@ void fb_set_suspend(struct fb_info *info, int state)
 		info->state = FBINFO_STATE_RUNNING;
 		fb_notifier_call_chain(FB_EVENT_RESUME, &event);
 	}
+	unlock_fb_info(info);
 }
 
 /**
@@ -1667,8 +1683,11 @@ int fb_new_modelist(struct fb_info *info)
 	err = 1;
 
 	if (!list_empty(&info->modelist)) {
+		if (!lock_fb_info(info))
+			return -ENODEV;
 		event.info = info;
 		err = fb_notifier_call_chain(FB_EVENT_NEW_MODELIST, &event);
+		unlock_fb_info(info);
 	}
 
 	return err;
