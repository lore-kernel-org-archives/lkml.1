Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbZCaCUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbZCaCUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 22:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZCaCUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 22:20:37 -0400
Received: from ozlabs.org ([203.10.76.45]:47564 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbZCaCUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 22:20:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] blackfin: allow allow usage of string functions in linux/string.h
Date: Tue, 31 Mar 2009 12:50:28 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <8bd0f97a0903301726j536da9aciaf9eb5e9a7afff5@mail.gmail.com>
In-Reply-To: <8bd0f97a0903301726j536da9aciaf9eb5e9a7afff5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311250.28540.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In introducing a trivial "strstarts()" function in linux/string.h, we
hit the following error on blackfin:

file included from include/linux/bitmap.h:9,
                 from include/linux/nodemask.h:90,
                 from include/linux/mmzone.h:17,
                 from include/linux/gfp.h:5,
                 from include/linux/kmod.h:23,
                 from include/linux/module.h:14,
                 from arch/blackfin/lib/strncmp.c:14:
include/linux/string.h: In function 'strstarts':
include/linux/string.h:124: error: implicit declaration of function 'strncmp'

Because when including asm/string.h from arch/blackfin/lib/strncmp.c,
we don't declare the string op we are about to define, and
linux/string.h barfs.

The fix is to declare the function whose definition we steal via the
#define trick.  I do this for all of them, so this won't bite us in
future.

Reported-by: linux-next
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/lib/strcmp.c  |    1 +
 arch/blackfin/lib/strcpy.c  |    1 +
 arch/blackfin/lib/strncmp.c |    2 ++
 arch/blackfin/lib/strncpy.c |    2 ++
 4 files changed, 6 insertions(+)

diff --git a/arch/blackfin/lib/strcmp.c b/arch/blackfin/lib/strcmp.c
--- a/arch/blackfin/lib/strcmp.c
+++ b/arch/blackfin/lib/strcmp.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
+int strcmp(const char *dest, const char *src);
 #define strcmp __inline_strcmp
 #include <asm/string.h>
 #undef strcmp
diff --git a/arch/blackfin/lib/strcpy.c b/arch/blackfin/lib/strcpy.c
--- a/arch/blackfin/lib/strcpy.c
+++ b/arch/blackfin/lib/strcpy.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
+char *strcpy(char *dest, const char *src);
 #define strcpy __inline_strcpy
 #include <asm/string.h>
 #undef strcpy
diff --git a/arch/blackfin/lib/strncmp.c b/arch/blackfin/lib/strncmp.c
--- a/arch/blackfin/lib/strncmp.c
+++ b/arch/blackfin/lib/strncmp.c
@@ -6,6 +6,8 @@
  * Licensed under the GPL-2 or later.
  */
 
+#include <linux/types.h>
+int strncmp(const char *cs, const char *ct, size_t count);
 #define strncmp __inline_strncmp
 #include <asm/string.h>
 #undef strncmp
diff --git a/arch/blackfin/lib/strncpy.c b/arch/blackfin/lib/strncpy.c
--- a/arch/blackfin/lib/strncpy.c
+++ b/arch/blackfin/lib/strncpy.c
@@ -6,6 +6,8 @@
  * Licensed under the GPL-2 or later.
  */
 
+#include <linux/types.h>
+char *strncpy(char *dest, const char *src, size_t n);
 #define strncpy __inline_strncpy
 #include <asm/string.h>
 #undef strncpy
