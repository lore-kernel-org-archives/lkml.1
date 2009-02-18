Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZBRW77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZBRW77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZBRW7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:59:48 -0500
Received: from ozlabs.org ([203.10.76.45]:35339 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbZBRW7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:59:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [s390] next Feb 18: defconfig build break
Date: Thu, 19 Feb 2009 09:29:41 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Sachin P. Sant" <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <20090218224541.fe6e0355.sfr@canb.auug.org.au> <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
In-Reply-To: <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902190929.42044.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 03:40:59 Mike Frysinger wrote:
> breaks all Blackfin ports as well:
> In file included from include/linux/bitmap.h:9,
>                  from include/linux/nodemask.h:90,
>                  from include/linux/mmzone.h:17,
>                  from include/linux/gfp.h:5,
>                  from include/linux/kmod.h:23,
>                  from include/linux/module.h:14,
>                  from arch/blackfin/lib/strncmp.c:14:
> include/linux/string.h: In function 'strstarts':
> include/linux/string.h:124: error: implicit declaration of function 'strncmp'
> make[1]: *** [arch/blackfin/lib/strncmp.o] Error 1
> make: *** [arch/blackfin/lib] Error 2
> -mike

Hi Mike,

   I don't have a blackfin cross compiler, but I think this is the right
fix:

Subject: blackfin: allow usage of string functions in linux/string.h

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
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
+int strncmp(const char *cs, const char *ct, size_t count);
 #define strncmp __inline_strncmp
 #include <asm/string.h>
 #undef strncmp
diff --git a/arch/blackfin/lib/strncpy.c b/arch/blackfin/lib/strncpy.c
--- a/arch/blackfin/lib/strncpy.c
+++ b/arch/blackfin/lib/strncpy.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2 or later.
  */
 
+char *strncpy(char *dest, const char *src, size_t n);
 #define strncpy __inline_strncpy
 #include <asm/string.h>
 #undef strncpy
