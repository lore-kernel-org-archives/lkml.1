Return-Path: <linux-kernel-owner+w=401wt.eu-S1757887AbYBOQpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbYBOQpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 11:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbYBOQpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 11:45:46 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:17606 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754718AbYBOQpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 11:45:45 -0500
Date: Fri, 15 Feb 2008 19:45:42 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] fb: add support for foreign endianness
Message-ID: <20080215164542.GB16810@localhost.localdomain>
Reply-To: avorontsov@ru.mvista.com
References: <20080205154432.GA8749@localhost.localdomain> <20080214224942.a0cb6218.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080214224942.a0cb6218.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:49:42PM -0800, Andrew Morton wrote:
> On Tue, 5 Feb 2008 18:44:32 +0300 Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > This patch adds support for the framebuffers with non-native
> > endianness. This is done via FBINFO_FOREIGN_ENDIAN flag that will
> > be used by the drivers. Depending on the host endianness this flag
> > will be overwritten by FBINFO_BE_MATH internal flag, or cleared.
> > 
> > Tested to work on MPC8360E-RDK (BE) + Fujitsu MINT framebuffer (LE).
> 
> That's a pretty large patch to fbdev core,

Yes, but changes are mostly trivial. No insurance of typos and thinkos
though. OTOH, it survived my tests.

> and Tony appears to have gone
> offline again and you didn't cc the fbdev mailing list.

FRAMEBUFFER LAYER
P:      Antonino Daplas
M:      adaplas@gmail.com
L:      linux-fbdev-devel@lists.sourceforge.net (subscribers-only)

I'm lazy to subscribe on occasional patches. Yup, this is hardly
an excuse...

> I fixed the third problem.  Could the other fbdev developers please review
> and comment on this?
> 
> Thanks.
> 
> 
> 
> Actually...  should CONFIG_FB_FOREIGN_ENDIAN exist, or should this feature
> be permanently enabled?

It should not. Because with CONFIG_FB_FOREIGN_ENDIAN enabled, drawing
might be a little bit slower, because of external checks for endianness
(I didn't noticed any slowdown, but I guess it's still measurable if we
find some fb benchmark).

Thinking about it a little bit more, I believe we want to add a choice,
which exactly foreign endianness we want to compile-in. Then, if we're
pretty confident that particular BE machine uses only LE framebuffer,
gcc can optimize away endianness checks.

Patch on top of previous inlined here. With that patch, slowdown is
possible with CONFIG_FB_BOTH_ENDIAN option only, which is still
default if FOREIGN_ENDIAN is selected.

> I'd like to at least queue a patch in -mm so that CONFIG_FB_FOREIGN_ENDIAN
> is forced-on, so the code gets some runtime testing.  Will that break
> anything?

Nope, it should not break anything, just possible fbconsole/tux drawing
slowdown.


Thanks,

- - - -
From: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: fb: add support for choice foreign endianness

With this patch FB_FOREIGN_ENDIAN converted to menuconfig with the
choice inside: which type of foreign endianness we want to compile-in.

As a bonus, now fb subsystem will refuse to register framebuffer with
unsupported endianness, and will suggest a way to solve the problem.

[ on top of fb-add-support-for-foreign-endianness.patch ]

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/video/Kconfig |   27 +++++++++++++++++++++------
 drivers/video/fbmem.c |   38 ++++++++++++++++++++++++++++++--------
 include/linux/fb.h    |   14 +++++++++++---
 3 files changed, 62 insertions(+), 17 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 6b3940d..9e0b6ea 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -139,14 +139,29 @@ config FB_SYS_IMAGEBLIT
 	  blitting. This is used by drivers that don't provide their own
 	  (accelerated) version and the framebuffer is in system RAM.
 
-config FB_FOREIGN_ENDIAN
-	bool "Enable support for foreign endianness"
+menuconfig FB_FOREIGN_ENDIAN
+	bool "Framebuffer foreign endianness support"
 	depends on FB
 	---help---
-	  This option enables support for the framebuffers with non-native
-	  endianness (e.g. Little-Endian framebuffer on a Big-Endian machine).
-	  You probably don't have such hardware, so in most cases it's safe to
-	  say "n" here.
+	  This menu will let you enable support for the framebuffers with
+	  non-native endianness (e.g. Little-Endian framebuffer on a
+	  Big-Endian machine). Most probably you don't have such hardware,
+	  so it's safe to say "n" here.
+
+choice
+	prompt "Choice endianness support"
+	depends on FB_FOREIGN_ENDIAN
+
+config FB_BOTH_ENDIAN
+	bool "Support for Big- and Little-Endian framebuffers"
+
+config FB_BIG_ENDIAN
+	bool "Support for Big-Endian framebuffers only"
+
+config FB_LITTLE_ENDIAN
+	bool "Support for Little-Endian framebuffers only"
+
+endchoice
 
 config FB_SYS_FOPS
        tristate
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index c086004..11d92fd 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1352,6 +1352,32 @@ static const struct file_operations fb_fops = {
 
 struct class *fb_class;
 EXPORT_SYMBOL(fb_class);
+
+static int fb_check_foreignness(struct fb_info *fi)
+{
+	const bool foreign_endian = fi->flags & FBINFO_FOREIGN_ENDIAN;
+
+	fi->flags &= ~FBINFO_FOREIGN_ENDIAN;
+
+#ifdef __BIG_ENDIAN
+	fi->flags |= foreign_endian ? 0 : FBINFO_BE_MATH;
+#else
+	fi->flags |= foreign_endian ? FBINFO_BE_MATH : 0;
+#endif /* __BIG_ENDIAN */
+
+	if (fi->flags & FBINFO_BE_MATH && !fb_be_math(fi)) {
+		pr_err("%s: enable CONFIG_FB_BIG_ENDIAN to "
+		       "support this framebuffer\n", fi->fix.id);
+		return -ENOSYS;
+	} else if (!(fi->flags & FBINFO_BE_MATH) && fb_be_math(fi)) {
+		pr_err("%s: enable CONFIG_FB_LITTLE_ENDIAN to "
+		       "support this framebuffer\n", fi->fix.id);
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1368,10 +1394,13 @@ register_framebuffer(struct fb_info *fb_info)
 	int i;
 	struct fb_event event;
 	struct fb_videomode mode;
-	const bool foreign_endian = fb_info->flags & FBINFO_FOREIGN_ENDIAN;
 
 	if (num_registered_fb == FB_MAX)
 		return -ENXIO;
+
+	if (fb_check_foreignness(fb_info))
+		return -ENOSYS;
+
 	num_registered_fb++;
 	for (i = 0 ; i < FB_MAX; i++)
 		if (!registered_fb[i])
@@ -1405,13 +1434,6 @@ register_framebuffer(struct fb_info *fb_info)
 	if (!fb_info->pixmap.blit_y)
 		fb_info->pixmap.blit_y = ~(u32)0;
 
-	fb_info->flags &= ~FBINFO_FOREIGN_ENDIAN;
-#ifdef __BIG_ENDIAN
-	fb_info->flags |= foreign_endian ? 0 : FBINFO_BE_MATH;
-#else
-	fb_info->flags |= foreign_endian ? FBINFO_BE_MATH : 0;
-#endif
-
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
diff --git a/include/linux/fb.h b/include/linux/fb.h
index a067ed3..72295b0 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -979,13 +979,21 @@ extern int fb_deferred_io_fsync(struct file *file, struct dentry *dentry,
 
 static inline bool fb_be_math(struct fb_info *info)
 {
-#if defined(CONFIG_FB_FOREIGN_ENDIAN)
+#ifdef CONFIG_FB_FOREIGN_ENDIAN
+#if defined(CONFIG_FB_BOTH_ENDIAN)
 	return info->flags & FBINFO_BE_MATH;
-#elif defined(__BIG_ENDIAN)
+#elif defined(CONFIG_FB_BIG_ENDIAN)
+	return true;
+#elif defined(CONFIG_FB_LITTLE_ENDIAN)
+	return false;
+#endif /* CONFIG_FB_BOTH_ENDIAN */
+#else
+#ifdef __BIG_ENDIAN
 	return true;
 #else
 	return false;
-#endif
+#endif /* __BIG_ENDIAN */
+#endif /* CONFIG_FB_FOREIGN_ENDIAN */
 }
 
 /* drivers/video/fbsysfs.c */
-- 
1.5.2.2

