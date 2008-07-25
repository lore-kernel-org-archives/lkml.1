Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYGYI4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYGYI4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 04:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYGYI4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 04:56:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423AbYGYI4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 04:56:15 -0400
Date: Fri, 25 Jul 2008 01:55:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PAGE_ALIGN() compile breakage
Message-Id: <20080725015537.564e3397.akpm@linux-foundation.org>
In-Reply-To: <20080725083943.GC19310@cs181140183.pp.htv.fi>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 11:39:43 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> Commit 27ac792ca0b0a1e7e65f20342260650516c95864
> (PAGE_ALIGN(): correctly handle 64-bit values on 32-bit architectures)
> causes on some architectures (e.g. avr32 and mips) compile errors
> like the following in some configurations starting with:
> 
> <--  snip  -->
> 
> ...
>   CC      init/main.o
> In file included from 
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/utsname.h:35,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:20:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h: In function 'arch_pick_mmap_layout':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:2149: error: implicit declaration of function 'PAGE_ALIGN'
> make[2]: *** [init/main.o] Error 1
> 

pls test:

diff -puN include/linux/sched.h~a include/linux/sched.h
--- a/include/linux/sched.h~a
+++ a/include/linux/sched.h
@@ -2139,16 +2139,7 @@ static inline void set_task_cpu(struct t
 
 #endif /* CONFIG_SMP */
 
-#ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
-#else
-static inline void arch_pick_mmap_layout(struct mm_struct *mm)
-{
-	mm->mmap_base = TASK_UNMAPPED_BASE;
-	mm->get_unmapped_area = arch_get_unmapped_area;
-	mm->unmap_area = arch_unmap_area;
-}
-#endif
 
 #ifdef CONFIG_TRACING
 extern void
diff -puN mm/mmap.c~a mm/mmap.c
--- a/mm/mmap.c~a
+++ a/mm/mmap.c
@@ -2268,3 +2268,12 @@ int install_special_mapping(struct mm_st
 
 	return 0;
 }
+
+#ifndef HAVE_ARCH_PICK_MMAP_LAYOUT
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+	mm->mmap_base = TASK_UNMAPPED_BASE;
+	mm->get_unmapped_area = arch_get_unmapped_area;
+	mm->unmap_area = arch_unmap_area;
+}
+#endif
_

> 
> and more nasty problems follow later.
> 
> My suggestion is to:
> - revert commit 27ac792ca0b0a1e7e65f20342260650516c95864 and then
> - fix all PAGE_ALIGN() instances without moving them.

Every time this patch blew up (and it did it often), fixing it resulted
in overall improvements.

> Unifying code is a good thing, but in this case it is not worth the 
> trouble it causes by poking into the heart of our headers mess.

Well.   If we leave it a mess, it'll stay a mess.
