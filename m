Return-Path: <linux-kernel-owner+w=401wt.eu-S936252AbXJPWCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936252AbXJPWCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935426AbXJPWCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:02:44 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53351 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935530AbXJPWCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:02:43 -0400
Date: Wed, 17 Oct 2007 00:04:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL (updated)] kbuild updates
Message-ID: <20071016220415.GA3035@uranus.ravnborg.org>
References: <20071015205018.GA24467@uranus.ravnborg.org> <20071016211101.GA4093@gentoox2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016211101.GA4093@gentoox2.trippelsdorf.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 11:11:01PM +0200, Markus Trippelsdorf wrote:
> Bisecting shows that:
> 
> commit f77bf01425b11947eeb3b5b54685212c302741b8
> 	Author: Sam Ravnborg <sam@neptun.(none)>
>  	Date:   Mon Oct 15 22:25:06 2007 +0200
> 
>     kbuild: introduce ccflags-y, asflags-y and ldflags-y
> 
> breaks booting with grub here. Grub stops with error 28: 
> Selected item cannot fit into memory.
> 
> Reverting the commit fixes the problem.
Thanks for this excellent report!
Following patch fixes the issue.
The target specific assignmnet used in x86/boot fooled kbuild.
I have audited the kernel for similar uses and found no
other places this was used.

Linus please pull the fix below from:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild.git

	Sam

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index d6ed8e5..e8756e5 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -64,10 +64,10 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
-$(obj)/zImage:  EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
+$(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_CFLAGS := -D__BIG_KERNEL__
-$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: ccflags-y := -D__BIG_KERNEL__
+$(obj)/bzImage: asflags-y := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
