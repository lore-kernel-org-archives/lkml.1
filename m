Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbXKKGtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbXKKGtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 01:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbXKKGsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 01:48:53 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32862 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756204AbXKKGsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 01:48:52 -0500
Date: Sun, 11 Nov 2007 07:48:29 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] add -fno-tree-scev-cprop to KBUILD_CFLAGS
Message-ID: <20071111064829.GG21669@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The gcc from svn that will become gcc 4.3 generates libgcc calls in 
cases like the following (on 32bit architectures):

<--  snip  -->

static inline void timespec_add_ns(struct timespec *a, u64 ns)
{
...
        while(ns >= NSEC_PER_SEC) {
                ns -= NSEC_PER_SEC;
                a->tv_sec++;
        }
...

<--  snip  -->

It can make sense to emit assembler code doing division for such C code -
that doesn't seem to be something that would generally be wrong.

But the kernel does (at least on some architectures) not link with 
libgcc or ship other code providing the required libgcc functions.

Richard Guenther suggested in gcc bug #32044 to use -fno-tree-scev-cprop 
(new option in gcc 4.3) as a workaround and I confirmed that it fixes 
the compilation.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f2357fcb8addd855f1be6ac9fdf4ef3c3ab8256d 
diff --git a/Makefile b/Makefile
index e28dde8..9d8a831 100644
--- a/Makefile
+++ b/Makefile
@@ -527,6 +527,9 @@ KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 # disable pointer signed / unsigned warnings in gcc 4.0
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
+# workaround to avoid gcc 4.3 emitting libgcc calls (see gcc bug #32044)
+KBUILD_CFLAGS += $(call cc-option,-fno-tree-scev-cprop,)
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \

