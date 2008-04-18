Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbYDREFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbYDREFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 00:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbYDREF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 00:05:28 -0400
Received: from mail.queued.net ([207.210.101.209]:4241 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYDREF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 00:05:27 -0400
Date: Fri, 18 Apr 2008 00:07:46 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] lxfb/gxfb: fix up __init and __initdata fields for
 modedb-related stuff
Message-ID: <20080418000746.7ab49894@ephemeral>
In-Reply-To: <20080414223915.411e424f@ephemeral>
References: <20080414035302.794dcd7a@ephemeral>
	<20080414182112.848bcb64.akpm@linux-foundation.org>
	<20080414223915.411e424f@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 22:39:15 -0400
Andres Salomon <dilinger@queued.net> wrote:

> On Mon, 14 Apr 2008 18:21:12 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 14 Apr 2008 03:53:02 -0400 Andres Salomon <dilinger@queued.net> wrote:
> > 
> > > 
> > > Since there's no way to autodetect panel modes, we're forced to hardcode
> > > them in the driver and add a big fat #ifdef.  The OLPC DCON needs a
> > > specific mode line (at 1200x900).  This adds it to both gxfb and lxfb.
> > > 
> > > ...
> > >
> > > +static const struct fb_videomode gx_dcon_modedb[] __initdata = {
> > > +const struct fb_videomode olpc_dcon_modedb[] __initdata = {
> 
> Hm, that one should be static as well.  Will fix in the following patch.
> 
> > 
> > include/linux/init.h:38 points out that `const' and `__initdata' should
> > not be mixed.
> > 
> > I forget which architecture/compiler versions explode when we do this.  But
> > it's not x86, iirc.
> > 
> > Still, it's poor form and, err, I don't immediately recall which tag we
> > _should_ use, and the comments in there are unhelpful.  It might be
> > __initconst, but that has exactly zero users.  Help.
> > 
> 
> 
> My guess would be __initconst or __devinitconst?  That would put it in
> .{init,devinit}.rodata rather than .{init,devinit}.data.
> 
> Alternatively, I could just remove the 'const'.
> 
> Documentation for this stuff would be awesome.  :/
> 
> 
> 

Hm, no answer on that.  Might as well just remove the const.  Can you
please add the patch below?







A couple things were wrong here:
 - a struct in lxfb should've been static.
 - 'const' and '__initdata' don't mix, so the consts have been dropped
 - get_modedb() in both drivers should've been marked w/ __init

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/gxfb_core.c |    8 ++++----
 drivers/video/geode/lxfb_core.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index 3e76e06..6b341b5 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -41,7 +41,7 @@ static int vram;
 static int vt_switch;
 
 /* Modes relevant to the GX (taken from modedb.c) */
-static const struct fb_videomode gx_modedb[] __initdata = {
+static struct fb_videomode gx_modedb[] __initdata = {
 	/* 640x480-60 VESA */
 	{ NULL, 60, 640, 480, 39682,  48, 16, 33, 10, 96, 2,
 	  0, FB_VMODE_NONINTERLACED, FB_MODE_IS_VESA },
@@ -111,14 +111,14 @@ static const struct fb_videomode gx_modedb[] __initdata = {
 #ifdef CONFIG_OLPC
 #include <asm/olpc.h>
 
-static const struct fb_videomode gx_dcon_modedb[] __initdata = {
+static struct fb_videomode gx_dcon_modedb[] __initdata = {
 	/* The only mode the DCON has is 1200x900 */
 	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, 0 }
 };
 
-static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 {
 	if (olpc_has_dcon()) {
 		*modedb = (struct fb_videomode *) gx_dcon_modedb;
@@ -130,7 +130,7 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 }
 
 #else
-static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 {
 	*modedb = (struct fb_videomode *) gx_modedb;
 	*size = ARRAY_SIZE(gx_modedb);
diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 28fa3c4..ae69feb 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -36,7 +36,7 @@ static int vt_switch;
  * we try to make it something sane - 640x480-60 is sane
  */
 
-static const struct fb_videomode geode_modedb[] __initdata = {
+static struct fb_videomode geode_modedb[] __initdata = {
 	/* 640x480-60 */
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
@@ -220,14 +220,14 @@ static const struct fb_videomode geode_modedb[] __initdata = {
 #ifdef CONFIG_OLPC
 #include <asm/olpc.h>
 
-const struct fb_videomode olpc_dcon_modedb[] __initdata = {
+static struct fb_videomode olpc_dcon_modedb[] __initdata = {
 	/* The only mode the DCON has is 1200x900 */
 	{ NULL, 50, 1200, 900, 17460, 24, 8, 4, 5, 8, 3,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, 0 }
 };
 
-static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 {
 	if (olpc_has_dcon()) {
 		*modedb = (struct fb_videomode *) olpc_dcon_modedb;
@@ -239,7 +239,7 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 }
 
 #else
-static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
+static void __init get_modedb(struct fb_videomode **modedb, unsigned int *size)
 {
 	*modedb = (struct fb_videomode *) geode_modedb;
 	*size = ARRAY_SIZE(geode_modedb);
-- 
1.5.4.4



-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
