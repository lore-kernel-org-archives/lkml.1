Return-Path: <linux-kernel-owner+w=401wt.eu-S1761677AbXKHS2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761677AbXKHS2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbXKHS2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:28:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:54344 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbXKHS2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:28:00 -0500
Date: Thu, 8 Nov 2007 19:29:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 0/6] MN10300: Add the MN10300 architecture to Linux kernel [try #4]
Message-ID: <20071108182937.GA26852@uranus.ravnborg.org>
References: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

A few comments to patch #5.
I only looked at the kbuild related stuff - and I have seen
stuff much worse than this.
Yet I have a few comments:

arch/mn10300/Makefile:

1) Use KBUILD_CFLAGS & KBUILD_AFLAGS & KBUILD_CPPFLAGS - they
have replaced the former xFLAGS.

2) Consider using unit-y as replacement for UNIT.
This enable you to do:
unit-$(CONFIG_MN10300_UNIT_ASB2303) += asb2303

3) Same for PROCESSOR => processor-y

4) Drop the symlinks - they are evil...
Use a structure like:
include/asm-mn10300/asb2303/proc/*.h

Then you adjust -I include/asm-mn10300/asb2303
and no symlinks needed.
And if you change processor kbuild will notice
and recompile everything.

No-one else does it this way but mn10300 could show how to do it.

5)
+zImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
+
+all: zImage
+
+Image: vmlinux
+	$(Q)$(MAKE) $(build)=arch/mn10300/boot $@

This could be done as:
+Image zImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@

And then modify boot/Makefile accordingly

6) archdep is long gone - delete the following

+archdep: scripts/mkdep symlinks
+	$(Q)$(MAKE) -C arch/mn10300/boot dep

7) Please set KBUILD_DEFCONFIG := asb2303_defconfig
This enable build monkeys(1) to do "make ARCH=mn10300 defconfig"

(1) such as me


arch/mn10300/boot/Makefile:

1) You can safely remove the copyright of Linus..
   Same goes for other places where his copyright are kept but filecontent
   is new.

2) The Image target is missing (as defined in arch/mn10300/Makefile
   Can you just kill it?


arch/mn10300/boot/compressed/Makefile:
1) Is -tarditional really needed. We try to kill it all over (slowly)

2) Please name the linker script *.lds


arch/mn10300/kernel/Makefile:
+# This next line shouldn't be necessary, but it is.
+CPPFLAGS += $(CPPFLAGS_$(@F))
+CPPFLAGS_asm-offsets.s = -D__ASM_OFFSETS_H__

Please explain why...


arch/mn10300/oprofile/Makefile:
+profdrvr-y				:= op_model_null.o
+
+oprofile-y				:= $(DRIVER_OBJS) $(profdrvr-y)

The variable profdrvr seems useless.

arch/mn10300/unit-asb2303/Makefile:

Please drop this wrong comment:
+# Note! Dependencies are done automagically by 'make dep', which also
+# removes any old dependencies. DON'T put your own dependencies here
+# unless it's something special (ie not a .c file).
+#
+# Note 2! The CFLAGS definitions are now in the main makefile...
+

Seen in other places where they are equally wrong/outdated.


	Sam

