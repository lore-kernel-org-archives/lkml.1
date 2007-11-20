Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbXKTRRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbXKTRRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 12:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbXKTRRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 12:17:40 -0500
Received: from mail0.scram.de ([78.47.204.202]:43355 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534AbXKTRRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 12:17:36 -0500
X-Spam-Score: -4.067
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <474316A4.4010807@scram.de>
Date: Tue, 20 Nov 2007 18:17:24 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linuxppc-embedded@ozlabs.org
CC: linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       paulus@samba.org
Subject: [PATCH try2] powerpc: Add support for PORTA and PORTB odr registers
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PORTA and PORTB have odr registers, as well. However, the PORTB odr
register is only 16bit.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/sysdev/commproc.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/commproc.c b/arch/powerpc/sysdev/commproc.c
index d5a0dcf..c0d00c2 100644
--- a/arch/powerpc/sysdev/commproc.c
+++ b/arch/powerpc/sysdev/commproc.c
@@ -411,7 +411,7 @@ EXPORT_SYMBOL(cpm_dpram_phys);
 #endif /* !CONFIG_PPC_CPM_NEW_BINDING */

 struct cpm_ioport16 {
-	__be16 dir, par, sor, dat, intr;
+	__be16 dir, par, odr_sor, dat, intr;
 	__be16 res[3];
 };

@@ -441,6 +441,13 @@ static void cpm1_set_pin32(int port, int pin, int flags)
 	else
 		clrbits32(&iop->par, pin);

+	if (port == CPM_PORTB) {
+		if (flags & CPM_PIN_OPENDRAIN)
+			setbits16(&mpc8xx_immr->im_cpm.cp_pbodr, pin);
+		else
+			clrbits16(&mpc8xx_immr->im_cpm.cp_pbodr, pin);
+	}
+
 	if (port == CPM_PORTE) {
 		if (flags & CPM_PIN_SECONDARY)
 			setbits32(&iop->sor, pin);
@@ -474,11 +481,17 @@ static void cpm1_set_pin16(int port, int pin, int flags)
 	else
 		clrbits16(&iop->par, pin);

+	if (port == CPM_PORTA) {
+		if (flags & CPM_PIN_OPENDRAIN)
+			setbits16(&iop->odr_sor, pin);
+		else
+			clrbits16(&iop->odr_sor, pin);
+	}
 	if (port == CPM_PORTC) {
 		if (flags & CPM_PIN_SECONDARY)
-			setbits16(&iop->sor, pin);
+			setbits16(&iop->odr_sor, pin);
 		else
-			clrbits16(&iop->sor, pin);
+			clrbits16(&iop->odr_sor, pin);
 	}
 }

-- 
1.5.3.4


