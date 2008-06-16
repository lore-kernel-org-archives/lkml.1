Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYFPMBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYFPMBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYFPMBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:01:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbYFPMBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:01:08 -0400
Subject: Re: [PATCH v2] export linux/a.out.h
From: David Woodhouse <dwmw2@infradead.org>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, dhowells@redhat.com,
       andi@firstfloor.org, "Kirill A. Shutemov" <k.shutemov@gmail.com>
In-Reply-To: <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
References: <1213565555.26255.522.camel@pmac.infradead.org>
	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 13:01:03 +0100
Message-Id: <1213617663.26255.708.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 10:29 +0200, Peter Korsgaard wrote:
> Export linux/a.out.h like we do for asm/a.out.h as some applications needs
> it (E.G. valgrind). One minor complication is that the content is protected
> by an CONFIG_ARCH_SUPPORTS_AOUT ifdef, so get rid of it.

There was a _reason_ for that ifdef, although on reflection probably not
a particularly good one. But unless we remove the reason for that ifdef,
your patch will break compilation on architectures which don't have
<asm/a.out.h>.

We should get rid of CONFIG_ARCH_SUPPORTS_AOUT entirely. The only
remaining users of it are fs/exec.c, which uses it entirely redundantly:
	#if defined(__alpha__) && defined(CONFIG_ARCH_SUPPORTS_AOUT)

...and (indirectly, by virtue of being the only other file that includes
<linux/a.out.h> when ARCH_SUPPORTS_AOUT might be unset) fs/binfmt_elf.c,
which still has unnecessary references to 'struct exec' even though Andi
removed the support for a.out interpreters a few months ago. That can
just go away.

Please see  git.infradead.org/users/dwmw2/aout-2.6.git

David Woodhouse (6):
      Include <asm/a.out.h> in fs/exec.c only for Alpha.
      Remove last traces of a.out support from ELF loader.
      Remove #ifdef CONFIG_ARCH_SUPPORTS_AOUT from <linux/a.out.h>
      Export <linux/a.out.h> to userspace again.
      Remove redundant CONFIG_ARCH_SUPPORTS_AOUT
      Remove references to now-defunct CONFIG_ARCH_SUPPORTS_AOUT from defconfigs

The first four are shown below, as a single combined patch.

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 0fa95b1..d48ff5f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -16,7 +16,6 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/binfmts.h>
@@ -548,7 +547,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	struct {
 		struct elfhdr elf_ex;
 		struct elfhdr interp_elf_ex;
-  		struct exec interp_ex;
 	} *loc;
 
 	loc = kmalloc(sizeof(*loc), GFP_KERNEL);
@@ -680,7 +678,6 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			}
 
 			/* Get the exec headers */
-			loc->interp_ex = *((struct exec *)bprm->buf);
 			loc->interp_elf_ex = *((struct elfhdr *)bprm->buf);
 			break;
 		}
diff --git a/fs/exec.c b/fs/exec.c
index 9448f1b..da94a6f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -26,7 +26,6 @@
 #include <linux/file.h>
 #include <linux/fdtable.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
@@ -61,6 +60,11 @@
 #include <linux/kmod.h>
 #endif
 
+#ifdef __alpha__
+/* for /sbin/loader handling in search_binary_handler() */
+#include <linux/a.out.h>
+#endif
+
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 int suid_dumpable = 0;
@@ -1155,7 +1159,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 {
 	int try,retval;
 	struct linux_binfmt *fmt;
-#if defined(__alpha__) && defined(CONFIG_ARCH_SUPPORTS_AOUT)
+#ifdef __alpha__
 	/* handle /sbin/loader.. */
 	{
 	    struct exec * eh = (struct exec *) bprm->buf;
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 93b9885..b6fbb25 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -166,6 +166,9 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
+ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
+unifdef-y += a.out.h
+endif
 unifdef-y += apm_bios.h
 unifdef-y += atalk.h
 unifdef-y += atmdev.h
diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index 208f4e8..e86dfca 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -1,8 +1,6 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
-#ifdef CONFIG_ARCH_SUPPORTS_AOUT
-
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -277,10 +275,4 @@ struct relocation_info
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
 #endif /*__ASSEMBLY__ */
-#else /* CONFIG_ARCH_SUPPORTS_AOUT */
-#ifndef __ASSEMBLY__
-struct exec {
-};
-#endif
-#endif /* CONFIG_ARCH_SUPPORTS_AOUT */
 #endif /* __A_OUT_GNU_H__ */

-- 
dwmw2

