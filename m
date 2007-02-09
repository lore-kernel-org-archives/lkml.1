Return-Path: <linux-kernel-owner+w=401wt.eu-S1946519AbXBIPWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946519AbXBIPWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946521AbXBIPWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:22:22 -0500
Received: from ozlabs.org ([203.10.76.45]:47900 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946519AbXBIPWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:22:22 -0500
Subject: [PATCH 7 of 7]  lguest: Makefile
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <1171034261.2718.182.camel@localhost.localdomain>
References: <1171033146.2718.157.camel@localhost.localdomain>
	 <1171033383.2718.163.camel@localhost.localdomain>
	 <1171033436.2718.165.camel@localhost.localdomain>
	 <1171033484.2718.167.camel@localhost.localdomain>
	 <1171033741.2718.172.camel@localhost.localdomain>
	 <1171034041.2718.177.camel@localhost.localdomain>
	 <1171034261.2718.182.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 02:21:37 +1100
Message-Id: <1171034498.2718.187.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This has no changes since 6d/10.  None!  Andi tried to make me change
it, but I defended it.  This one patch is unscathed.  Bwaha! ]

Finally, we put in the Makefile, so it will build.

There's a small complexity in creating the switcher code
(hypervisor.S) ready to be copied into the top of memory, but
it's not too bad.  Really.  Stop looking at me like that, Andi.
It's fine as it is.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -108,6 +108,7 @@ drivers-$(CONFIG_PCI)			+= arch/i386/pci
 # must be linked after kernel/
 drivers-$(CONFIG_OPROFILE)		+= arch/i386/oprofile/
 drivers-$(CONFIG_PM)			+= arch/i386/power/
+drivers-$(CONFIG_LGUEST_GUEST)		+= arch/i386/lguest/
 
 CFLAGS += $(mflags-y)
 AFLAGS += $(mflags-y)
===================================================================
--- /dev/null
+++ b/arch/i386/lguest/Makefile
@@ -0,0 +1,22 @@
+# Guest requires the paravirt_ops replacement and the bus driver.
+obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_bus.o
+
+# Host requires the other files, which can be a module.
+obj-$(CONFIG_LGUEST)	+= lg.o
+lg-objs := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
+	segments.o io.o lguest_user.o
+
+# We use top 4MB for guest traps page, then hypervisor. */
+HYPE_ADDR := (0xFFC00000+4096)
+# The data is only 1k (256 interrupt handler pointers)
+HYPE_DATA_SIZE := 1024
+CFLAGS += -DHYPE_ADDR="$(HYPE_ADDR)" -DHYPE_DATA_SIZE="$(HYPE_DATA_SIZE)"
+
+$(obj)/core.o: $(obj)/hypervisor-blob.c
+# This links the hypervisor in the right place and turns it into a C array.
+$(obj)/hypervisor-raw: $(obj)/hypervisor.o
+	@$(LD) -static -Tdata=`printf %#x $$(($(HYPE_ADDR)))` -Ttext=`printf %#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE)))` -o $@ $< && $(OBJCOPY) -O binary $@
+$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
+	@od -tx1 -An -v $< | sed -e 's/^ /0x/' -e 's/$$/,/' -e 's/ /,0x/g' > $@
+
+clean-files := hypervisor-blob.c hypervisor-raw


