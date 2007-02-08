Return-Path: <linux-kernel-owner+w=401wt.eu-S1423010AbXBHNRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423010AbXBHNRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 08:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423006AbXBHNRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 08:17:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54244
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423008AbXBHNRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 08:17:09 -0500
Date: Thu, 08 Feb 2007 05:17:06 -0800 (PST)
Message-Id: <20070208.051706.112290704.davem@davemloft.net>
To: olecom@flower.upol.cz
Cc: paulus@samba.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Kbuild change breaks the ppc64 build
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070208124756.GU22699@flower.upol.cz>
References: <17867.1342.763881.188430@cargo.ozlabs.ibm.com>
	<20070208124756.GU22699@flower.upol.cz>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Verych <olecom@flower.upol.cz>
Date: Thu, 8 Feb 2007 13:47:56 +0100

> On Thu, Feb 08, 2007 at 10:10:54PM +1100, Paul Mackerras wrote:
> > Commit 5de043f4bd11a9e0a3e8daec7d1905da575a76b7 breaks the build on
> > 64-bit powerpc because we no longer get the -m64 flag passed to gcc.
> > There is code in arch/powerpc/Makefile which adds (or used to add)
> > -m64 to AS, LD and CC if we are running on a 64-bit machine (which I
> > am) and have a biarch toolchain (which I do).  Without -m64, the
> > toolchain assumes 32-bit and all sorts of things break spectacularly.
> > 
> > I haven't yet tracked down exactly why this commit has this effect,
> > since I find it takes considerable time and effort to understand
> > Kbuild.
> 
> As i have refactored some CC checking code in Kbuild.include, it
> turned, that some versions of `make' after calling nested functions,
> add (or leave) prefix whitespace to result, thus ifeq[0] fails:

That's not it, did you see my fix for this problem posted
already?  The issue is the leading spaces on the first
line of the define for checker-shell.  Those propagate
into the callers, although they are reduced down to a
single space.

This will give you spaces in the result on any version of
make.

Here is my fix again for your reference.

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 8d7eabf..a1880e8 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -60,16 +60,15 @@ endef
 # Usage: option = $(call checker-shell,$(CC)...-o $$OUT,option-ok,otherwise)
 # Exit code chooses option. $$OUT is safe location for needless output.
 define checker-shell
- $(strip
-  $(shell set -e; \
-    DIR=$(KBUILD_EXTMOD); \
-    cd $${DIR:-$(objtree)}; \
-    OUT=$$PWD/.$$$$.null; \
-    if $(1) >/dev/null 2>&1; \
-      then echo "$(2)"; \
-      else echo "$(3)"; \
-    fi; \
-    rm -f $$OUT))
+$(shell set -e; \
+  DIR=$(KBUILD_EXTMOD); \
+  cd $${DIR:-$(objtree)}; \
+  OUT=$$PWD/.$$$$.null; \
+  if $(1) >/dev/null 2>&1; \
+    then echo "$(2)"; \
+    else echo "$(3)"; \
+  fi; \
+  rm -f $$OUT)
 endef
 
 # as-option

