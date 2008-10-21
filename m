Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYJUMFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYJUMFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYJUMFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:05:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYJUME7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:04:59 -0400
Date: Tue, 21 Oct 2008 14:05:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Remove simnow earlyprintk support
Message-ID: <20081021120500.GA21453@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove simnow earlyprintk support

The later versions of SimNow! actually all have serial console
emulation, so the direct interface isn't needed anymore.
So remove the undocumented simnow earlyprintk console.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/early_printk.c |   45 -----------------------------------------
 1 file changed, 45 deletions(-)

Index: linux-2.6.27-misc/arch/x86/kernel/early_printk.c
===================================================================
--- linux-2.6.27-misc.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6.27-misc/arch/x86/kernel/early_printk.c
@@ -151,47 +151,6 @@ static struct console early_serial_conso
 	.index =	-1,
 };
 
-/* Console interface to a host file on AMD's SimNow! */
-
-static int simnow_fd;
-
-enum {
-	MAGIC1 = 0xBACCD00A,
-	MAGIC2 = 0xCA110000,
-	XOPEN = 5,
-	XWRITE = 4,
-};
-
-static noinline long simnow(long cmd, long a, long b, long c)
-{
-	long ret;
-	asm volatile("cpuid" :
-		     "=a" (ret) :
-		     "b" (a), "c" (b), "d" (c), "0" (MAGIC1), "D" (cmd + MAGIC2));
-	return ret;
-}
-
-static void __init simnow_init(char *str)
-{
-	char *fn = "klog";
-	if (*str == '=')
-		fn = ++str;
-	/* error ignored */
-	simnow_fd = simnow(XOPEN, (unsigned long)fn, O_WRONLY|O_APPEND|O_CREAT, 0644);
-}
-
-static void simnow_write(struct console *con, const char *s, unsigned n)
-{
-	simnow(XWRITE, simnow_fd, (unsigned long)s, n);
-}
-
-static struct console simnow_console = {
-	.name =		"simnow",
-	.write =	simnow_write,
-	.flags =	CON_PRINTBUFFER,
-	.index =	-1,
-};
-
 /* Direct interface for emergencies */
 static struct console *early_console = &early_vga_console;
 static int early_console_initialized;
@@ -234,10 +193,6 @@ static int __init setup_early_printk(cha
 		max_ypos = boot_params.screen_info.orig_video_lines;
 		current_ypos = boot_params.screen_info.orig_y;
 		early_console = &early_vga_console;
-	} else if (!strncmp(buf, "simnow", 6)) {
-		simnow_init(buf + 6);
-		early_console = &simnow_console;
-		keep_early = 1;
 #ifdef CONFIG_HVC_XEN
 	} else if (!strncmp(buf, "xen", 3)) {
 		early_console = &xenboot_console;
