Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYJVVhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYJVVhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbYJVVf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:35:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051AbYJVVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:35:53 -0400
Message-Id: <20081022213552.440512191@goodmis.org>
References: <20081022212721.167005680@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 17:27:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 08/13 v2] ftrace: do not trace init sections
Content-Disposition: inline; filename=ftrace-notrace-init-sects.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recordmcount script is now robust enough not to process any sections
but the .text section. But the gcc compiler still adds a call to mcount.

Note: The function mcount looks like:

  ENTRY(mcount)
	ret
  END(mcount)

Which means the overhead is just a return.

This patch adds notrace to the init sections to not even bother calling
mcount (which simply returns).


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/init.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-compile.git/include/linux/init.h
===================================================================
--- linux-compile.git.orig/include/linux/init.h	2008-10-22 11:49:44.000000000 -0400
+++ linux-compile.git/include/linux/init.h	2008-10-22 12:27:19.000000000 -0400
@@ -75,15 +75,15 @@
 
 
 #ifdef MODULE
-#define __exitused
+#define __exitused notrace
 #else
-#define __exitused  __used
+#define __exitused  __used notrace
 #endif
 
 #define __exit          __section(.exit.text) __exitused __cold
 
 /* Used for HOTPLUG */
-#define __devinit        __section(.devinit.text) __cold
+#define __devinit        __section(.devinit.text) __cold notrace
 #define __devinitdata    __section(.devinit.data)
 #define __devinitconst   __section(.devinit.rodata)
 #define __devexit        __section(.devexit.text) __exitused __cold
@@ -91,7 +91,7 @@
 #define __devexitconst   __section(.devexit.rodata)
 
 /* Used for HOTPLUG_CPU */
-#define __cpuinit        __section(.cpuinit.text) __cold
+#define __cpuinit        __section(.cpuinit.text) __cold notrace
 #define __cpuinitdata    __section(.cpuinit.data)
 #define __cpuinitconst   __section(.cpuinit.rodata)
 #define __cpuexit        __section(.cpuexit.text) __exitused __cold
@@ -99,7 +99,7 @@
 #define __cpuexitconst   __section(.cpuexit.rodata)
 
 /* Used for MEMORY_HOTPLUG */
-#define __meminit        __section(.meminit.text) __cold
+#define __meminit        __section(.meminit.text) __cold notrace
 #define __meminitdata    __section(.meminit.data)
 #define __meminitconst   __section(.meminit.rodata)
 #define __memexit        __section(.memexit.text) __exitused __cold

-- 
