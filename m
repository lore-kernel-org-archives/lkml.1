Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYBARa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYBARa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYBARaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:30:19 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:34957 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbYBARaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:30:17 -0500
Date: Fri, 1 Feb 2008 12:29:55 -0500
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>, Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] arch/um/include/init.h: Fix missing macro definitions
Message-ID: <20080201172955.GA6897@c2.user-mode-linux.org>
References: <20080131150634.GC2471@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131150634.GC2471@hacking>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 11:06:34PM +0800, WANG Cong wrote:
> This patch fixed the following build error in current -git tree.
> 
> arch/um/kernel/config.c:10: error: expected declaration specifiers or '...' before '.' token
> ...

This is close to uml-arch-um-include-inith-needs-a-definition-of-__used.patch
that's currently in -mm.

Andrew, could you replace
uml-arch-um-include-inith-needs-a-definition-of-__used.patch with the
version below and push it to Linus?

				Jeff

-- 
Work email - jdike at linux dot intel dot com


init.h started breaking now for some reason.  It turns out that there wasn't a
definition of __used.  Fixed this by copying the relevant stuff from
compiler.h in the userspace case, and including compiler.h in the kernel case.

>From WANG Cong <xiyou.wangcong@gmail.com> - added definition of __section

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
---
 arch/um/include/init.h |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

Index: linux-2.6-git/arch/um/include/init.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/init.h	2008-02-01 10:41:14.000000000 -0500
+++ linux-2.6-git/arch/um/include/init.h	2008-02-01 10:52:34.000000000 -0500
@@ -40,6 +40,20 @@
 typedef int (*initcall_t)(void);
 typedef void (*exitcall_t)(void);
 
+#ifndef __KERNEL__
+#ifndef __section
+# define __section(S) __attribute__ ((__section__(#S)))
+#endif
+
+#if __GNUC_MINOR__ >= 3
+# define __used			__attribute__((__used__))
+#else
+# define __used			__attribute__((__unused__))
+#endif
+
+#else
+#include <linux/compiler.h>
+#endif
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
 #define __init		__section(.init.text)
@@ -127,14 +141,3 @@ extern struct uml_param __uml_setup_star
 #endif
 
 #endif /* _LINUX_UML_INIT_H */
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
