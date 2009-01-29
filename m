Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbZA2T3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbZA2T3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZA2T3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:29:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:23050 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZA2T3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:29:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NHngBZlEil1L0/SoPifcKHx2TrPifH/MJPKOGNssNlQzqsXKGJRlC88scQ4C3Gac+2
         jFEwAoTiyLcX0rsRtaLWxt+IH4eFWYXUdOZuMYuuwrabWMzAG9HD2RMpHkJYsNu4ya1r
         s/OrsTP3A9a43kMJVx0zVo7bdtiN4bi9cjup8=
Date: Thu, 29 Jan 2009 22:31:41 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, chris@zankel.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] xtensa: fix compilation somewhat
Message-ID: <20090129193141.GA21625@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ->put_char changes
* HIGHMEM is bogus it seems, there is no kmap_atomic() et al
* some includes

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/xtensa/Kconfig                 |    3 ---
 arch/xtensa/kernel/setup.c          |    2 ++
 arch/xtensa/kernel/traps.c          |    1 +
 arch/xtensa/mm/fault.c              |    1 +
 arch/xtensa/platforms/iss/console.c |    6 ++----
 5 files changed, 6 insertions(+), 7 deletions(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -103,9 +103,6 @@ config MATH_EMULATION
 	help
 	Can we use information of configuration file?
 
-config HIGHMEM
-	bool "High memory support"
-
 endmenu
 
 menu "Platform options"
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -44,6 +44,8 @@
 #include <asm/setup.h>
 #include <asm/param.h>
 
+#include <platform/hardware.h>
+
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
 struct screen_info screen_info = { 0, 24, 0, 0, 0, 80, 0, 0, 0, 24, 1, 16};
 #endif
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/stringify.h>
 #include <linux/kallsyms.h>
 #include <linux/delay.h>
+#include <linux/hardirq.h>
 
 #include <asm/ptrace.h>
 #include <asm/timex.h>
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -14,6 +14,7 @@
 
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/hardirq.h>
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -140,16 +140,14 @@ static void rs_poll(unsigned long priv)
 }
 
 
-static void rs_put_char(struct tty_struct *tty, unsigned char ch)
+static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	char buf[2];
 
-	if (!tty)
-		return;
-
 	buf[0] = ch;
 	buf[1] = '\0';		/* Is this NULL necessary? */
 	__simc (SYS_write, 1, (unsigned long) buf, 1, 0, 0);
+	return 1;
 }
 
 static void rs_flush_chars(struct tty_struct *tty)
