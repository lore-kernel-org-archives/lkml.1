Return-Path: <linux-kernel-owner+w=401wt.eu-S932695AbXJQTJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbXJQTJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759179AbXJQTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:05:12 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55454 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054AbXJQTFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:05:09 -0400
Date: Wed, 17 Oct 2007 21:06:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-git11 compile issues
Message-ID: <20071017190635.GA11837@uranus.ravnborg.org>
References: <1192635199.14504.2.camel@dyn9047017100.beaverton.ibm.com> <1192640594.17464.37.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192640594.17464.37.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 10:03:14AM -0700, Dave Hansen wrote:
> On Wed, 2007-10-17 at 08:33 -0700, Badari Pulavarty wrote:
> > Known issue ?
> ...
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   CC      arch/x86/kernel/asm-offsets.s
> > In file included from arch/x86/kernel/asm-offsets_64.c:7,
> >                  from arch/x86/kernel/asm-offsets.c:4:
> > include/linux/crypto.h:20:24: error: asm/atomic.h: No such file or directory
> > In file included from include/linux/types.h:14,
> >                  from include/linux/prefetch.h:13,
> >                  from include/linux/list.h:8,
> >                  from include/linux/module.h:9,
> >                  from include/linux/crypto.h:21,
> >                  from arch/x86/kernel/asm-offsets_64.c:7,
> >                  from arch/x86/kernel/asm-offsets.c:4:
> 
> I hit the same thing, and fixed it with mrproper as well.  I assume this
> is a result of the x86 merge.
> 
> Andi, is there a way we can detect the old include directories, and
> error out?  Otherwise, we're going to get a ton more of these reports
> when people do incremental patching up to 2.6.24.  I've been doing
> nightly incremental builds for a year or two, and I think this is the
> first time it has actually required manual intervention.

Hi Dave.
I cooked up the following patch - can you try it out in your
environment.
I wonder if this is that simple since no-one have done it before??


	Sam

diff --git a/Makefile b/Makefile
index ed65de7..136d7c2 100644
--- a/Makefile
+++ b/Makefile
@@ -903,14 +903,24 @@ prepare: prepare0
 
 export CPPFLAGS_vmlinux.lds += -P -C -U$(ARCH)
 
-# FIXME: The asm symlink changes when $(ARCH) changes. That's
-# hard to detect, but I suppose "make mrproper" is a good idea
-# before switching between archs anyway.
-
-include/asm:
-	@echo '  SYMLINK $@ -> include/asm-$(SRCARCH)'
-	$(Q)if [ ! -d include ]; then mkdir -p include; fi;
-	@ln -fsn asm-$(SRCARCH) $@
+# The asm symlink changes when $(ARCH) changes.
+# Detect this and ask user to run make mrproper
+
+include/asm: FORCE
+	$(Q)set -e; asmlink=`readlink include/asm | cut -d '-' -f 2`;   \
+	if [ -L include/asm ]; then                                     \
+		if [ "$$asmlink" != "$(SRCARCH)" ]; then                \
+			echo "ERROR: the symlink $@ points to asm-$$asmlink but asm-$(SRCARCH) was expected"; \
+			echo "       save .config and run 'make mrproper' to fix it";                         \
+			exit 1;                                         \
+		fi;                                                     \
+	else                                                            \
+		echo '  SYMLINK $@ -> include/asm-$(SRCARCH)';          \
+		if [ ! -d include ]; then                               \
+			mkdir -p include;                               \
+		fi;                                                     \
+		ln -fsn asm-$(SRCARCH) $@;                              \
+	fi
 
 # Generate some files
 # ---------------------------------------------------------------------------
