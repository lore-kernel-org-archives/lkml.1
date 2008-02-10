Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYBJUGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYBJUGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYBJUF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:05:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49970 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbYBJUF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:05:56 -0500
Date: Sun, 10 Feb 2008 21:05:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [2/6] uaccess: add probe_kernel_write()
Message-ID: <20080210200540.GA24677@elte.hu>
References: <20080210071326.GB3851@elte.hu> <47AF483E.2060202@web.de> <alpine.LFD.1.00.0802101102300.2896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802101102300.2896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Along Linus' suggestion to work on larger chunks in kgdb, here are
> > improved probe_kernel_read/write helpers that take a size argument.
> 
> I don't think this is good.
> 
> Make it
>  - a function, not a #define
>  - preferably uninlined (this does *not* look performance-critical)
>  - get rid of the get_fs/set_fs/set_fs dance

yeah. I've done that (see the patch below), and i've just tested that 
kgdb memory accesses work fine with that:

 (gdb) disassemble 0xc0153ed9 0xc0153eff
 Dump of assembler code from 0xc0153ed9 to 0xc0153eff:
 0xc0153ed9:     sfence
 0xc0153edc:     xchg   %ax,%ax
 0xc0153edf:     pop    %ebp
 0xc0153ee0:     movl   $0x0,0xc0a48088
 0xc0153eea:     ret
 0xc0153eeb:     push   %ebp
 0xc0153eec:     mov    %esp,%ebp
 0xc0153eee:     push   $0xc058f11d
 0xc0153ef3:     movl   $0x0,0xc0a4bf4c
 0xc0153efd:     call   0xc0126ec5
 End of assembler dump.

i have to say, it's quite nice that via kgdb i can _see_ what the 
paravirt and alternatives stuff ends up patching into our binary image - 
see the 'sfence' instruction above. Unfortunately looking at the vmlinux 
is not as reliable as it used to be ;-)

( i've added a separate file for it under mm/maccess.c, because these 
  functions will be needed on NOMMU kernel too, so i couldnt move them 
  into their natural place, mm/memory.c. )

	Ingo

---------------->
Subject: uaccess: add probe_kernel_write()
From: Ingo Molnar <mingo@elte.hu>

add probe_kernel_read() and probe_kernel_write().

Uninlined and restricted to kernel range memory only, as suggested
by Linus.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/uaccess.h |   22 ++++++++++++++++++++++
 mm/Makefile             |    2 +-
 mm/maccess.c            |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 1 deletion(-)

Index: linux-kgdb.q/include/linux/uaccess.h
===================================================================
--- linux-kgdb.q.orig/include/linux/uaccess.h
+++ linux-kgdb.q/include/linux/uaccess.h
@@ -84,4 +84,26 @@ static inline unsigned long __copy_from_
 		ret;					\
 	})
 
+/*
+ * probe_kernel_read(): safely attempt to read from a location
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from address @src to the buffer at @dst.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+extern long probe_kernel_read(void *dst, void *src, size_t size);
+
+/*
+ * probe_kernel_write(): safely attempt to write to a location
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+extern long probe_kernel_write(void *dst, void *src, size_t size);
+
 #endif		/* __LINUX_UACCESS_H__ */
Index: linux-kgdb.q/mm/Makefile
===================================================================
--- linux-kgdb.q.orig/mm/Makefile
+++ linux-kgdb.q/mm/Makefile
@@ -8,7 +8,7 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o 
 			   vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
-			   page_alloc.o page-writeback.o pdflush.o \
+			   maccess.o page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o $(mmu-y)
Index: linux-kgdb.q/mm/maccess.c
===================================================================
--- /dev/null
+++ linux-kgdb.q/mm/maccess.c
@@ -0,0 +1,46 @@
+/*
+ * Access kernel memory without faulting.
+ */
+#include <linux/uaccess.h>
+#include <linux/mm.h>
+
+/**
+ * probe_kernel_read(): safely attempt to read from a location
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from address @src to the buffer at @dst.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+long probe_kernel_read(void *dst, void *src, size_t size)
+{
+	long ret;
+
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(dst,
+			(__force const void __user *)src, size);
+	pagefault_enable();
+
+	return ret ? -EFAULT : 0;
+}
+
+/**
+ * probe_kernel_write(): safely attempt to write to a location
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+long probe_kernel_write(void *dst, void *src, size_t size)
+{
+	long ret;
+
+	pagefault_disable();
+	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
+	pagefault_enable();
+
+	return ret ? -EFAULT : 0;
+}
