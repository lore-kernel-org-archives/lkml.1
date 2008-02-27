Return-Path: <linux-kernel-owner+w=401wt.eu-S1764877AbYB0DJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764877AbYB0DJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 22:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYB0DJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 22:09:07 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2856 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYB0DJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 22:09:06 -0500
Subject: [PATCH] linux/kernel.h linux/device.h - Convert debug functions
	declared inline __attribute__((format (printf,x,y) to statement expression
	macros
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 19:08:42 -0800
Message-Id: <1204081722.19319.405.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DEBUG is not defined, pr_debug and dev_dbg and some
other local debugging functions are specified as:

"inline __attribute__((format (printf, x, y)))"

This is done to validate printk arguments when not debugging.

Converting these functions to macros or statement expressions
"do { if (0) printk(fmt, ##arg); } while (0)"
or
"({ if (0) printk(fmt, ##arg); 0; })
makes at least gcc 4.2.2 produce smaller objects.

This has the additional benefit of allowing the optimizer to
avoid calling functions like print_mac that might have been
arguments to the printk.

defconfig x86 current:

$ size vmlinux
   text    data     bss     dec     hex filename
4716770  474560  618496 5809826  58a6a2 vmlinux

all converted: (More patches follow)

$ size vmlinux
   text    data     bss     dec     hex filename
4716642  474560  618496 5809698  58a622 vmlinux

Even kernel/sched.o, which doesn't even use these
functions, becomes smaller.

It appears that merely having an indirect include
of <linux/device.h> can cause bigger objects.

$ size sched.inline.o sched.if0.o
   text    data     bss     dec     hex filename
  31385    2854     328   34567    8707 sched.inline.o
  31366    2854     328   34548    86f4 sched.if0.o

The current preprocessed only kernel/sched.i file contains:

# 612 "include/linux/device.h"
static inline __attribute__((always_inline)) int __attribute__ ((format (printf, 2, 3)))
dev_dbg(struct device *dev, const char *fmt, ...)
{
 return 0;
}
# 628 "include/linux/device.h"
static inline __attribute__((always_inline)) int __attribute__ ((format (printf, 2, 3)))
dev_vdbg(struct device *dev, const char *fmt, ...)
{
 return 0;
}

Removing these unused inlines from sched.i shrinks sched.o

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/kernel.h           |    6 ++----
 include/linux/device.h           |   15 +++++----------

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2df44e7..cd6d02c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -293,10 +293,8 @@ extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 #define pr_debug(fmt, arg...) \
 	printk(KERN_DEBUG fmt, ##arg)
 #else
-static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char * fmt, ...)
-{
-	return 0;
-}
+#define pr_debug(fmt, arg...) \
+	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
 #endif
 
 /*
diff --git a/include/linux/device.h b/include/linux/device.h
index 2258d89..12186e5 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -608,21 +608,16 @@ extern const char *dev_driver_string(struct device *dev);
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
 #else
-static inline int __attribute__ ((format (printf, 2, 3)))
-dev_dbg(struct device *dev, const char *fmt, ...)
-{
-	return 0;
-}
+#define dev_dbg(dev, format, arg...)		\
+	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
 #endif
 
 #ifdef VERBOSE_DEBUG
 #define dev_vdbg	dev_dbg
 #else
-static inline int __attribute__ ((format (printf, 2, 3)))
-dev_vdbg(struct device *dev, const char *fmt, ...)
-{
-	return 0;
-}
+
+#define dev_vdbg(dev, format, arg...)		\
+	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
 #endif
 
 /* Create alias, so I can be autoloaded. */


