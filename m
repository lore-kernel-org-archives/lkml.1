Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbXKDSWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbXKDSWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXKDSWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:22:32 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33346 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXKDSWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:22:31 -0500
Date: Sun, 4 Nov 2007 19:24:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, thomas@archlinux.org,
       tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] kbuild: do not pick up CFLAGS from the environment
Message-ID: <20071104182408.GC18771@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please apply following fix.

Pull from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/fix-kbuild.git

	Sam


>From 69ee0b3522428a07ff1765446d631ecc7da6ae0f Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 4 Nov 2007 19:00:46 +0100
Subject: [PATCH] kbuild: do not pick up CFLAGS from the environment
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Too many people have CFLAGS set to support building userspace.
And now Kbuild picks up CFLAGS this caused troubles.

Although people should realise that setting CFLAGS has
a 'global' effect the impact on the kernel build is a suprise.
So change kbuild to pick up value from KCFLAGS that is
much less used.

When kbuild pick up a value it will warn like this:
Makefile:544: "WARNING: Appending $KCFLAGS (-O3) from environment to kernel $CFLAGS"

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Bächler <thomas@archlinux.org>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
---
 Makefile |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 188c3b6..cb740d4 100644
--- a/Makefile
+++ b/Makefile
@@ -528,9 +528,22 @@ KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
-KBUILD_CPPFLAGS += $(CPPFLAGS)
-KBUILD_AFLAGS   += $(AFLAGS)
-KBUILD_CFLAGS   += $(CFLAGS)
+# But warn user when we do so
+warn-assign = \
+$(warning "WARNING: Appending $$K$(1) ($(K$(1))) from $(origin K$(1)) to kernel $$$(1)")
+
+ifneq ($(KCPPFLAGS),)
+        $(call warn-assign,CPPFLAGS)
+        KBUILD_CPPFLAGS += $(KCPPFLAGS)
+endif
+ifneq ($(KAFLAGS),)
+        $(call warn-assign,AFLAGS)
+        KBUILD_AFLAGS += $(KAFLAGS)
+endif
+ifneq ($(KCFLAGS),)
+        $(call warn-assign,CFLAGS)
+        KBUILD_CFLAGS += $(KCFLAGS)
+endif
 
 # Use --build-id when available.
 LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
-- 
1.5.3.4.1157.g0e74-dirty

