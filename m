Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZBSLk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZBSLk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZBSLkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:40:19 -0500
Received: from ozlabs.org ([203.10.76.45]:48870 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZBSLkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:40:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [s390] next Feb 18: defconfig build break
Date: Thu, 19 Feb 2009 22:10:09 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Sachin P. Sant" <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <200902190929.42044.rusty@rustcorp.com.au> <8bd0f97a0902181755y5a5f6760s6e266c87906e6dca@mail.gmail.com>
In-Reply-To: <8bd0f97a0902181755y5a5f6760s6e266c87906e6dca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192210.10368.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 12:25:13 Mike Frysinger wrote:
> > +char *strncpy(char *dest, const char *src, size_t n);
> >  #define strncpy __inline_strncpy
> >  #include <asm/string.h>
> >  #undef strncpy
> 
> size_t is not a builtin type so there needs to be a linux/types.h
> include right above these two prototypes.  then things build up fine
> for me.

OK, this time for sure!


blackfin: allow usage of string functions in linux/string.h

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
---
 arch/blackfin/lib/strcmp.c  |    1 +
 arch/blackfin/lib/strcpy.c  |    1 +
 arch/blackfin/lib/strncmp.c |    1 +
 arch/blackfin/lib/strncpy.c |    1 +
 4 files changed, 4 insertions(+)

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
