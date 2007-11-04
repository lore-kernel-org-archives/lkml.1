Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbXKDLPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbXKDLPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 06:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbXKDLPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 06:15:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33526 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbXKDLPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 06:15:03 -0500
Date: Sun, 4 Nov 2007 12:16:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, bunk@kernel.org, thomas@archlinux.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
Message-ID: <20071104111640.GA17565@uranus.ravnborg.org>
References: <20071103121149.GA22149@uranus.ravnborg.org> <20071104020217.GJ12045@stusta.de> <20071104100429.GA12311@elte.hu> <20071104.023133.241080055.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071104.023133.241080055.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I totally disagree.
> 
> People can't have it both ways.  CFLAGS has global meaning in every
> Makefile based build tree, it's not an "autoconf" thing.  This is well
> established practice, and I think it's a good thing the kernel does it
> now too.
> 
> If people set something like CFLAGS in their environment, they must
> understand what that means, and it means that universally it will
> influence your Makefile based builds.  Yes, this means all of them and
> even potentially the kernel build.
I'm afraid some people do not realize a whit about what they do.
So at least we could let kbuild warn about it.
Something like this:

$ export CFLAGS=-O3
$ make AFLAGS=-fisk
Makefile:540: "Appending $AFLAGS (-fisk) from command line to kernel defined $AFLAGS"
Makefile:544: "Appending $CFLAGS (-O3) from environment to kernel defined $CFLAGS"
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm-x86/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      scripts/mod/empty.o


This patch is needed to do so.

If one does a make O=... build then they will see the warning(s) twice.

	Sam

diff --git a/Makefile b/Makefile
index 188c3b6..1ae8779 100644
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
+$(warning "Appending $$$(1) ($($(1))) from $(origin $(1)) to kernel defined $$$(1)")
+
+ifneq ($(CPPFLAGS),)
+        $(call warn-assign,CPPFLAGS)
+        KBUILD_CPPFLAGS += $(CPPFLAGS)
+endif
+ifneq ($(AFLAGS),)
+        $(call warn-assign,AFLAGS)
+        KBUILD_AFLAGS += $(AFLAGS)
+endif
+ifneq ($(CFLAGS),)
+        $(call warn-assign,CFLAGS)
+        KBUILD_CFLAGS += $(CFLAGS)
+endif
 
 # Use --build-id when available.
 LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
