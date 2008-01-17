Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbYAQWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbYAQWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbYAQWPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:15:45 -0500
Received: from free-electrons.com ([88.191.23.47]:35881 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120AbYAQWPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:15:44 -0500
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] x86: fix unconditional =?utf-8?q?arch/x86/kernel/pcspeaker=2Ec=09compiling?=
Date: Thu, 17 Jan 2008 23:15:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Linux-tiny@selenic.com,
       Ingo Molnar <mingo@elte.hu>
References: <200801171643.49301.michael-lists@free-electrons.com> <478F8AEC.1080209@free-electrons.com> <1200590031.5332.19.camel@cinder.waste.org>
In-Reply-To: <1200590031.5332.19.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801172315.29976.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008, Matt Mackall wrote:
> > >> diff -Naur linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32 linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32
> > >> --- linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32	2008-01-17 09:48:58.000000000 +0100
> > >> +++ linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32	2008-01-17 10:06:56.000000000 +0100
> > >> @@ -45,10 +45,13 @@
> > >>  
> > >>  obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
> > >>  obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
> > >> -obj-y				+= pcspeaker.o
> > >> -
> > >>  obj-$(CONFIG_SCx200)		+= scx200_32.o
> > >>  
> > >> +ifeq ($(CONFIG_INPUT_PCSPKR),y)
> > >> +	obj-y			+= pcspeaker.o
> > >> +endif
> > >>     
> > >
> > > I'm not sure this does what you want. What if CONFIG_INPUT_PCSPKR = m?
> > >   
> > Does it make sense to compile arch/x86/kernel/pcspeaker.c as a module?
> > It defines no init and exit functions, and it defines an initcall, which
> > only makes sense at boot time.
> 
> Probably not. However, the above code won't build pcspeaker.o if
> CONFIG_INPUT_PCSPKR = m. In other words, it'll break.
> 

Here's a corrected version.

Even if this patch doesn't seem to cause any bug
(tested on a QEMU based PC), I'm wondering if this is "legal" (according
to Linux standards) not to declare a device we don't care about,
but that probably always exists in any PC-compatible machine?
Doesn't this hurt the consistency of the device model?

Another issue would be that we would no longer be able 
to load the speaker driver module from a kernel which
wasn't originally compiled with support for this module.

Perhaps we should only use this trick when CONFIG_EMBEDDED is set.
In this case, we know we're using a limited, non-standard kernel,
and having a partial device tree could be acceptable.

What do you think?

Thanks,

Michael.

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>

diff -Naur linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32 linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32
--- linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32	2008-01-17 09:48:58.000000000 +0100
+++ linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32	2008-01-17 22:43:33.000000000 +0100
@@ -45,10 +45,13 @@
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
-obj-y				+= pcspeaker.o
-
 obj-$(CONFIG_SCx200)		+= scx200_32.o
 
+ifdef CONFIG_INPUT_PCSPKR
+	obj-y			+= pcspeaker.o
+endif
+
+
 # vsyscall_32.o contains the vsyscall DSO images as __initdata.
 # We must build both images before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
diff -Naur linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_64 linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_64
--- linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_64	2008-01-17 09:48:58.000000000 +0100
+++ linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_64	2008-01-17 22:46:07.000000000 +0100
@@ -40,6 +40,9 @@
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
 obj-y				+= topology.o
-obj-y				+= pcspeaker.o
+
+ifdef CONFIG_INPUT_PCSPKR
+        obj-y			+= pcspeaker.o
+endif
 
 CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
