Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbYEOXoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbYEOXoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbYEOXoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:44:10 -0400
Received: from outbound-mail-24.bluehost.com ([69.89.21.19]:44370 "HELO
	outbound-mail-24.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755326AbYEOXoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:44:08 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [RFC] handling panic under X
Date: Thu, 15 May 2008 16:43:56 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8qMLIcAvaYwSiwk"
Message-Id: <200805151643.56914.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8qMLIcAvaYwSiwk
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attached patches, which depend on kernel mode setting, will allow us to 
see some kernel messages even if a panic occurs while X is running.

I think the approach is fairly sound (using a notifier to let mode setting 
drivers switch the front buffer), but there are some details to be worked out 
still:
  - the console needs to be switched earlier on, probably in panic(), so we
    don't lose messages (the current code will print stuff to VT8 until the
    notifier gets called, so we lose the early stuff), but that should be easy
  - abusing KD_TEXT for this purpose probably isn't right, I think we'll want
    some smarts under KD_KERNEL_GRAPHICS for this (console layer hacking for
    the above could be under a KD_KERNEL_GRAPHICS test)
  - we definitely don't wait to wait on VT switch in the notifier, this means
    more exporting of stuff from the console core and smarter handling
  - the switch in the notifier should be more robust; we have some smarts in
    the mode setting code to avoid a full mode reprogram, but we can
    definitely be better about it so we don't rely on as much state being
    preserved

Anyone have good thoughts on the above or approaches they think will work?

That said, it's pretty neat to insert a panic module, see the switch, then see 
printks from the notifier...

One interesting side effect of running X in KD_TEXT mode is that messages 
still get printed to the hidden fbcon, which means things like the root weave 
paint run *really* slow if you're running the DRM modules in debug mode.

Jesse

--Boundary-00=_8qMLIcAvaYwSiwk
Content-Type: text/x-diff;
  charset="us-ascii";
  name="kd-text.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kd-text.patch"

diff --git a/src/i830_driver.c b/src/i830_driver.c
index 4109d88..436345c 100644
--- a/src/i830_driver.c
+++ b/src/i830_driver.c
@@ -174,10 +174,13 @@ USE OR OTHER DEALINGS IN THE SOFTWARE.
 #include <sys/mman.h>
 #include <errno.h>
 
+#include <linux/kd.h>
+
 #include "xf86.h"
 #include "xf86_OSproc.h"
 #include "xf86Resources.h"
 #include "xf86RAC.h"
+#include "xf86Priv.h"
 #include "xf86cmap.h"
 #include "compiler.h"
 #include "mibstore.h"
@@ -1068,6 +1071,8 @@ static Bool i830_kernel_mode_enabled(ScrnInfoPtr pScrn)
    if (ret)
      return FALSE;
 
+   ioctl(xf86Info.consoleFd, KDSETMODE, KD_TEXT);
+
    return TRUE;
 }
 #else

--Boundary-00=_8qMLIcAvaYwSiwk
Content-Type: text/x-diff;
  charset="us-ascii";
  name="fb-panic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fb-panic.patch"

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index fa1ffbf..f53336f 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2401,6 +2401,7 @@ int set_console(int nr)
 
 	return 0;
 }
+EXPORT_SYMBOL(set_console);
 
 struct tty_driver *console_driver;
 
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 3211afd..395f2ab 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -26,6 +26,7 @@
 #include <linux/consolemap.h>
 #include <linux/signal.h>
 #include <linux/timex.h>
+#include <linux/module.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -1203,6 +1204,7 @@ int vt_waitactive(int vt)
 	__set_current_state(TASK_RUNNING);
 	return retval;
 }
+EXPORT_SYMBOL(vt_waitactive);
 
 #define vt_wake_waitactive() wake_up(&vt_activate_queue)
 
diff --git a/include/linux/kd.h b/include/linux/kd.h
index 15f2853..6fe4598 100644
--- a/include/linux/kd.h
+++ b/include/linux/kd.h
@@ -45,6 +45,7 @@ struct consolefontdesc {
 #define		KD_GRAPHICS	0x01
 #define		KD_TEXT0	0x02	/* obsolete */
 #define		KD_TEXT1	0x03	/* obsolete */
+#define		KD_KERNEL_GRAPHICS 0x4  /* kernel will print panics, etc. */
 #define KDGETMODE	0x4B3B	/* get current mode */
 
 #define KDMAPDISP	0x4B3C	/* map display into address space */

--Boundary-00=_8qMLIcAvaYwSiwk
Content-Type: text/x-diff;
  charset="us-ascii";
  name="i915-panicfb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="i915-panicfb.patch"

diff --git a/linux-core/intel_fb.c b/linux-core/intel_fb.c
index 9934e3a..a43319d 100644
--- a/linux-core/intel_fb.c
+++ b/linux-core/intel_fb.c
@@ -566,6 +566,31 @@ int intelfb_resize(struct drm_device *dev, struct drm_crtc *crtc)
 }
 EXPORT_SYMBOL(intelfb_resize);
 
+static struct fb_info *panic_fb;
+
+extern int set_console(int nr);
+extern int vt_waitactive(int vt);
+
+int intelfb_panic(struct notifier_block *n, unsigned long ununsed,
+		  void *panic_str)
+{
+	/* Force a switch back to our FB console */
+	panic_fb->var.activate = FB_ACTIVATE_NOW | FB_ACTIVATE_FORCE;
+	fb_set_var(panic_fb, &panic_fb->var);
+
+	set_console(0);
+	vt_waitactive(0);
+
+	printk(KERN_ERR "panic!  switched back to text console\n");
+
+	return 0;
+}
+EXPORT_SYMBOL(intelfb_panic);
+
+static struct notifier_block paniced = {
+	.notifier_call = intelfb_panic,
+};
+
 int intelfb_probe(struct drm_device *dev, struct drm_crtc *crtc, struct drm_output *output)
 {
 	struct fb_info *info;
@@ -763,6 +788,11 @@ int intelfb_probe(struct drm_device *dev, struct drm_crtc *crtc, struct drm_outp
 
 	printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
 		info->fix.id);
+
+	/* Switch back to kernel console on panic */
+	panic_fb = info;
+	atomic_notifier_chain_register(&panic_notifier_list, &paniced);
+
 	return 0;
 }
 EXPORT_SYMBOL(intelfb_probe);
@@ -783,6 +813,9 @@ int intelfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
 		drm_framebuffer_destroy(fb);
 		framebuffer_release(info);
 	}
+
+	panic_fb = NULL;
+	atomic_notifier_chain_unregister(&panic_notifier_list, &paniced);
 	return 0;
 }
 EXPORT_SYMBOL(intelfb_remove);

--Boundary-00=_8qMLIcAvaYwSiwk--
