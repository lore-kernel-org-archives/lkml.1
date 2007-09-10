Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbXIJUda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbXIJUda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbXIJUdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:33:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52816 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685AbXIJUdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:33:22 -0400
Date: Mon, 10 Sep 2007 22:34:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [RFC] kbuild - introduce vdir to make life easier for x86_64
Message-ID: <20070910203445.GA32047@uranus.ravnborg.org>
References: <20070910191138.GA31541@uranus.ravnborg.org> <1189452121.25767.42.camel@chaos> <20070910192920.GA2080@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910192920.GA2080@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo 
> 
> i'd like to add it here that Makefile polishing is important - it's just 
> that in the context of arch/*x86* the Makefile impact of the current 
> cross-arch code sharing practice is one of the smaller problems and the 
> Makefiles get cleaned up via the arch/x86 merge anyway.

Partly so. Took a look at the x86 tree.
The main Makefile are at least not merged. Neither are pci/Makefile not
boot/compressed/Makefile.
And some of the rest of the Makefiles are not pretty with the huge arch 
specific sections ifdeffed out.

I have long thought about some extensions to the kbuild 'language'
along the following lines:

Additional shorthands for obj-m:
obj-m-if-m
obj-m-if-y   
obj-m-ifn-

Additional shorthands for obj-y:
obj-y-if-m
obj-y-if-y
obj-y-ifn-

The ifn- versions are to test for empty options.

This may as an example result in following changes to the 
acpi/Makefile in the merged tree:

 Makefile |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index ad4baa6..ec5a295 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,15 +1,11 @@
 obj-$(CONFIG_ACPI)		+= boot.o
 
-ifeq ($(CONFIG_X86_32),y)
 ifneq ($(CONFIG_PCI),)
-obj-$(CONFIG_X86_IO_APIC)	+= earlyquirk.o
-endif
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep_32.o wakeup_32.o
-else
-obj-$(CONFIG_ACPI_SLEEP)	+= sleep_64.o wakeup_64.o
+obj-$(CONFIG_X86_32)-if-$(CONFIG_X86_IO_APIC) += sleep_32.o wakeup_32.o
 endif
 
-ifneq ($(CONFIG_ACPI_PROCESSOR),)
-obj-y				+= cstate.o processor.o
-endif
+obj-$(CONFIG_X86_32)-if-$(CONFIG_ACPI_SLEEP) += sleep_32.o wakeup_32.o
+obj-$(CONFIG_X86_64)-if-$(CONFIG_ACPI_SLEEP) += sleep_64.o wakeup_64.o
+
+obj-y-if-$(CONFIG_ACPI_PROCESSOR) += cstate.o processor.o


My biggest worry is that we end up with a more compact format
but only me (and a very few others) can read it.
But I think the above could make the x86 Makefiles more readable
as a whole.

	Sam 
