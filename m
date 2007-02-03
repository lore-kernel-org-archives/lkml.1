Return-Path: <linux-kernel-owner+w=401wt.eu-S1946255AbXBCCtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946255AbXBCCtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946265AbXBCCig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:38:36 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52989 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946264AbXBCCi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:26 -0500
Message-Id: <20070203023738.549546000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:05 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Maxime Bizon <mbizon@freebox.fr>,
       Mark A Greer <mgreer@mvista.com>
Subject: [patch 01/59] i2c-mv64xxx: Fix random oops at boot
Content-Disposition: inline; filename=i2c-mv64xxx-fix-random-oops-at-boot.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Maxime Bizon <mbizon@freebox.fr>

I have a Marvell board which has the same i2c hw block than mv64xxx, so
I'm trying to use i2c-mv64xxx driver.

But I get the following random oops at boot:

Unable to handle kernel NULL pointer dereference at virtual address 00000002
Backtrace: 
[<c0397e4c>] (mv64xxx_i2c_intr+0x0/0x2b8) from [<c02879c4>] (__do_irq+0x4c/0x8c)
[<c0287978>] (__do_irq+0x0/0x8c) from [<c0287c0c>] (do_level_IRQ+0x68/0xc0)
 r8 = C0501E08  r7 = 00000005  r6 = C0501E08  r5 = 00000005
 r4 = C048BB78 
[<c0287ba4>] (do_level_IRQ+0x0/0xc0) from [<c02885f8>] (asm_do_IRQ+0x50/0x134)
 r6 = C0449C78  r5 = F1020000  r4 = FFFFFFFF 
[<c02885a8>] (asm_do_IRQ+0x0/0x134) from [<c02869c4>] (__irq_svc+0x24/0x100)
 r8 = C1CAC400  r7 = 00000005  r6 = 00000002  r5 = F1020000
 r4 = FFFFFFFF 
[<c0287efc>] (setup_irq+0x0/0x124) from [<c02880d0>] (request_irq+0xb0/0xd0)
 r7 = C041B2AC  r6 = C0397E4C  r5 = 00000000  r4 = 00000005
[<c0288020>] (request_irq+0x0/0xd0) from [<c03985f4>] (mv64xxx_i2c_probe+0x148/0x244)
[<c03984ac>] (mv64xxx_i2c_probe+0x0/0x244) from [<c038bedc>] (platform_drv_probe+0x20/0x24)


The oops is caused by a spurious interrupt that occurs when request_irq
is called. mv64xxx_i2c_fsm() tries to read drv_data->msg, which is NULL.

I noticed that hardware init is done after requesting irq. Thus any
pending irq from previous hardware usage may cause this.

The following patch fixes it:

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Acked-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Merged in 2.6.20-rc4:
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3269bb63eb076318ce4fb554851d047e1c9aa1a5

 drivers/i2c/busses/i2c-mv64xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/drivers/i2c/busses/i2c-mv64xxx.c
+++ linux-2.6.19.2/drivers/i2c/busses/i2c-mv64xxx.c
@@ -529,6 +529,8 @@ mv64xxx_i2c_probe(struct platform_device
 	platform_set_drvdata(pd, drv_data);
 	i2c_set_adapdata(&drv_data->adapter, drv_data);
 
+	mv64xxx_i2c_hw_init(drv_data);
+
 	if (request_irq(drv_data->irq, mv64xxx_i2c_intr, 0,
 			MV64XXX_I2C_CTLR_NAME, drv_data)) {
 		dev_err(&drv_data->adapter.dev,
@@ -542,8 +544,6 @@ mv64xxx_i2c_probe(struct platform_device
 		goto exit_free_irq;
 	}
 
-	mv64xxx_i2c_hw_init(drv_data);
-
 	return 0;
 
 	exit_free_irq:

--
