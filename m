Return-Path: <linux-kernel-owner+w=401wt.eu-S933893AbZLMBlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbZLMBlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933851AbZLMBlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:41:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41380 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933858AbZLMBlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:41:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o4ElqE0pszrHuUQ6NvepMdQ9oSETDV/fCENma8igD6GoaEGUB98SLfLgMweXLnXPpz
         Oj9xW77YWY7PzQ82FoxjTuSPfm3dD428SOJVtejVh9JacgGAhYoBLlbtA2mtbemWuQGb
         +F2XqKjgED0e36wRy0EEArGb+hi325xoSo+wc=
Subject: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion between
 read and write value of two bits in POWER_MISCELLANEUS register.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1260635829.2054.16.camel@climbing-alby>
References: <1260635829.2054.16.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 17:48:43 +0100
Message-ID: <1260636523.2054.28.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MC13783_REGCTRL_PWGTnSPIEN controls the states of the corresponding
PWGTn_DRV output.
Reading 1 on the corresponding bit mean that the output is enabled
Writing 1 on the corresponding bit disable that output!

So, if not asked directly to modify those bits, write the inverted
value.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/mfd/mc13783-core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index a1ade23..aa1f79a 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -207,6 +207,9 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
 }
 EXPORT_SYMBOL(mc13783_reg_write);
 
+#define MC13783_REG_POWER_MISCELLANEOUS	34
+#define MC13783_REGCTRL_PWGT1SPIEN	(1 << 15)
+#define MC13783_REGCTRL_PWGT2SPIEN	(1 << 16)
 int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
 		u32 mask, u32 val)
 {
@@ -221,6 +225,14 @@ int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
 
 	valread = (valread & ~mask) | val;
 
+	if ((offset == MC13783_REG_POWER_MISCELLANEOUS) &&
+	   !(mask & MC13783_REGCTRL_PWGT1SPIEN))
+		valread ^= MC13783_REGCTRL_PWGT1SPIEN;
+
+	if ((offset == MC13783_REG_POWER_MISCELLANEOUS) &&
+	   !(mask & MC13783_REGCTRL_PWGT2SPIEN))
+		valread ^= MC13783_REGCTRL_PWGT2SPIEN;
+
 	return mc13783_reg_write(mc13783, offset, valread);
 }
 EXPORT_SYMBOL(mc13783_reg_rmw);
-- 
1.6.3.3






