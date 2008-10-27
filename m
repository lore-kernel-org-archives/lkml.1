Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbYJ0Vjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbYJ0Vjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYJ0ViO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:38:14 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42647 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752561AbYJ0ViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:38:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VMlsSenTXsrWDNxaA7mcRegPx2tbnkx8Hnm+orO9N81cv88X5hHbu6tuSx4u2XGiyKLsnsVtPJ54y1SbzMHbfrvTk1zEkhVLUNSpjP1zx6NUWJUO6mk9Vz5fHPLkpLaZl3F66jCzAQNK1TPD08mduKyTfybTnQ0Cyvf0BUFOZ4I=  ;
X-YMail-OSG: 2o4Z3oQVM1nnoc.Hu7zzmfBIpJh.cnywVfBkA6tH_5HYJjKoTnwYLvrrqTd0JarZdgOZD.M7zSTd4ht5rqe5h2p6_PErJf4NX6lEWx3iqL7GKiwYP9AE_Khsgmc3ssJlkhR0Vck9D0s3Gnq9EUY30QWdVjFmdB1fSUAC0H.n7wBRk2MO67mlEPXxqZAu
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [patch 2.6.28-rc2] at91_mci: workaround lockdep
Date: Mon, 27 Oct 2008 14:26:26 -0700
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, peterz@infradead.org,
       Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271426.27110.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Lockdep reported a problem in the at91_mci driver ... in this case, the
issue is with lockdep, not with the driver.  A trimmed stack dump, from
trying to boot with root on MMC, shows:

  WARNING: at kernel/lockdep.c:2195 trace_hardirqs_on_caller+0xf4/0x170()
  Modules linked in:
  [<c005bc98>] (trace_hardirqs_on+0x0/0x18) from [<c0213bf4>] (_spin_unlock_irq+0x2c/0x3c)
  [<c0213bc8>] (_spin_unlock_irq+0x0/0x3c) from [<c0029a88>] (flush_dcache_page+0x114/0x144)
  [<c0029974>] (flush_dcache_page+0x0/0x144) from [<c019b034>] (at91_mci_irq+0x150/0x414)
  [<c019aee4>] (at91_mci_irq+0x0/0x414) from [<c0066c5c>] (handle_IRQ_event+0x2c/0x6c)
  [<c0066c30>] (handle_IRQ_event+0x0/0x6c) from [<c0068a60>] (handle_level_irq+0x108/0x124)
  [<c0068958>] (handle_level_irq+0x0/0x124) from [<c0022064>] (__exception_text_start+0x64/0x90)

When __flush_dcache_aliases() returns -- inlined into flush_dcache_page(),
above -- it re-enables IRQs ... since that evidently may only be called with
IRQs enabled.  That's OK since the (unshared) IRQ handler doesn't ask for IRQs
to be disabled.   Except ... that lockdep went and disabled them, then went on
to complains about the breakage *it* caused!

Workaround: depend on LOCKDEP=n ... and for paranoia, disable IRQF_SHARED
for this interrupt.  (At the hardware level, this is dedicated to MCI, so
there's never a need for multiple handlers.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
An alternate fix might be to have ARM dcache mmap locking save and restore
the IRQ flags ... but there are several such "can't run with IRQs disabled"
restrictions scattered through that code, with no rationales commented.  Or
stop lockdep from mucking with IRQ flags; probably not any time soon!

So for now, this seems to be the best "solution" available...

 drivers/mmc/host/Kconfig    |    1 +
 drivers/mmc/host/at91_mci.c |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -99,6 +99,7 @@ config MMC_AU1X
 config MMC_AT91
 	tristate "AT91 SD/MMC Card Interface support"
 	depends on ARCH_AT91
+	depends on LOCKDEP=n
 	help
 	  This selects the AT91 MCI controller.
 
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -1081,8 +1081,7 @@ static int __init at91_mci_probe(struct 
 	 * Allocate the MCI interrupt
 	 */
 	host->irq = platform_get_irq(pdev, 0);
-	ret = request_irq(host->irq, at91_mci_irq, IRQF_SHARED,
-			mmc_hostname(mmc), host);
+	ret = request_irq(host->irq, at91_mci_irq, 0, mmc_hostname(mmc), host);
 	if (ret) {
 		dev_dbg(&pdev->dev, "request MCI interrupt failed\n");
 		goto fail0;
