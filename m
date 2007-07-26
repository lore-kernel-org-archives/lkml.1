Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbXGZFw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbXGZFw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbXGZFwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:52:49 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50175 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbXGZFws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:52:48 -0400
Date: Thu, 26 Jul 2007 07:54:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Lynch <ntl@pobox.com>
Subject: [PATCH] fix 'dynreloc miscount' link error on Powerpc
Message-ID: <20070726055402.GA1147@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch <ntl@pobox.com> reported:
2.6.23-rc1 breaks the build for 64-bit powerpc for me (using
maple_defconfig):

  LD      vmlinux.o
powerpc64-unknown-linux-gnu-ld: dynreloc miscount for
kernel/built-in.o, section .opd
powerpc64-unknown-linux-gnu-ld: can not edit opd Bad value
make: *** [vmlinux.o] Error 1

However, I see a possibly related binutils patch:
http://article.gmane.org/gmane.comp.gnu.binutils/33650

It was tracked down to be caused by the weak prototype
declaration in mm.h:
__attribute__((weak)) const char *arch_vma_name(struct vm_area_struct *vma);

But there is no need to make the declaration weak - only the definition
needs to be marked weak. So drop the weak declaration.
And in the process drop the duplicate definition in page.h for powerpc.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
Note - the arch_vma_name fix for x86_64 needs to be applied first to avoid breaking x86_64



diff --git a/include/asm-powerpc/page.h b/include/asm-powerpc/page.h
index 10c51f4..236a921 100644
--- a/include/asm-powerpc/page.h
+++ b/include/asm-powerpc/page.h
@@ -190,7 +190,6 @@ extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 extern int page_is_ram(unsigned long pfn);
 
 struct vm_area_struct;
-extern const char *arch_vma_name(struct vm_area_struct *vma);
 
 #include <asm-generic/memory_model.h>
 #endif /* __ASSEMBLY__ */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c456c3a..3e9e8fe 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1246,7 +1246,7 @@ void drop_slab(void);
 extern int randomize_va_space;
 #endif
 
-__attribute__((weak)) const char *arch_vma_name(struct vm_area_struct *vma);
+const char * arch_vma_name(struct vm_area_struct *vma);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */


