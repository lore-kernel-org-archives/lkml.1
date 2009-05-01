Return-Path: <linux-kernel-owner+w=401wt.eu-S1752232AbZEAFQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbZEAFQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZEAFQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:16:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbZEAFQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:16:41 -0400
Date: Thu, 30 Apr 2009 22:13:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@novell.com>, mingo@elte.hu,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
 around
Message-Id: <20090430221322.a3080bbd.akpm@linux-foundation.org>
In-Reply-To: <20090430220648.268ab9bb.akpm@linux-foundation.org>
References: <200904291221.40361.knikanth@novell.com>
	<200904301939.51022.knikanth@novell.com>
	<20090430144526.10b3039a.akpm@linux-foundation.org>
	<200905011027.46754.knikanth@novell.com>
	<20090430220648.268ab9bb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 22:06:48 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 1 May 2009 10:27:46 +0530 Nikanth Karthikesan <knikanth@novell.com> wrote:
> 
> > I tried with linux/bug.h. But it creates a cyclic dependency. linux/bug.h 
> > pulls in linux/module.h => linux/spinlock.h => asm/spinlock.h (which uses 
> > atomic_inc) => asm/atomic.h,.
> 
> And why on earth does bug.h need module.h?
> 
> int  module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
> 			 struct module *);
> 
> The ever-smelly Elf_Ehdr and Elf_Shdr.
> 
> Probably the module_bug_finalize/module_bug_cleanup declarations and
> definitions should be in module.h.
> 

I queued the below.  I _guess_ it's an improvement - bug.h is a quite
low-level thing.

I don't yet know what will explode as a result.


From: Andrew Morton <akpm@linux-foundation.org>

They're in linux/bug.h at present, which causes include order tangles.  In
particular, linux/bug.h cannot be used by linux/atomic.h because,
according to Nikanth:

linux/bug.h pulls in linux/module.h => linux/spinlock.h => asm/spinlock.h
(which uses atomic_inc) => asm/atomic.h.

bug.h is a pretty low-level thing and module.h is a higher-level thing,
IMO.

Cc: Nikanth Karthikesan <knikanth@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h    |   12 ------------
 include/linux/module.h |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/bug.h~headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh include/linux/bug.h
--- a/include/linux/bug.h~headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh
+++ a/include/linux/bug.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_BUG_H
 #define _LINUX_BUG_H
 
-#include <linux/module.h>
 #include <asm/bug.h>
 
 enum bug_trap_type {
@@ -24,10 +23,6 @@ const struct bug_entry *find_bug(unsigne
 
 enum bug_trap_type report_bug(unsigned long bug_addr, struct pt_regs *regs);
 
-int  module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
-			 struct module *);
-void module_bug_cleanup(struct module *);
-
 /* These are defined by the architecture */
 int is_valid_bugaddr(unsigned long addr);
 
@@ -38,13 +33,6 @@ static inline enum bug_trap_type report_
 {
 	return BUG_TRAP_TYPE_BUG;
 }
-static inline int  module_bug_finalize(const Elf_Ehdr *hdr,
-					const Elf_Shdr *sechdrs,
-					struct module *mod)
-{
-	return 0;
-}
-static inline void module_bug_cleanup(struct module *mod) {}
 
 #endif	/* CONFIG_GENERIC_BUG */
 #endif	/* _LINUX_BUG_H */
diff -puN include/linux/module.h~headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh include/linux/module.h
--- a/include/linux/module.h~headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh
+++ a/include/linux/module.h
@@ -696,4 +696,21 @@ static inline void module_remove_modinfo
 
 #define __MODULE_STRING(x) __stringify(x)
 
+
+#ifdef CONFIG_GENERIC_BUG
+int  module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
+			 struct module *);
+void module_bug_cleanup(struct module *);
+
+#else	/* !CONFIG_GENERIC_BUG */
+
+static inline int  module_bug_finalize(const Elf_Ehdr *hdr,
+					const Elf_Shdr *sechdrs,
+					struct module *mod)
+{
+	return 0;
+}
+static inline void module_bug_cleanup(struct module *mod) {}
+#endif	/* CONFIG_GENERIC_BUG */
+
 #endif /* _LINUX_MODULE_H */
_

