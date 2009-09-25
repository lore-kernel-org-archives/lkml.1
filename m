Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZIYDq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZIYDq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZIYDq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:46:27 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57711 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZIYDq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:46:26 -0400
Date: Fri, 25 Sep 2009 12:45:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jan Beulich <jbeulich@novell.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] module: Fix up CONFIG_KALLSYMS=n build.
Message-ID: <20090925034557.GA12810@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jan Beulich <jbeulich@novell.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting from commit 4a4962263f07d14660849ec134ee42b63e95ea9a
"reduce symbol table for loaded modules (v2)", the kernel/module.c build
is broken with CONFIG_KALLSYMS disabled.

  CC      kernel/module.o
kernel/module.c:1995: warning: type defaults to 'int' in declaration of 'Elf_Hdr'
kernel/module.c:1995: error: expected ';', ',' or ')' before '*' token
kernel/module.c: In function 'load_module':
kernel/module.c:2203: error: 'strmap' undeclared (first use in this function)
kernel/module.c:2203: error: (Each undeclared identifier is reported only once
kernel/module.c:2203: error: for each function it appears in.)
kernel/module.c:2239: error: 'symoffs' undeclared (first use in this function)
kernel/module.c:2239: error: implicit declaration of function 'layout_symtab'
kernel/module.c:2240: error: 'stroffs' undeclared (first use in this function)
make[1]: *** [kernel/module.o] Error 1
make: *** [kernel/module.o] Error 2

There are three different issues:

    - layout_symtab() takes a const Elf_Ehdr

    - layout_symtab() needs to return a value

    - symoffs/stroffs/strmap are referenced by the load_module() code
      despite being ifdefed out, which seems unnecessary given the noop
      behaviour of layout_symtab()/add_kallsyms() in the case of
      CONFIG_KALLSYMS=n.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---

 kernel/module.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 5a29397..4e84c64 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1992,12 +1992,14 @@ static inline unsigned long layout_symtab(struct module *mod,
 					  Elf_Shdr *sechdrs,
 					  unsigned int symindex,
 					  unsigned int strindex,
-					  const Elf_Hdr *hdr,
+					  const Elf_Ehdr *hdr,
 					  const char *secstrings,
 					  unsigned long *pstroffs,
 					  unsigned long *strmap)
 {
+	return 0;
 }
+
 static inline void add_kallsyms(struct module *mod,
 				Elf_Shdr *sechdrs,
 				unsigned int shnum,
@@ -2081,9 +2083,8 @@ static noinline struct module *load_module(void __user *umod,
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
-#ifdef CONFIG_KALLSYMS
 	unsigned long symoffs, stroffs, *strmap;
-#endif
+
 	mm_segment_t old_fs;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
