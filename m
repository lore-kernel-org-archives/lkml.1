Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbZG3LAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbZG3LAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 07:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZG3LAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 07:00:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbZG3LAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 07:00:34 -0400
Date: Thu, 30 Jul 2009 03:59:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alek Du <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3] gpio: add Intel Moorestown Platform Langwell chip
 gpio driver
Message-Id: <20090730035941.16124ec0.akpm@linux-foundation.org>
In-Reply-To: <20090703210706.41288a2a@dxy.sh.intel.com>
References: <20090703210706.41288a2a@dxy.sh.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 21:07:06 +0800 Alek Du <alek.du@intel.com> wrote:

> Changes from v2:
> 1. Add missed MODULE_DEVICE_TABLE
> 
> Changes from v1:
> 1. driver name changed from lnw.c ==> langwell_gpio.c
> 2. removed hard coded driver data, now we get it from PCI bar1 (platform init code fills it)
> 3. removed alternative function setting code, it should be called in platform init part.
> 4. misc. style clean
> 
> 
> >From 8eaad3aac8cffda193adcfc4b9fcbb7c461fd4b9 Mon Sep 17 00:00:00 2001
> From: Alek Du <alek.du@intel.com>
> Date: Tue, 30 Jun 2009 12:13:27 +0800
> Subject: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio driver
> 
> The Langwell chip is the IO hub for Intel Moorestown platform which has a
> 64-pin gpio block device inside. It is exposed as a dedicated PCI device.
> We use it to control outside peripheral as well as to do IRQ demuxing. The
> gpio block uses MSI to send level type interrupt to IOAPIC.

The driver breaks the x86-64 allmodconfig build:

ERROR: "irq_to_desc" [drivers/gpio/langwell_gpio.ko] undefined!
ERROR: "set_irq_chip_and_handler_name" [drivers/gpio/langwell_gpio.ko] undefined!
ERROR: "handle_simple_irq" [drivers/gpio/langwell_gpio.ko] undefined!

Does it make any sense to build this driver as a module?  If not, it
should be changed to def_bool.  If so...



 kernel/irq/chip.c   |    2 ++
 kernel/irq/handle.c |    1 +
 2 files changed, 3 insertions(+)

diff -puN kernel/irq/handle.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch kernel/irq/handle.c
--- a/kernel/irq/handle.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch
+++ a/kernel/irq/handle.c
@@ -192,6 +192,7 @@ struct irq_desc *irq_to_desc(unsigned in
 
 	return NULL;
 }
+EXPORT_SYMBOL(irq_to_desc);
 
 struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
 {
diff -puN kernel/irq/chip.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch kernel/irq/chip.c
--- a/kernel/irq/chip.c~kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch
+++ a/kernel/irq/chip.c
@@ -340,6 +340,7 @@ handle_simple_irq(unsigned int irq, stru
 out_unlock:
 	spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL(handle_simple_irq);
 
 /**
  *	handle_level_irq - Level type irq handler
@@ -609,6 +610,7 @@ set_irq_chip_and_handler_name(unsigned i
 	set_irq_chip(irq, chip);
 	__set_irq_handler(irq, handle, 0, name);
 }
+EXPORT_SYMBOL(set_irq_chip_and_handler_name);
 
 void __init set_irq_noprobe(unsigned int irq)
 {
_


