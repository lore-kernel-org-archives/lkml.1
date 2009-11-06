Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbZKFQpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbZKFQpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759446AbZKFQpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:45:35 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:46628 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419AbZKFQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:45:34 -0500
Date: Fri, 6 Nov 2009 17:45:32 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] fbcon: make cursor display conditional
Message-ID: <20091106164532.GK14091@buzzloop.caiaq.de>
References: <1257412658-9444-1-git-send-email-daniel@caiaq.de>
 <4AF3DB6C.2070300@ladisch.de>
 <20091106143916.GA30819@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106143916.GA30819@linux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 06, 2009 at 03:39:18PM +0100, Andrea Righi wrote:
> On Fri, Nov 06, 2009 at 09:16:44AM +0100, Clemens Ladisch wrote:
> > Daniel Mack wrote:
> > > For embedded systems, the blinking cursor at startup time can be
> > > annoying and unintended. Add a new kernel parameter
> > > 'fbcon_disable_cursor' which disables it conditionally.
> > 
> > Wouldn't it be more useful to change the CUR_DEFAULT symbol (see the
> > end of <linux/console_struct.h>) into a kernel parameter, instead of
> > adding a new flag?
> 
> Agreed. There's no need to choose if we want the blinking cursor or not
> at each boot. Better to make this decision at compile time.

Ok, much better idea, I agree. See the patch below.

Thanks for the input,
Daniel


>From 8192226c1cdda90ef0d73a55c02f632693065310 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Fri, 6 Nov 2009 17:31:00 +0100
Subject: [PATCH] char/console: make default cursor type configurable

Make the default console cursor type configurable rather than
hard-coding it.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/Kconfig           |   27 +++++++++++++++++++++++++++
 drivers/char/vt.c              |   23 +++++++++++++++++++++++
 include/linux/console_struct.h |    2 --
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 6aad99e..1e01ea4 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -88,6 +88,33 @@ config VT_HW_CONSOLE_BINDING
 	 information. For framebuffer console users, please refer to
 	 <file:Documentation/fb/fbcon.txt>.
 
+choice
+	prompt "Console default cursor type"
+	depends on HW_CONSOLE
+	default CONSOLE_DEF_CUR_UNDERLINE
+	help
+	  This option selects the default cursor type for the text console.
+
+config CONSOLE_DEF_CUR_NONE
+	bool "none"
+
+config CONSOLE_DEF_CUR_UNDERLINE
+	bool "underline"
+
+config CONSOLE_DEF_CUR_LOWER_THIRD
+	bool "lower third"
+
+config CONSOLE_DEF_CUR_LOWER_HALF
+	bool "lower half"
+
+config CONSOLE_DEF_CUR_TWO_THIRDS
+	bool "two thirds"
+
+config CONSOLE_DEF_CUR_BLOCK
+	bool "block"
+
+endchoice
+
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
 	default y
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 0c80c68..0078f6e 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -111,6 +111,29 @@
 #define CON_DRIVER_FLAG_INIT   2
 #define CON_DRIVER_FLAG_ATTR   4
 
+#if defined(CONFIG_CONSOLE_DEF_CUR_NONE)
+#define CUR_DEFAULT CUR_NONE
+
+#elif defined(CONFIG_CONSOLE_DEF_CUR_UNDERLINE)
+#define CUR_DEFAULT CUR_UNDERLINE
+
+#elif defined(CONFIG_CONSOLE_DEF_CUR_LOWER_THIRD)
+#define CUR_DEFAULT CUR_LOWER_THIRD
+
+#elif defined(CONFIG_CONSOLE_DEF_CUR_LOWER_HALF)
+#define CUR_DEFAULT CUR_LOWER_HALF
+
+#elif defined(CONFIG_CONSOLE_DEF_CUR_TWO_THIRDS)
+#define CUR_DEFAULT CUR_TWO_THIRDS
+
+#elif defined(CONFIG_CONSOLE_DEF_CUR_BLOCK)
+#define CUR_DEFAULT CUR_BLOCK
+
+#else
+#warning "no default console cursor type defined, defaulting to 'underline'"
+#define CUR_DEFAULT CUR_UNDERLINE
+#endif
+
 struct con_driver {
 	const struct consw *con;
 	const char *desc;
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index 38fe59d..6c024a0 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -130,8 +130,6 @@ extern void vc_SAK(struct work_struct *work);
 #define CUR_HWMASK	0x0f
 #define CUR_SWMASK	0xfff0
 
-#define CUR_DEFAULT CUR_UNDERLINE
-
 #define CON_IS_VISIBLE(conp) (*conp->vc_display_fg == conp)
 
 #endif /* _LINUX_CONSOLE_STRUCT_H */
-- 
1.6.5.2

