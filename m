Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZBCOGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZBCOGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBCOG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:06:26 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:54132 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZBCOGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:06:25 -0500
From: Jean Pihet <jpihet@mvista.com>
Organization: MontaVista
To: Tony Lindgren <tony@atomide.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       "Jarkko Lavinen (NMP/Helsinki)" <jarkko.lavinen@nokia.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP: MMC: recover from transfer failures - Resend
Date: Tue, 3 Feb 2009 15:05:58 +0100
User-Agent: KMail/1.9.9
References: <20081207213617.10456.43951.stgit@localhost> <200902020946.16508.jpihet@mvista.com> <20090202190503.GT7215@atomide.com>
In-Reply-To: <20090202190503.GT7215@atomide.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_G9EiJNWwaG+ypeG"
Message-Id: <200902031505.58697.jpihet@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_G9EiJNWwaG+ypeG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

This is a re-send of the patch that fixes a MMC host controller deadlock. T=
he=20
problem happens when removing the MMC/SD device when a transfer is on-going.

It has been tested on OMAP3430 but this fix should apply to OMAP2 chips as=
=20
well, as seen from the TRMs.

Regards,
Jean

=46rom d143f6b2e705aa4e9d2b032097fd1c82f8163262 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Thu, 8 Jan 2009 12:35:21 +0100
Subject: [PATCH] OMAP: MMC: recover from transfer failures

Timeouts during a command that has a data phase can result in the
next command issued after the command that failed not being processed,
i.e. no interrupt ever occurs to indicate the command has completed.
This failure can result in a deadlock.

This patch resets the data state machine to clear the error in
case of a command timeout.

Tested on OMAP3430 chip and intensive MMC/SD device removal while
transferring data.

Signed-off-by: Andy Lowe <alowe@mvista.com>
Signed-off-by: Jean Pihet <jpihet@mvista.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
=2D--
=A0drivers/mmc/host/omap_hsmmc.c | =A0 =A09 ++++++++-
=A01 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index d5c1e9d..97150c0 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -464,8 +464,15 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end_cmd =3D=
 1;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
=2D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (host->data)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (host->data) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mmc_dma_cle=
anup(host);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 OMAP_HSMMC_WR=
ITE(host->base, SYSCTL,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 OMAP_HSMMC_READ(host->base,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SYSCTL) | SRD);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (OMAP_H=
SMMC_READ(host->base,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 SYSCTL) & SRD)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 ;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((status & DATA_TIMEOUT) ||
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (status & DATA_CRC)) {
=2D-
1.5.4.4.21.gc4a6c


On Monday 02 February 2009 20:05:06 Tony Lindgren wrote:
> Hi,
>
> * Jean Pihet <jpihet@mvista.com> [090202 00:46]:
> > Tony,
> >
> > Has this patch been applied to the linux-omap tree? Does it need to go
> > the patchwork?
> >
> > Cf. http://marc.info/?l=3Dlinux-omap&m=3D123141577308177&w=3D2
>
> I'm not applying MMC patches, we need to move that discussion to LKML
> and keep Pierre involved.
>
> Jarkko Lavinen was planning to set up a git branch against the mainline
> tree for the omap mmc patches, so until we have that, let's just let the
> patches float on the list for a while.
>
> But yeah, if you want patchwork to pick up your patch so it does not
> get lost, just please resend it to the linux-omap list and it should
> get automatically picked up by patchwork.
>
> Regards,
>
> Tony



--Boundary-00=_G9EiJNWwaG+ypeG
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="OMAP-MMC-recover-from-transfer-failures.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="OMAP-MMC-recover-from-transfer-failures.patch"

=46rom d143f6b2e705aa4e9d2b032097fd1c82f8163262 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Thu, 8 Jan 2009 12:35:21 +0100
Subject: [PATCH] OMAP: MMC: recover from transfer failures

Timeouts during a command that has a data phase can result in the
next command issued after the command that failed not being processed,
i.e. no interrupt ever occurs to indicate the command has completed.
This failure can result in a deadlock.

This patch resets the data state machine to clear the error in
case of a command timeout.

Tested on OMAP3430 chip and intensive MMC/SD device removal while
transferring data.

Signed-off-by: Andy Lowe <alowe@mvista.com>
Signed-off-by: Jean Pihet <jpihet@mvista.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
=2D--
 drivers/mmc/host/omap_hsmmc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index d5c1e9d..97150c0 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -464,8 +464,15 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 				}
 				end_cmd =3D 1;
 			}
=2D			if (host->data)
+			if (host->data) {
 				mmc_dma_cleanup(host);
+				OMAP_HSMMC_WRITE(host->base, SYSCTL,
+					OMAP_HSMMC_READ(host->base,
+							SYSCTL) | SRD);
+				while (OMAP_HSMMC_READ(host->base,
+						SYSCTL) & SRD)
+					;
+			}
 		}
 		if ((status & DATA_TIMEOUT) ||
 			(status & DATA_CRC)) {
=2D-=20
1.5.4.4.21.gc4a6c


--Boundary-00=_G9EiJNWwaG+ypeG--
