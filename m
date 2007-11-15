Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbXKOSr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbXKOSr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760779AbXKOSrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:47:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:8850 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605AbXKOSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:47:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=dBKpwVEfSt4x3gdTRMVbkH1TC3aubacsuDUb5XNx/l+Bpd8yZL7E4JDB7+obEwcPhKydHATA1uV0OrD06+4J+tCJ8k/S25e5yq3m7r+5lDcV8BIMiSt2InL1f7Ssg4RMCYDtLsJ1xdIiQvMYzKLce+zU0PT/vGdJiZ0zIAx3ecE=
Date: Thu, 15 Nov 2007 21:47:06 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] PPC: Fix potential NULL dereference
Message-ID: <20071115184705.GA7273@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does fix potential NULL pointer dereference
that could take place inside of strcmp() if
of_get_property() call failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/powerpc/platforms/83xx/usb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/usb.c b/arch/powerpc/platforms/83xx/usb.c
index eafe760..b45160f 100644
--- a/arch/powerpc/platforms/83xx/usb.c
+++ b/arch/powerpc/platforms/83xx/usb.c
@@ -130,7 +130,7 @@ int mpc831x_usb_cfg(void)
 	out_be32(immap + MPC83XX_SCCR_OFFS, temp);
 
 	/* Configure pin mux for ULPI.  There is no pin mux for UTMI */
-	if (!strcmp(prop, "ulpi")) {
+	if (prop && !strcmp(prop, "ulpi")) {
 		temp = in_be32(immap + MPC83XX_SICRL_OFFS);
 		temp &= ~MPC831X_SICRL_USB_MASK;
 		temp |= MPC831X_SICRL_USB_ULPI;
@@ -153,13 +153,13 @@ int mpc831x_usb_cfg(void)
 	usb_regs = ioremap(res.start, res.end - res.start + 1);
 
 	/* Using on-chip PHY */
-	if (!strcmp(prop, "utmi_wide") ||
-			!strcmp(prop, "utmi")) {
+	if (prop && (!strcmp(prop, "utmi_wide") ||
+		     !strcmp(prop, "utmi"))) {
 		/* Set UTMI_PHY_EN, REFSEL to 48MHZ */
 		out_be32(usb_regs + FSL_USB2_CONTROL_OFFS,
 				CONTROL_UTMI_PHY_EN | CONTROL_REFSEL_48MHZ);
 	/* Using external UPLI PHY */
-	} else if (!strcmp(prop, "ulpi")) {
+	} else if (prop && !strcmp(prop, "ulpi")) {
 		/* Set PHY_CLK_SEL to ULPI */
 		temp = CONTROL_PHY_CLK_SEL_ULPI;
 #ifdef CONFIG_USB_OTG
