Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbXFKTy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbXFKTy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXFKTyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:54:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55604 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbXFKTyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:54:50 -0400
Date: Mon, 11 Jun 2007 21:55:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: Kaz Kojima <kkojima@rr.iij4u.or.jp>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for -rc] kbuild: fix sh64 section mismatch problems
Message-ID: <20070611195552.GB7238@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please apply following 2 liners fix.
It will fix a lot of false section mismatch warnings on sh64 and
Paul asked to have in included before the relase hit the street.

Please pull this single patch from:
	git://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fix.git

	Sam

Patch below for reference:

 modpost.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

>From 2648a53acf16a837e11836203aadb219bd951a1e Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 11 Jun 2007 21:52:04 +0200
Subject: [PATCH] kbuild: fix sh64 section mismatch problems

There's a special .cranges section that is almost always generated,
with data being moved to the appropriate section by the linker at a later
stage.

To give a bit of background, sh64 has both a native SHmedia instruction
set (32-bit instructions) and SHcompact (which is compatability with
normal SH -- 16-bit, a massively reduced register set, etc.). code ranges
are emitted when we're using the 32-bit ABI, but not the 64-bit one.

It is a special staging section used solely by binutils where code with
different flags get placed (more specifically differing flags for input
and output sections), before being lazily merged by the linker.

The closest I've been able to find to documentation is:
  http://sources.redhat.com/cgi-bin/cvsweb.cgi/src/ld/emultempl/sh64elf.em?rev=1.10&content-type=text/x-cvsweb-markup&cvsroot=src

It's an array of 8-byte Elf32_CRange structure given in
  http://sources.redhat.com/cgi-bin/cvsweb.cgi/src/bfd/elf32-sh64.h?rev=1.4&content-type=text/x-cvsweb-markup&cvsroot=src
that describes for which ISA a range is used.

Silence the warnings by allowing references from .init.text to .cranges.

The following warnings are fixed:

WARNING: init/built-in.o(.cranges+0x0): Section mismatch: reference to .init.text:
WARNING: init/built-in.o(.cranges+0xa): Section mismatch: reference to .init.text:
WARNING: init/built-in.o(.cranges+0x14): Section mismatch: reference to .init.text:
WARNING: init/built-in.o(.cranges+0x1e): Section mismatch: reference to .init.text:
WARNING: init/built-in.o(.cranges+0x28): Section mismatch: reference to .init.text:
WARNING: init/built-in.o(.cranges+0x32): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0x50): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0x5a): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0x64): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0xfa): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0x104): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0x10e): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0x14a): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0x154): Section mismatch: reference to .init.text:
WARNING: kernel/built-in.o(.cranges+0x15e): Section mismatch: reference to .init.text:
WARNING: mm/built-in.o(.cranges+0x6e): Section mismatch: reference to .init.text:
WARNING: mm/built-in.o(.cranges+0x78): Section mismatch: reference to .init.text:
WARNING: mm/built-in.o(.cranges+0x82): Section mismatch: reference to .init.text:
WARNING: mm/built-in.o(.cranges+0xaa): Section mismatch: reference to .init.text:
WARNING: fs/built-in.o(.cranges+0x136): Section mismatch: reference to .init.text:
WARNING: fs/built-in.o(.cranges+0x140): Section mismatch: reference to .init.text:
WARNING: fs/built-in.o(.cranges+0x14a): Section mismatch: reference to .init.text:
WARNING: fs/built-in.o(.cranges+0x168): Section mismatch: reference to .init.text:
WARNING: fs/built-in.o(.cranges+0x1f4): Section mismatch: reference to .init.text:
WARNING: fs/built-in.o(.cranges+0x1fe): Section mismatch: reference to .init.text:
WARNING: net/built-in.o(.cranges+0x302): Section mismatch: reference to .init.text:
WARNING: net/built-in.o(.cranges+0x30c): Section mismatch: reference to .init.text:
WARNING: net/built-in.o(.cranges+0x316): Section mismatch: reference to .init.text:
WARNING: net/built-in.o(.cranges+0x3a2): Section mismatch: reference to .init.text:
WARNING: net/built-in.o(.cranges+0x3ac): Section mismatch: reference to .init.text:
WARNING: net/built-in.o(.cranges+0x4ce): Section mismatch: reference to .init.text:
WARNING: net/built-in.o(.cranges+0x4d8): Section mismatch: reference to .init.text:

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Kaz Kojima <kkojima@rr.iij4u.or.jp>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8e5610d..3645e98 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1052,6 +1052,7 @@ static int init_section_ref_ok(const char *name)
 		".plt",  /* seen on ARCH=um build on x86_64. Harmless */
 		"__ftr_fixup",		/* powerpc cpu feature fixup */
 		"__fw_ftr_fixup",	/* powerpc firmware feature fixup */
+		".cranges",	/* used by sh64 */
 		NULL
 	};
 	/* Start of section names */
@@ -1132,6 +1133,7 @@ static int exit_section_ref_ok(const char *name)
 		".fixup",
 		".smp_locks",
 		".plt",  /* seen on ARCH=um build on x86_64. Harmless */
+		".cranges",	/* used by sh64 */
 		NULL
 	};
 	/* Start of section names */
-- 
1.5.1.rc3.1544.g8a923

