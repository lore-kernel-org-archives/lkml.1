Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZBKJmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZBKJmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZBKJlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:41:51 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7662 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZBKJlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:41:49 -0500
From: Jean Pihet <jpihet@mvista.com>
Organization: MontaVista
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] OMAP: MMC: replace infinite loops with timeouts (was Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend)
Date: Wed, 11 Feb 2009 10:41:16 +0100
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "tony@atomide.com" <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20081207213617.10456.43951.stgit@localhost> <200902061653.12821.jpihet@mvista.com> <49905296.2060308@nokia.com>
In-Reply-To: <49905296.2060308@nokia.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_90pkJ3ii6IMHtg9"
Message-Id: <200902111041.17095.jpihet@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_90pkJ3ii6IMHtg9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Here is the new version of the patch, which now uses cpu_relax in an inline=
=20
function. The new function can be used from an irq handler as well.

Regards,
Jean

=46rom 9d1993dcf4d217837437a1cd9f6e9c1b81533549 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Fri, 6 Feb 2009 16:42:51 +0100
Subject: [PATCH] OMAP: MMC: Change while(); loops with finite version

Replace the infinite 'while() ;' loops
with a finite loop version.

Signed-off-by: Jean Pihet <jpihet@mvista.com>
=2D--
 drivers/mmc/host/omap_hsmmc.c |   54 ++++++++++++++++++++++---------------=
=2D--
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1ac6918..aabf28d 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -375,6 +375,32 @@ static void mmc_omap_report_irq(struct mmc_omap_host=20
*host, u32 status)
 }
 #endif  /* CONFIG_MMC_DEBUG */

+/*
+ * MMC controller internal state machines reset
+ *
+ * Used to reset command or data internal state machines, using respective=
ly
+ *  SRC or SRD bit of SYSCTL register
+ * Can be called from interrupt context
+ */
+static inline void mmc_omap_reset_controller_fsm(struct mmc_omap_host *hos=
t,
+               unsigned long bit)
+{
+       unsigned long i =3D 0;
+       unsigned long limit =3D (loops_per_jiffy *
+                               msecs_to_jiffies(MMC_TIMEOUT_MS));
+
+       OMAP_HSMMC_WRITE(host->base, SYSCTL,
+                        OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
+
+       while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
+               (i++ < limit))
+               cpu_relax();
+
+       if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
+               dev_err(mmc_dev(host->mmc),
+                       "Timeout waiting on controller reset in %s\n",
+                       __func__);
+}

 /*
  * MMC controller IRQ handler
@@ -403,13 +429,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
                        (status & CMD_CRC)) {
                        if (host->cmd) {
                                if (status & CMD_TIMEOUT) {
=2D                                       OMAP_HSMMC_WRITE(host->base, SYSC=
TL,
=2D                                               OMAP_HSMMC_READ(host->bas=
e,
=2D                                                               SYSCTL) |=
=20
SRC);
=2D                                       while (OMAP_HSMMC_READ(host->base,
=2D                                                       SYSCTL) & SRC)
=2D                                               ;
=2D
+                                       mmc_omap_reset_controller_fsm(host,=
=20
SRC);
                                        host->cmd->error =3D -ETIMEDOUT;
                                } else {
                                        host->cmd->error =3D -EILSEQ;
@@ -418,12 +438,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
                        }
                        if (host->data) {
                                mmc_dma_cleanup(host);
=2D                               OMAP_HSMMC_WRITE(host->base, SYSCTL,
=2D                                       OMAP_HSMMC_READ(host->base,
=2D                                                       SYSCTL) | SRD);
=2D                               while (OMAP_HSMMC_READ(host->base,
=2D                                               SYSCTL) & SRD)
=2D                                       ;
+                               mmc_omap_reset_controller_fsm(host, SRD);
                        }
                }
                if ((status & DATA_TIMEOUT) ||
@@ -433,12 +448,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
                                        mmc_dma_cleanup(host);
                                else
                                        host->data->error =3D -EILSEQ;
=2D                               OMAP_HSMMC_WRITE(host->base, SYSCTL,
=2D                                       OMAP_HSMMC_READ(host->base,
=2D                                                       SYSCTL) | SRD);
=2D                               while (OMAP_HSMMC_READ(host->base,
=2D                                               SYSCTL) & SRD)
=2D                                       ;
+                               mmc_omap_reset_controller_fsm(host, SRD);
                                end_trans =3D 1;
                        }
                }
@@ -529,11 +539,7 @@ static void mmc_omap_detect(struct work_struct *work)
        if (host->carddetect) {
                mmc_detect_change(host->mmc, (HZ * 200) / 1000);
        } else {
=2D               OMAP_HSMMC_WRITE(host->base, SYSCTL,
=2D                       OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
=2D               while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
=2D                       ;
=2D
+               mmc_omap_reset_controller_fsm(host, SRD);
                mmc_detect_change(host->mmc, (HZ * 50) / 1000);
        }
 }
=2D-
1.6.0.1.42.gf8c9c



On Monday 09 February 2009 16:58:14 Adrian Hunter wrote:
> Jean Pihet wrote:
> > Hi,
> >
> >>>> On Thu, 5 Feb 2009, Andrew Morton wrote:
> >>>>> An infinite loop which assumes the hardware is perfect is always a
> >>>>> worry.  But I see the driver already does that, so we're no worse
> >>>>> off..
> >>>
> >>> Do you want a finite loop with udelay in it? I located 4 places were
> >>> this could be used. If so I can generate a new patch for that.
> >>
> >> Even if Andrew doesn't, I'd sure like it. (the finite bit at least) :)
> >
> > Ok here is a patch that replaces the infinite loops with a timeout
> > version. This patch applies on top of the previous one I sent ('[PATCH]
> > OMAP: MMC: recover from transfer failures - Resend'). Is that OK?
>
> What about making use of a function like this:
>
> static void reset_host_controller(struct mmc_omap_host *host, unsigned bi=
t)
> {
> 	unsigned long i, limit =3D loops_per_jiffy;
>
> 	OMAP_HSMMC_WRITE(host->base, SYSCTL,
> 			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
> 	for (i =3D 0; i < limit; i++) {
> 		if (!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
> 			return;
> 		cpu_relax();
> 	}
> 	dev_err(mmc_dev(host->mmc), "%s: timeout waiting on software reset\n",
> 		mmc_hostname(host->mmc));
> }
>
> And then just put:
>
> 	reset_host_controller(host, SRD);
>
> and
>
> 	reset_host_controller(host, SRC);
>
> in the right places.


--Boundary-00=_90pkJ3ii6IMHtg9
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="hsmmc_finite_timeout.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="hsmmc_finite_timeout.patch"

=46rom 9d1993dcf4d217837437a1cd9f6e9c1b81533549 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Fri, 6 Feb 2009 16:42:51 +0100
Subject: [PATCH] OMAP: MMC: Change while(); loops with finite version

Replace the infinite 'while() ;' loops
with a finite loop version.

Signed-off-by: Jean Pihet <jpihet@mvista.com>
=2D--
 drivers/mmc/host/omap_hsmmc.c |   54 ++++++++++++++++++++++---------------=
=2D--
 1 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1ac6918..aabf28d 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -375,6 +375,32 @@ static void mmc_omap_report_irq(struct mmc_omap_host *=
host, u32 status)
 }
 #endif  /* CONFIG_MMC_DEBUG */
=20
+/*
+ * MMC controller internal state machines reset
+ *
+ * Used to reset command or data internal state machines, using respective=
ly
+ *  SRC or SRD bit of SYSCTL register
+ * Can be called from interrupt context
+ */
+static inline void mmc_omap_reset_controller_fsm(struct mmc_omap_host *hos=
t,
+		unsigned long bit)
+{
+	unsigned long i =3D 0;
+	unsigned long limit =3D (loops_per_jiffy *
+				msecs_to_jiffies(MMC_TIMEOUT_MS));
+
+	OMAP_HSMMC_WRITE(host->base, SYSCTL,
+			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
+
+	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
+		(i++ < limit))
+		cpu_relax();
+
+	if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
+		dev_err(mmc_dev(host->mmc),
+			"Timeout waiting on controller reset in %s\n",
+			__func__);
+}
=20
 /*
  * MMC controller IRQ handler
@@ -403,13 +429,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 			(status & CMD_CRC)) {
 			if (host->cmd) {
 				if (status & CMD_TIMEOUT) {
=2D					OMAP_HSMMC_WRITE(host->base, SYSCTL,
=2D						OMAP_HSMMC_READ(host->base,
=2D								SYSCTL) | SRC);
=2D					while (OMAP_HSMMC_READ(host->base,
=2D							SYSCTL) & SRC)
=2D						;
=2D
+					mmc_omap_reset_controller_fsm(host, SRC);
 					host->cmd->error =3D -ETIMEDOUT;
 				} else {
 					host->cmd->error =3D -EILSEQ;
@@ -418,12 +438,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 			}
 			if (host->data) {
 				mmc_dma_cleanup(host);
=2D				OMAP_HSMMC_WRITE(host->base, SYSCTL,
=2D					OMAP_HSMMC_READ(host->base,
=2D							SYSCTL) | SRD);
=2D				while (OMAP_HSMMC_READ(host->base,
=2D						SYSCTL) & SRD)
=2D					;
+				mmc_omap_reset_controller_fsm(host, SRD);
 			}
 		}
 		if ((status & DATA_TIMEOUT) ||
@@ -433,12 +448,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 					mmc_dma_cleanup(host);
 				else
 					host->data->error =3D -EILSEQ;
=2D				OMAP_HSMMC_WRITE(host->base, SYSCTL,
=2D					OMAP_HSMMC_READ(host->base,
=2D							SYSCTL) | SRD);
=2D				while (OMAP_HSMMC_READ(host->base,
=2D						SYSCTL) & SRD)
=2D					;
+				mmc_omap_reset_controller_fsm(host, SRD);
 				end_trans =3D 1;
 			}
 		}
@@ -529,11 +539,7 @@ static void mmc_omap_detect(struct work_struct *work)
 	if (host->carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
=2D		OMAP_HSMMC_WRITE(host->base, SYSCTL,
=2D			OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
=2D		while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
=2D			;
=2D
+		mmc_omap_reset_controller_fsm(host, SRD);
 		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
 	}
 }
=2D-=20
1.6.0.1.42.gf8c9c


--Boundary-00=_90pkJ3ii6IMHtg9--
