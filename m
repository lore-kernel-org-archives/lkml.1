Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZBSAPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZBSAPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZBSAPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:15:30 -0500
Received: from ozlabs.org ([203.10.76.45]:47773 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZBSAP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:15:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [s390] next Feb 18: defconfig build break
Date: Thu, 19 Feb 2009 10:45:25 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Sachin P. Sant" <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, rmk@arm.linux.org.uk
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <20090218224541.fe6e0355.sfr@canb.auug.org.au> <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
In-Reply-To: <8bd0f97a0902180910wafd35ceo47aeb9f3cc6733f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191045.25878.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 03:40:59 Mike Frysinger wrote:
> On Wed, Feb 18, 2009 at 06:45, Stephen Rothwell wrote:
> > That would be a side effect of commit 43a47c6ca0e0b5479ae316e188a28b7e625d41e5 ("misc:strstarts") from the rr tree.  Rusty cc'd.
> 
> breaks all Blackfin ports as well:

And arm!

Subject: arm: allow usage of string functions in linux/string.h

In introducing a trivial "strstarts()" function in linux/string.h, we
hit:

	arch/arm/boot/compressed/misc.o: In function `strstarts':
	misc.c:(.text+0x368): undefined reference to `strlen'
	misc.c:(.text+0x378): undefined reference to `strncmp'

This is because of "CFLAGS_misc.o := -Dstatic=" in the Makefile.
"static inline strstarts(...)" becomes non-inline, and refers to the
other string ops.

The simplest workaround is to include asm/string.h.  This makes sense
anyway, since lib/string.c won't be linked against this so we can't
use those functions anyway.

Compile tested here.

Reported-by: linux-next
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -18,7 +18,10 @@
 
 unsigned int __machine_arch_type;
 
-#include <linux/string.h>
+#include <linux/compiler.h>	/* for inline */
+#include <linux/types.h>	/* for size_t */
+#include <linux/stddef.h>	/* for NULL */
+#include <asm/string.h>
 
 #ifdef STANDALONE_DEBUG
 #define putstr printf
