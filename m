Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZHGVIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZHGVIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZHGVIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:08:19 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55517 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZHGVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:08:18 -0400
Date: Fri, 7 Aug 2009 23:08:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Matthieu CASTET <matthieu.castet@parrot.com>,
       Alain Knaff <alain@knaff.lu>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
Message-ID: <20090807210816.GA29797@merkur.ravnborg.org>
References: <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com> <20090806224055.GH31579@n2100.arm.linux.org.uk> <20090807092423.GA4455@laptop> <4A7BF5B8.4030907@knaff.lu> <20090807102117.GB4455@laptop> <4A7C14EB.1060701@parrot.com> <20090807130130.GE4455@laptop> <4A7C2BA4.7030408@parrot.com> <20090807135524.GF4455@laptop> <20090807200001.GE31543@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807200001.GE31543@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:00:01PM +0100, Russell King - ARM Linux wrote:
> On Fri, Aug 07, 2009 at 03:55:24PM +0200, Albin Tonnerre wrote:
> > That's true for the actual kernel image, but not for the bootstrap code we use
> > when compiling compressed kernels. arch/arm/boot/compressed/Makefile uses
> > libgcc, unless I'm overlooking something here:
> > 
> >   arm-unknown-linux-uclibcgnueabi-ld -EL    --defsym zreladdr=0x20008000
> >   --defsym initrd_phys=0x20410000 --defsym params_phys=0x20000100 -p
> >   --no-undefined -X
> >   /home/albin/x-tools/arm-unknown-linux-uclibcgnueabi/lib/gcc/arm-unknown-linux-uclibcgnueabi/4.3.2/libgcc.a
> >   -T arch/arm/boot/compressed/vmlinux.lds arch/arm/boot/compressed/head.o
> >   arch/arm/boot/compressed/piggy.gzip.o arch/arm/boot/compressed/misc.o -o
> >   arch/arm/boot/compressed/vmlinux
> 
> It's because libgcc appears in the wrong place in the command line, and
> due to the way kbuild works, we can't get it into the right place easily.
> 
> Linkers are sensitive to the order of archives on the command line - its
> pointless having an archive as the first file argument because none of
> the contained objects will ever be pulled in.
> 
> Sam - any ideas how to solve this?

We could add libgcc as a prerequisite.
Untested patch below.


This is a ittle hackish - otherwise we have to change the
definition of ld or use a private version.

I added explanations for some of the linker symbols when
I was there. I cannot the ld options.

If you decide to use this it has my:

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>


	Sam


diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index ce39dc5..4f980f2 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -87,15 +87,24 @@ endif
 ifneq ($(PARAMS_PHYS),)
 LDFLAGS_vmlinux += --defsym params_phys=$(PARAMS_PHYS)
 endif
-LDFLAGS_vmlinux += -p --no-undefined -X \
-       $(shell $(CC) $(KBUILD_CFLAGS) --print-libgcc-file-name) -T
+
+# ?
+LDFLAGS_vmlinux += -p
+# Report unresolved symbol references
+LDFLAGS_vmlinux += --no-undefined
+# Delete all temporary local symbols
+LDFLAGS_vmlinux += -X
+# Next argument is a linker script
+LDFLAGS_vmlinux += -T
+
+libgcc = $(shell $(CC) $(KBUILD_CFLAGS) --print-libgcc-file-name)
 
 # Don't allow any static data in misc.o, which
 # would otherwise mess up our GOT table
 CFLAGS_misc.o := -Dstatic=
 
 $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.o \
-               $(addprefix $(obj)/, $(OBJS)) FORCE
+               $(addprefix $(obj)/, $(OBJS)) $(libgcc) FORCE
        $(call if_changed,ld)
        @:
 


	Sam
