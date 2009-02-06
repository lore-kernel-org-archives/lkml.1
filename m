Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZBFPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZBFPxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZBFPxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:53:38 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:23551 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZBFPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:53:36 -0500
From: Jean Pihet <jpihet@mvista.com>
Organization: MontaVista
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [PATCH] OMAP: MMC: replace infinite loops with timeouts (was Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend)
Date: Fri, 6 Feb 2009 16:53:12 +0100
User-Agent: KMail/1.9.9
Cc: tony@atomide.com, Paul Walmsley <paul@pwsan.com>,
       Andrew Morton <akpm@linux-foundation.org>, ext-adrian.hunter@nokia.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       jarkko.lavinen@nokia.com, linux-kernel@vger.kernel.org
References: <20081207213617.10456.43951.stgit@localhost> <200902061422.32689.jpihet@mvista.com> <20090206145343.2b8a5353@mjolnir.drzeus.cx>
In-Reply-To: <20090206145343.2b8a5353@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ozFjJIHCmBlPTfO"
Message-Id: <200902061653.12821.jpihet@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ozFjJIHCmBlPTfO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

> > > On Thu, 5 Feb 2009, Andrew Morton wrote:
> > > > An infinite loop which assumes the hardware is perfect is always a
> > > > worry.  But I see the driver already does that, so we're no worse
> > > > off..
> >
> > Do you want a finite loop with udelay in it? I located 4 places were th=
is
> > could be used. If so I can generate a new patch for that.
>
> Even if Andrew doesn't, I'd sure like it. (the finite bit at least) :)
Ok here is a patch that replaces the infinite loops with a timeout version.
This patch applies on top of the previous one I sent ('[PATCH] OMAP: MMC:=20
recover from transfer failures - Resend'). Is that OK?

> Related, who is the maintainer of this driver? Tony? I'd like to have
> someone who checks patches before I queue them up.
>
>
> Rgds

=46rom 5ee867d09efe22a903ac7373a05e9e047bad6544 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Fri, 6 Feb 2009 16:42:51 +0100
Subject: [PATCH] OMAP: MMC: replace infinite loops with timeouts

Replace the 'while() ;' with a timeout

Signed-off-by: Jean Pihet <jpihet@mvista.com>
=2D--
 drivers/mmc/host/omap_hsmmc.c |   56=20
+++++++++++++++++++++++++++++++++--------
 1 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1ac6918..7ddc77e 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -102,6 +102,8 @@
 #define OMAP_MMC_DATADIR_READ  1
 #define OMAP_MMC_DATADIR_WRITE 2
 #define MMC_TIMEOUT_MS         20
+#define MMC_TIMEOUT_WAIT       100     /* Active wait duration, in usec */
+#define MMC_TIMEOUT_WAIT_LOOPS ((MMC_TIMEOUT_MS * 1000) / MMC_TIMEOUT_WAIT)
 #define OMAP_MMC_MASTER_CLOCK  96000000
 #define DRIVER_NAME            "mmci-omap-hs"

@@ -384,6 +386,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
        struct mmc_omap_host *host =3D dev_id;
        struct mmc_data *data;
        int end_cmd =3D 0, end_trans =3D 0, status;
+       unsigned long timeout_counter;

        if (host->cmd =3D=3D NULL && host->data =3D=3D NULL) {
                OMAP_HSMMC_WRITE(host->base, STAT,
@@ -406,9 +409,17 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
                                        OMAP_HSMMC_WRITE(host->base, SYSCTL,
                                                OMAP_HSMMC_READ(host->base,
                                                                SYSCTL) |=20
SRC);
=2D                                       while (OMAP_HSMMC_READ(host->base,
=2D                                                       SYSCTL) & SRC)
=2D                                               ;
+                                       timeout_counter =3D 0;
+                                       while ((OMAP_HSMMC_READ(host->base,
+                                                               SYSCTL) & S=
RC)
+                                               && (timeout_counter++ <
+                                                              =20
MMC_TIMEOUT_WAIT_LOOPS))
+                                                      =20
udelay(MMC_TIMEOUT_WAIT);
+
+                                       if (OMAP_HSMMC_READ(host->base,
+                                                               SYSCTL) & S=
RC)
+                                               dev_err(mmc_dev(host->mmc),
+                                                       "Timeout waiting on=
=20
SRC\n");

                                        host->cmd->error =3D -ETIMEDOUT;
                                } else {
@@ -421,9 +432,17 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
                                OMAP_HSMMC_WRITE(host->base, SYSCTL,
                                        OMAP_HSMMC_READ(host->base,
                                                        SYSCTL) | SRD);
=2D                               while (OMAP_HSMMC_READ(host->base,
=2D                                               SYSCTL) & SRD)
=2D                                       ;
+                               timeout_counter =3D 0;
+                               while ((OMAP_HSMMC_READ(host->base,
+                                                       SYSCTL) & SRD)
+                                       && (timeout_counter++ <
+                                                      =20
MMC_TIMEOUT_WAIT_LOOPS))
+                                       udelay(MMC_TIMEOUT_WAIT);
+
+                               if (OMAP_HSMMC_READ(host->base,
+                                                       SYSCTL) & SRD)
+                                       dev_err(mmc_dev(host->mmc),
+                                               "Timeout waiting on SRD\n");
                        }
                }
                if ((status & DATA_TIMEOUT) ||
@@ -436,9 +455,17 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
                                OMAP_HSMMC_WRITE(host->base, SYSCTL,
                                        OMAP_HSMMC_READ(host->base,
                                                        SYSCTL) | SRD);
=2D                               while (OMAP_HSMMC_READ(host->base,
=2D                                               SYSCTL) & SRD)
=2D                                       ;
+                               timeout_counter =3D 0;
+                               while ((OMAP_HSMMC_READ(host->base,
+                                                       SYSCTL) & SRD)
+                                       && (timeout_counter++ <
+                                                      =20
MMC_TIMEOUT_WAIT_LOOPS))
+                                       udelay(MMC_TIMEOUT_WAIT);
+
+                               if (OMAP_HSMMC_READ(host->base,
+                                                       SYSCTL) & SRD)
+                                       dev_err(mmc_dev(host->mmc),
+                                               "Timeout waiting on SRD\n");
                                end_trans =3D 1;
                        }
                }
@@ -524,6 +551,7 @@ static void mmc_omap_detect(struct work_struct *work)
 {
        struct mmc_omap_host *host =3D container_of(work, struct mmc_omap_h=
ost,
                                                mmc_carddetect_work);
+       unsigned long timeout;

        sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
        if (host->carddetect) {
@@ -531,8 +559,14 @@ static void mmc_omap_detect(struct work_struct *work)
        } else {
                OMAP_HSMMC_WRITE(host->base, SYSCTL,
                        OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
=2D               while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
=2D                       ;
+               /* Wait till the SRD bit is reset */
+               timeout =3D jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+               while ((OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
+                       && time_before(jiffies, timeout))
+                       msleep(1);
+
+               if (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
+                       dev_err(mmc_dev(host->mmc), "Timeout waiting on=20
SRD\n");

                mmc_detect_change(host->mmc, (HZ * 50) / 1000);
        }
=2D-
1.6.0.1.42.gf8c9c

--Boundary-00=_ozFjJIHCmBlPTfO
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="OMAP-MMC-replace-infinite-loops-with-timeouts.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="OMAP-MMC-replace-infinite-loops-with-timeouts.patch"

=46rom 5ee867d09efe22a903ac7373a05e9e047bad6544 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Fri, 6 Feb 2009 16:42:51 +0100
Subject: [PATCH] OMAP: MMC: replace infinite loops with timeouts

Replace the 'while() ;' with a timeout

Signed-off-by: Jean Pihet <jpihet@mvista.com>
=2D--
 drivers/mmc/host/omap_hsmmc.c |   56 +++++++++++++++++++++++++++++++++----=
=2D---
 1 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1ac6918..7ddc77e 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -102,6 +102,8 @@
 #define OMAP_MMC_DATADIR_READ	1
 #define OMAP_MMC_DATADIR_WRITE	2
 #define MMC_TIMEOUT_MS		20
+#define MMC_TIMEOUT_WAIT	100	/* Active wait duration, in usec */
+#define MMC_TIMEOUT_WAIT_LOOPS	((MMC_TIMEOUT_MS * 1000) / MMC_TIMEOUT_WAIT)
 #define OMAP_MMC_MASTER_CLOCK	96000000
 #define DRIVER_NAME		"mmci-omap-hs"
=20
@@ -384,6 +386,7 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	struct mmc_omap_host *host =3D dev_id;
 	struct mmc_data *data;
 	int end_cmd =3D 0, end_trans =3D 0, status;
+	unsigned long timeout_counter;
=20
 	if (host->cmd =3D=3D NULL && host->data =3D=3D NULL) {
 		OMAP_HSMMC_WRITE(host->base, STAT,
@@ -406,9 +409,17 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 					OMAP_HSMMC_WRITE(host->base, SYSCTL,
 						OMAP_HSMMC_READ(host->base,
 								SYSCTL) | SRC);
=2D					while (OMAP_HSMMC_READ(host->base,
=2D							SYSCTL) & SRC)
=2D						;
+					timeout_counter =3D 0;
+					while ((OMAP_HSMMC_READ(host->base,
+								SYSCTL) & SRC)
+						&& (timeout_counter++ <
+								MMC_TIMEOUT_WAIT_LOOPS))
+							udelay(MMC_TIMEOUT_WAIT);
+
+					if (OMAP_HSMMC_READ(host->base,
+								SYSCTL)	& SRC)
+						dev_err(mmc_dev(host->mmc),
+							"Timeout waiting on SRC\n");
=20
 					host->cmd->error =3D -ETIMEDOUT;
 				} else {
@@ -421,9 +432,17 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				OMAP_HSMMC_WRITE(host->base, SYSCTL,
 					OMAP_HSMMC_READ(host->base,
 							SYSCTL) | SRD);
=2D				while (OMAP_HSMMC_READ(host->base,
=2D						SYSCTL) & SRD)
=2D					;
+				timeout_counter =3D 0;
+				while ((OMAP_HSMMC_READ(host->base,
+							SYSCTL) & SRD)
+					&& (timeout_counter++ <
+							MMC_TIMEOUT_WAIT_LOOPS))
+					udelay(MMC_TIMEOUT_WAIT);
+
+				if (OMAP_HSMMC_READ(host->base,
+							SYSCTL)	& SRD)
+					dev_err(mmc_dev(host->mmc),
+						"Timeout waiting on SRD\n");
 			}
 		}
 		if ((status & DATA_TIMEOUT) ||
@@ -436,9 +455,17 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				OMAP_HSMMC_WRITE(host->base, SYSCTL,
 					OMAP_HSMMC_READ(host->base,
 							SYSCTL) | SRD);
=2D				while (OMAP_HSMMC_READ(host->base,
=2D						SYSCTL) & SRD)
=2D					;
+				timeout_counter =3D 0;
+				while ((OMAP_HSMMC_READ(host->base,
+							SYSCTL) & SRD)
+					&& (timeout_counter++ <
+							MMC_TIMEOUT_WAIT_LOOPS))
+					udelay(MMC_TIMEOUT_WAIT);
+
+				if (OMAP_HSMMC_READ(host->base,
+							SYSCTL)	& SRD)
+					dev_err(mmc_dev(host->mmc),
+						"Timeout waiting on SRD\n");
 				end_trans =3D 1;
 			}
 		}
@@ -524,6 +551,7 @@ static void mmc_omap_detect(struct work_struct *work)
 {
 	struct mmc_omap_host *host =3D container_of(work, struct mmc_omap_host,
 						mmc_carddetect_work);
+	unsigned long timeout;
=20
 	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
 	if (host->carddetect) {
@@ -531,8 +559,14 @@ static void mmc_omap_detect(struct work_struct *work)
 	} else {
 		OMAP_HSMMC_WRITE(host->base, SYSCTL,
 			OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
=2D		while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
=2D			;
+		/* Wait till the SRD bit is reset */
+		timeout =3D jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
+		while ((OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
+			&& time_before(jiffies, timeout))
+			msleep(1);
+
+		if (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
+			dev_err(mmc_dev(host->mmc), "Timeout waiting on SRD\n");
=20
 		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
 	}
=2D-=20
1.6.0.1.42.gf8c9c


--Boundary-00=_ozFjJIHCmBlPTfO--
