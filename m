Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZLNR7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZLNR7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZLNR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:59:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59112 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZLNR7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:59:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZWTai11ssiYrzEy8OH6OwjxGAEaA0nEZ8VKmETGHwBinbADTWSVbICHRO3jXyWw6CG
         rBfM5RN6cTUGl14s1pC86wtKuibJ1HxOYzeAUADpcMp8tzhbO2ONa+COLkmxns6YJFPP
         zgH/2YdaO3NGsVzBoMuMlT2GlHScNYQehIM4w=
Subject: Re: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion
 between read and write value of two bits in POWER_MISCELLANEUS register.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <4B26799F.1020507@ru.mvista.com>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby>  <4B26799F.1020507@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 18:59:00 +0100
Message-ID: <1260813540.2022.174.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno lun, 14/12/2009 alle 20.45 +0300, Sergei Shtylyov ha scritto:
> > +     if (offset == MC13783_REG_POWER_MISCELLANEOUS)
> > +             buf &= !(MC13783_REGCTRL_PWGT1SPIEN |
> >   
> 
>    Are you sure ! shouldn't be ~ here?
> 
> > +                      MC13783_REGCTRL_PWGT2SPIEN);
> >   
> 
>    !(MC13783_REGCTRL_PWGT1SPIEN | MC13783_REGCTRL_PWGT2SPIEN) would 
> evaluate to 0 which is most probably not what you want.
> 
> WBR, Sergei 

For sure, you are right. The correct patch below..

PWGT1DRV and PWGT1DRV are two digital output controlled by two corresponding
hardware signals (Pin PWGTnEN) that are meant to be used to control core power
supplies.
The register MC13783_REG_POWER_MISCELLANEOUS contain the two control and
status bit (PWGTnSPIEN) where write and read meaning is summarised by 
the following table:

 Bit PWGTxSPIEN | Pin PWGTxEN | PWGTxDRV |  Read Back
   0 = default  |             |          | PWGTxSPIEN
 ---------------+-------------+----------+------------
       1        |      x      |   Low    |     0
       0        |      0      |   High   |     1
       0        |      1      |   Low    |     0

Writing a 1 to those bits will turn off the corresponding core
power supply. As there is no way to read back the value of 
PWGTnSPIEN, the behaviour chosen is to let always the hardware
control itself leaving those bits at the default value.

This patch is especially needed for manipulate the other bits
in the same register, where the read-modify-write operation
can produce unwanted power fault.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/mfd/mc13783-core.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index a1ade23..3953297 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -171,6 +171,9 @@ int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
 }
 EXPORT_SYMBOL(mc13783_reg_read);
 
+#define MC13783_REG_POWER_MISCELLANEOUS        34
+#define MC13783_REGCTRL_PWGT1SPIEN     (1 << 15)
+#define MC13783_REGCTRL_PWGT2SPIEN     (1 << 16)
 int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
 {
        u32 buf;
@@ -187,6 +190,13 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
 
        buf = 1 << 31 | offset << MC13783_REGOFFSET_SHIFT | val;
 
+       /* Take care of table 4-24 in Freescale MC13783IGPLDRM.pdf making
+        * the assumption that PWGTnDRV signals controls core power supplies
+        * that software must not disable. */
+       if (offset == MC13783_REG_POWER_MISCELLANEOUS)
+               buf &= ~(MC13783_REGCTRL_PWGT1SPIEN |
+                        MC13783_REGCTRL_PWGT2SPIEN);
+
        memset(&t, 0, sizeof(t));
 
        t.tx_buf = &buf;
-- 
1.6.3.3

