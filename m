Return-Path: <linux-kernel-owner+w=401wt.eu-S932958AbXBLDvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbXBLDvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932959AbXBLDvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:51:13 -0500
Received: from ozlabs.org ([203.10.76.45]:51055 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958AbXBLDvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:51:12 -0500
Subject: [PATCH 4/8] lguest: Makefile
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <1171252113.10409.30.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
	 <1171251185.10409.4.camel@localhost.localdomain>
	 <1171251258.10409.7.camel@localhost.localdomain>
	 <1171251335.10409.10.camel@localhost.localdomain>
	 <1171251406.10409.13.camel@localhost.localdomain>
	 <1171251471.10409.15.camel@localhost.localdomain>
	 <1171251578.10409.17.camel@localhost.localdomain>
	 <1171251698.10409.20.camel@localhost.localdomain>
	 <1171251770.10409.23.camel@localhost.localdomain>
	 <1171251894.10409.26.camel@localhost.localdomain>
	 <1171251965.10409.28.camel@localhost.localdomain>
	 <1171252113.10409.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:50:19 +1100
Message-Id: <1171252219.10409.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, we put in the Makefile, so it will build.

Linking the switcher code (hypervisor.S) ready to be copied
into the top of memory is the only non-trivial thing here.

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


