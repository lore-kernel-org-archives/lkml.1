Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbZCOG3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbZCOG3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZCOG3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:29:21 -0400
Received: from gw.goop.org ([64.81.55.164]:60441 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZCOG3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:29:20 -0400
Message-ID: <49BCA03D.3020605@goop.org>
Date: Sat, 14 Mar 2009 23:29:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com>
In-Reply-To: <49BC4DB6.9070403@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Well, the semantics are different; the .bss section is zeroed while the
> brk isn't, and the brk symbols don't necessarily point to the data
> associated with those particular symbols, unlike (of course) the bss.
>
> It's not a big issue, obviously, it just seems cleaner to me that way.
>   

OK, I just added a couple of changes to:

    * make the brk reservation symbols have the form ".brk.NAME" to make
      them inaccessible from C, and to make them look obviously
      different from normal symbols (more like sections, since it is
      their size that's more important than their address)
    * Put all the brk stuff in a .brk section
    * Mention alignment in the comment for the slop space

    J

The following changes since commit 1e08816af0bc345995c3f26ce4eaba1171ffb531:
  Ingo Molnar (1):
        Merge branch 'linus'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push/x86/brk

Jeremy Fitzhardinge (7):
      x86: make section delimiter symbols part of their section
      x86: add brk allocation for very, very early allocations
      x86-32: use brk segment for allocating initial kernel pagetable
      x86: use brk allocation for DMI
      x86: allow extend_brk users to reserve brk space
      x86/brk: make the brk reservation symbols inaccessible from C
      x86/brk: put the brk reservations in their own section

Yinghai Lu (2):
      x86-32: compute initial mapping size more accurately
      x86: put initial_pg_tables into .bss -v4

 arch/x86/include/asm/dmi.h           |   14 +----
 arch/x86/include/asm/page_32_types.h |    5 ++
 arch/x86/include/asm/pgtable_32.h    |    3 -
 arch/x86/include/asm/sections.h      |    7 +++
 arch/x86/include/asm/setup.h         |   37 ++++++++++++-
 arch/x86/kernel/head32.c             |    5 +--
 arch/x86/kernel/head64.c             |    2 +-
 arch/x86/kernel/head_32.S            |   62 +++++++++-------------
 arch/x86/kernel/setup.c              |   53 +++++++++++++------
 arch/x86/kernel/vmlinux_32.lds.S     |   19 ++++++-
 arch/x86/kernel/vmlinux_64.lds.S     |   94 +++++++++++++++++++--------------
 arch/x86/lguest/boot.c               |    8 ---
 arch/x86/mm/pageattr.c               |    5 +-
 arch/x86/xen/mmu.c                   |    6 +-
 14 files changed, 187 insertions(+), 133 deletions(-)

Diff for last two changes:

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 61b126b..fbf0521 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -116,13 +116,13 @@ void *extend_brk(size_t size, size_t align);
  * executable.)
  */
 #define RESERVE_BRK(name,sz)						\
-	static void __section(.discard) __used			\
+	static void __section(.discard) __used				\
 	__brk_reservation_fn_##name##__(void) {				\
 		asm volatile (						\
 			".pushsection .brk_reservation,\"aw\",@nobits;" \
-			"__brk_reservation_" #name "__:"		\
+			".brk." #name ":"				\
 			" 1:.skip %c0;"					\
-			" .size __brk_reservation_" #name "__, . - 1b;"	\
+			" .size .brk." #name ", . - 1b;"		\
 			" .popsection"					\
 			: : "i" (sz));					\
 	}
@@ -141,9 +141,9 @@ void __init x86_64_start_reservations(char *real_mode_data);
 #else
 #define RESERVE_BRK(name,sz)				\
 	.pushsection .brk_reservation,"aw",@nobits;	\
-__brk_reservation_##name##__:				\
+.brk.name:						\
 1:	.skip sz;					\
-	.size __brk_reservation_##name##__,.-1b;	\
+	.size .brk.name,.-1b;				\
 	.popsection
 #endif /* __ASSEMBLY__ */
 #endif  /*  __KERNEL__  */
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index c318dee..de14973 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -189,16 +189,18 @@ SECTIONS
 	*(.bss)
 	. = ALIGN(4);
 	__bss_stop = .;
+  }
 
+  .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
 	. = ALIGN(PAGE_SIZE);
 	__brk_base = . ;
- 	. += 64 * 1024 ;	/* 64k slop space */
+ 	. += 64 * 1024 ;	/* 64k alignment slop space */
 	*(.brk_reservation)	/* areas brk users have reserved */
 	__brk_limit = . ;
-
-  	_end = . ;
   }
 
+  _end = . ;
+
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exitcall.exit)
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 47deee3..2f231f3 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -247,12 +247,14 @@ SECTIONS
 	*(.bss.page_aligned)
 	*(.bss)
 	__bss_stop = .;
+  }
 
- 	. = ALIGN(PAGE_SIZE);
- 	__brk_base = . ;
- 	. += 64 * 1024 ;	/* 64k slop space */
+  .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
+	. = ALIGN(PAGE_SIZE);
+	__brk_base = . ;
+	. += 64 * 1024 ;	/* 64k alignment slop space */
 	*(.brk_reservation)	/* areas brk users have reserved */
- 	__brk_limit = . ;
+	__brk_limit = . ;
   }
 
   _end = . ;


