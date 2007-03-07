Return-Path: <linux-kernel-owner+w=401wt.eu-S2992489AbXCGThZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992489AbXCGThZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992500AbXCGThZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:37:25 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52389 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992489AbXCGThY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:37:24 -0500
Date: Wed, 7 Mar 2007 11:37:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Joerg Roedel" <joerg.roedel@amd.com>,
       "Andi Kleen" <ak@suse.de>
Subject: Re: 2.6.21-rc2-mm2 -- hot-fix
 "revert-optimize-and-simplify-get_cycles_sync.patch" broke my build
Message-Id: <20070307113716.97558767.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0703071101q16188b9pc5e8dbc226a7283d@mail.gmail.com>
References: <a44ae5cd0703071101q16188b9pc5e8dbc226a7283d@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 11:01:55 -0800 "Miles Lane" <miles.lane@gmail.com> wrote:

> In file included from include/asm/timex.h:10,
>                  from include/linux/timex.h:187,
>                  from include/linux/sched.h:50,
>                  from include/linux/utsname.h:35,
>                  from include/asm/elf.h:12,
>                  from include/linux/elf.h:7,
>                  from include/linux/module.h:15,
>                  from include/linux/crypto.h:21,
>                  from arch/i386/kernel/asm-offsets.c:7:
> include/asm/tsc.h: In function 'get_cycles_sync':
> include/asm/tsc.h:45: warning: implicit declaration of function 'alternative_io'
> include/asm/tsc.h:46: error: called object '"=a"' is not a function
> include/asm/tsc.h:46: error: called object '"0"' is not a function
> include/asm/tsc.h:46: error: expected ')' before ':' token
> make[1]: *** [arch/i386/kernel/asm-offsets.s] Error 1

Yes, I ended up dropping another patch to fix that up and things got in a
mess.

Andy's patch should fix it up again


From: Andy Whitcroft <apw@shadowen.org>

Add an i386 implementation of alternative_io modelled on
the x86_64 version.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/alternative.h |   17 +++++++++++++++++
 include/asm-i386/tsc.h         |    1 +
 2 files changed, 18 insertions(+)

diff -puN include/asm-i386/alternative.h~i386-alternative_io-implementation include/asm-i386/alternative.h
--- a/include/asm-i386/alternative.h~i386-alternative_io-implementation
+++ a/include/asm-i386/alternative.h
@@ -100,6 +100,23 @@ static inline void alternatives_smp_swit
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
 		      ".previous" :: "i" (feature), ##input)
 
+#define alternative_io(oldinstr, newinstr, feature, output, input...)	\
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
+		      ".section .altinstructions,\"a\"\n"		\
+		      "  .align 4\n"					\
+		      "  .long 661b\n"            /* label */		\
+		      "  .long 663f\n"		  /* new instruction */ \
+		      "  .long 0x00\n"					\
+		      "  .byte %c[feat]\n"        /* feature bit */	\
+		      "  .byte 0x00\n"					\
+		      "  .byte 662b-661b\n"       /* sourcelen */	\
+		      "  .byte 664f-663f\n"       /* replacementlen */ 	\
+		      "  .byte 0x00\n"					\
+		      ".previous\n"					\
+		      ".section .altinstr_replacement,\"ax\"\n"		\
+		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
+		      ".previous" : output : [feat] "i" (feature), ##input)
+
 /* Like alternative_io, but supports 2 possible alternatives */
 #define alternative_io_two(oldinstr, newinstr, feat, newinstr2, feat2,\
 		output, input...) \
diff -puN include/asm-i386/tsc.h~i386-alternative_io-implementation include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~i386-alternative_io-implementation
+++ a/include/asm-i386/tsc.h
@@ -6,6 +6,7 @@
 #ifndef _ASM_i386_TSC_H
 #define _ASM_i386_TSC_H
 
+#include <asm/alternative.h>
 #include <asm/processor.h>
 
 /*
_

