Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZKBDMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZKBDMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 22:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZKBDMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 22:12:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39331 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbZKBDMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 22:12:07 -0500
Date: Mon, 2 Nov 2009 14:12:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philby John <pjohn@in.mvista.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the catalin tree with the arm-current
 tree
Message-Id: <20091102141204.167b4aaa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Today's linux-next merge of the catalin tree got a conflict in
arch/arm/mach-realview/core.h arch/arm/mach-realview/realview_pb1176.c
between commit 426fcd2a351e4bf662fee9fa2cf2603a48223164 ("ARM: 5774/1:
Fix Realview ARM1176PB board reboot") from the arc-current tree and
commit 35c6a7ecaa2aafd03dd5d62aa11fbc7a12b82520 ("RealView: Add default
memory configuration") from the catalin tree.

Overlapping additions.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-realview/core.h
index 699671f,1398854..0000000
--- a/arch/arm/mach-realview/core.h
+++ b/arch/arm/mach-realview/core.h
@@@ -61,5 -64,7 +64,7 @@@ extern void realview_timer_init(unsigne
  extern int realview_flash_register(struct resource *res, u32 num);
  extern int realview_eth_register(const char *name, struct resource *res);
  extern int realview_usb_register(struct resource *res);
+ extern void realview_fixup(struct machine_desc *mdesc, struct tag *tags,
+ 			   char **from, struct meminfo *meminfo);
 -
 +extern void (*realview_reset)(char);
  #endif
diff --cc arch/arm/mach-realview/realview_pb1176.c
index a6ba147,b1cdd37..0000000
--- a/arch/arm/mach-realview/realview_pb1176.c
+++ b/arch/arm/mach-realview/realview_pb1176.c
@@@ -290,16 -290,18 +290,28 @@@ static struct sys_timer realview_pb1176
  	.init		= realview_pb1176_timer_init,
  };
  
 +static void realview_pb1176_reset(char mode)
 +{
 +	void __iomem *hdr_ctrl = __io_address(REALVIEW_SYS_BASE) +
 +		REALVIEW_SYS_RESETCTL_OFFSET;
 +	void __iomem *rst_hdr_ctrl = __io_address(REALVIEW_SYS_BASE) +
 +		REALVIEW_SYS_LOCK_OFFSET;
 +	__raw_writel(REALVIEW_SYS_LOCKVAL_MASK, rst_hdr_ctrl);
 +	__raw_writel(REALVIEW_PB1176_SYS_LOCKVAL_RSTCTL, hdr_ctrl);
 +}
 +
+ static void realview_pb1176_fixup(struct machine_desc *mdesc,
+ 				  struct tag *tags, char **from,
+ 				  struct meminfo *meminfo)
+ {
+ 	/*
+ 	 * RealView PB1176 only has 128MB of RAM mapped at 0.
+ 	 */
+ 	meminfo->bank[0].start = 0;
+ 	meminfo->bank[0].size = SZ_128M;
+ 	meminfo->nr_banks = 1;
+ }
+ 
  static void __init realview_pb1176_init(void)
  {
  	int i;
