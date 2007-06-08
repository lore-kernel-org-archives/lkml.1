Return-Path: <linux-kernel-owner+w=401wt.eu-S1031840AbXFHUPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031840AbXFHUPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbXFHUOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:14:54 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56646 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760027AbXFHUOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:14:53 -0400
Date: Fri, 8 Jun 2007 22:15:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tom <fivemiletom@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 2.6.21.3] kbuild: fix build for cygwin
Message-ID: <20070608201527.GC25468@uranus.ravnborg.org>
References: <4660971E.5020609@gmail.com> <12D4B80525C5B744A216276E209921D9CE8016@MIAMI.xi-lite.lan> <46645DC9.8080003@gmail.com> <20070607204707.GB16634@uranus.ravnborg.org> <4669A0BD.8050104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4669A0BD.8050104@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 11:32:29AM -0700, Tom wrote:
> From: Tom Enderes <enderes@gmail.com>
> 
> The kernel build failed on cygwin hosts, because cygwin has slightly 
> different typedefs compared to linux:
> scripts/mod/file2alias.c:518: error: dereferencing pointer to incomplete
> type
> Two files, scripts/mod/file2alias.c and scripts/mod/modpost.h, were 
> modified as follows:
> Whever __CYGWIN__ is defined, __uint32 is defined as __uint32_t (instead 
> of uint_32_t) and the missing ElfxxSection definitions are added.
> These changes have been tested both on cygwin 1.5.24, hostcc=gcc 3.4.4 
> and on FC5, hostcc=gcc 4.1.1-1. Any tests on cygwin, with and without 
> this change, were executed with the following set for make: 
> HOST_LOADLIBES="-lcurses -lintl".
> 
> Signed-off-by: Tom Enderes <enderes@gmail.com>
> 
> 
> diff -Naur -r o21.1/scripts/mod/file2alias.c
> 2.6.21.1/scripts/mod/file2alias.c
> --- o21.1/scripts/mod/file2alias.c    2007-04-27 14:49:26.000000000 -0700
> +++ 2.6.21.1/scripts/mod/file2alias.c    2007-05-29 20:35:01.209115300
> -0700
> @@ -29,7 +29,11 @@
> 
>  #include <ctype.h>
> 
> +#ifdef __CYGWIN__
> +typedef __uint32_t      __u32;
> +#else
>  typedef uint32_t    __u32;
> +#endif
>  typedef uint16_t    __u16;
>  typedef unsigned char    __u8;
This change is wrong.
Somehow __uint32_t_defined gets defined and cygwin fails to define
uint32_t.

So we have hit a bug in cygwin here.

Browsing the code I think that including inttypes.h much sooner will fix it.
In file2alias.c I moved include of inttypes.h up.

 
> diff -Naur -r o21.1/scripts/mod/modpost.h 2.6.21.1/scripts/mod/modpost.h
> --- o21.1/scripts/mod/modpost.h    2007-04-27 14:49:26.000000000 -0700
> +++ 2.6.21.1/scripts/mod/modpost.h    2007-05-29 20:35:01.599732800
> -0700
> @@ -9,6 +9,11 @@
>  #include <unistd.h>
>  #include <elf.h>
> 
> +#ifdef __CYGWIN__
> +typedef uint16_t Elf32_Section;
> +typedef uint16_t Elf64_Section;
> +#endif

I did this in an alternative way.
Replacing use of Elf32_section with Elf32_Half did the trick.
Same for the 64 bit type.


Let me know if this works on Cygwin.
I have tested with a few architectures on Linux with success.

(Needs to look into the lib part next).

Thanks for keeping attention on this.

	Sam

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index f646381..5e017a9 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -10,6 +10,14 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 
+#ifdef __sun__
+#include <inttypes.h>
+#else
+#include <stdint.h>
+#endif
+
+#include <ctype.h>
+
 #include "modpost.h"
 
 /* We use the ELF typedefs for kernel_ulong_t but bite the bullet and
@@ -21,13 +29,6 @@ typedef Elf32_Addr	kernel_ulong_t;
 typedef Elf64_Addr	kernel_ulong_t;
 #define BITS_PER_LONG 64
 #endif
-#ifdef __sun__
-#include <inttypes.h>
-#else
-#include <stdint.h>
-#endif
-
-#include <ctype.h>
 
 typedef uint32_t	__u32;
 typedef uint16_t	__u16;
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 4156dd3..0ffed17 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -17,7 +17,7 @@
 #define Elf_Shdr    Elf32_Shdr
 #define Elf_Sym     Elf32_Sym
 #define Elf_Addr    Elf32_Addr
-#define Elf_Section Elf32_Section
+#define Elf_Section Elf32_Half
 #define ELF_ST_BIND ELF32_ST_BIND
 #define ELF_ST_TYPE ELF32_ST_TYPE
 
@@ -31,7 +31,7 @@
 #define Elf_Shdr    Elf64_Shdr
 #define Elf_Sym     Elf64_Sym
 #define Elf_Addr    Elf64_Addr
-#define Elf_Section Elf64_Section
+#define Elf_Section Elf64_Half
 #define ELF_ST_BIND ELF64_ST_BIND
 #define ELF_ST_TYPE ELF64_ST_TYPE
 
