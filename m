Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbXFQIjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbXFQIjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbXFQIjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:39:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758685AbXFQIjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:39:06 -0400
Date: Sun, 17 Jun 2007 10:39:04 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: [PATCH] blink: Only blink when parameter is set
Message-ID: <20070617083904.GC4496@suse.de>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch in the blink driver changes the module to only blink when
the parameter 'blink' is set to true. This is to allow the module to
be compiled in the kernel and not as module.

As the blink module was initially written for kdump, and as the kernel
is relocatable on lots of architectures, there's no need to compile a
separate kdump kernel. The blinking can now enabled via the boot
command line for the kdump kernel when necessary.

The patch also adds some author/license information and marks the init
function as '__init'.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/misc/blink.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/misc/blink.c
+++ b/drivers/misc/blink.c
@@ -3,6 +3,10 @@
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 
+static int blink = 0;
+module_param(blink, bool, S_IRUGO);
+MODULE_PARM_DESC(blink, "Enable blinking (without that, the module does nothing)\n");
+
 static void do_blink(unsigned long data);
 
 static DEFINE_TIMER(blink_timer, do_blink, 0 ,0);
@@ -19,9 +23,16 @@ static void do_blink(unsigned long data)
 static int blink_init(void)
 {
 	printk(KERN_INFO "Enabling keyboard blinking\n");
-	do_blink(0);
+
+	if (blink)
+		do_blink(0);
+
 	return 0;
 }
 
 module_init(blink_init);
 
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Andi Kleen <ak@suse.de>");
+MODULE_DESCRIPTION("Blinks the keyboard LEDs");
+
