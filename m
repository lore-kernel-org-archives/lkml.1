Return-Path: <linux-kernel-owner+w=401wt.eu-S1946066AbXBID3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946066AbXBID3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 22:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946054AbXBID3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 22:29:54 -0500
Received: from mga05.intel.com ([192.55.52.89]:6105 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946052AbXBID3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 22:29:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,303,1167638400"; 
   d="scan'208"; a="197688866:sNHT21514570"
Subject: Re: [PATCH] ATA convert GSI to irq on ia64
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <45CBCC31.7070909@garzik.org>
References: <1170920422.15989.354.camel@ymzhang>
	 <45CBCC31.7070909@garzik.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 09 Feb 2007 11:29:51 +0800
Message-Id: <1170991791.15989.364.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 20:19 -0500, Jeff Garzik wrote:
> Zhang, Yanmin wrote:
> > If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
> > fixed irq number. On ia64 platform, such numbers are GSI and should be converted
> > to irq vector.
> > 
> > Below patch against kernel 2.6.20 fixes it.
> > 
> > Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> 
> IA64 should create its own libata-portmap.h, rather than modifying the 
> one in asm-generic with arch-specific choices.
> 
> powerpc is a current example of this (and currently the only 
> non-asm-generic user) found in kernel 2.6.20.
Thank Jeff. I worked out a new patch.

If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the fixed
irq number. On ia64 platform, such numbers are GSI and should be converted to irq
vector.

Below patch against kernel 2.6.20 fixes it.
 
Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

---

diff -Nraup linux-2.6.20/arch/ia64/Kconfig linux-2.6.20_fix/arch/ia64/Kconfig
--- linux-2.6.20/arch/ia64/Kconfig	2007-02-08 15:13:41.000000000 +0800
+++ linux-2.6.20_fix/arch/ia64/Kconfig	2007-02-09 11:19:35.000000000 +0800
@@ -11,6 +11,7 @@ menu "Processor type and features"
 
 config IA64
 	bool
+	select ATA_NONSTANDARD if ATA
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff -Nraup linux-2.6.20/include/asm-ia64/libata-portmap.h linux-2.6.20_fix/include/asm-ia64/libata-portmap.h
--- linux-2.6.20/include/asm-ia64/libata-portmap.h	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6.20_fix/include/asm-ia64/libata-portmap.h	2007-02-09 11:19:55.000000000 +0800
@@ -0,0 +1,12 @@
+#ifndef __ASM_IA64_LIBATA_PORTMAP_H
+#define __ASM_IA64_LIBATA_PORTMAP_H
+
+#define ATA_PRIMARY_CMD		0x1F0
+#define ATA_PRIMARY_CTL		0x3F6
+#define ATA_PRIMARY_IRQ(dev)	isa_irq_to_vector(14)
+
+#define ATA_SECONDARY_CMD	0x170
+#define ATA_SECONDARY_CTL	0x376
+#define ATA_SECONDARY_IRQ(dev)	isa_irq_to_vector(15)
+
+#endif
