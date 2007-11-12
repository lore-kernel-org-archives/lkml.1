Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbXKLGPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbXKLGPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 01:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXKLGO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 01:14:59 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51886 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285AbXKLGO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 01:14:58 -0500
Date: Mon, 12 Nov 2007 07:14:34 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: the kernel, gcc and libgcc
Message-ID: <20071112061434.GB9771@stusta.de>
References: <20071111064829.GG21669@stusta.de> <20071111073422.GA25323@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071111073422.GA25323@linux-sh.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ linux-arch added to the Cc,
  a copy of my original email is at the bottom ]

On Sun, Nov 11, 2007 at 04:34:22PM +0900, Paul Mundt wrote:
> On Sun, Nov 11, 2007 at 07:48:29AM +0100, Adrian Bunk wrote:
> > But the kernel does (at least on some architectures) not link with 
> > libgcc or ship other code providing the required libgcc functions.
> > 
> > Richard Guenther suggested in gcc bug #32044 to use -fno-tree-scev-cprop 
> > (new option in gcc 4.3) as a workaround and I confirmed that it fixes 
> > the compilation.
> > 
> And some architectures do link it in, so the call to libgcc code doesn't
> necessarily matter. Perhaps the architectures that don't link in libgcc
> can turn this flag on conditionally, it shouldn't be forced on the
> architectures that do link it in.

We seem to have 3 different kinds of architectures:
- does not provide libgcc at all
- provides part of libgcc itself
- links with libgcc

And we also _might_ get away without requiring -fno-tree-scev-cprop on 
some of the 64bit architectures that do not provide or link with libgcc.

This all is horrible fragile, with the root of the problem being a 
disagreement between what gcc expects an environment to provide and what 
the kernel provides.

After all, the real question is not whether we are able to limit the 
workaround of disabling a minor optimization to fewer architectures,
but to get this fixed properly.

Ideally, we solve the latter making my patch not required on any 
architecture.

cu
Adrian



<--  snip  -->


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

