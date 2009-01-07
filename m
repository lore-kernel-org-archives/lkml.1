Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZAGK3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZAGK3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZAGK2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:28:51 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:31974 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZAGK2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:28:49 -0500
From: Jean Pihet <jpihet@mvista.com>
Organization: MontaVista
To: linux-arm-kernel@lists.arm.linux.org.uk, Tony Lindgren <tony@atomide.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [PATCH] OMAP: MMC: recover from transfer failures (was: Re: [PATCH 5/5] omap mmc: Add new omap hsmmc controller for 2430 and 34xx)
Date: Wed, 7 Jan 2009 11:28:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       David Brownell <david-b@pacbell.net>
References: <20081207213617.10456.43951.stgit@localhost> <20081231185928.2ba325e6@mjolnir.drzeus.cx> <20090107101812.GD27566@atomide.com>
In-Reply-To: <20090107101812.GD27566@atomide.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bPIZJXG+e6BEYbc"
Message-Id: <200901071128.43937.jpihet@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_bPIZJXG+e6BEYbc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Tony, Pierre,

Here is a patch that fixes a MMC host controller deadlock. The problem happ=
ens=20
when removing the MMC/SD device when a transfer is on-going.

It has been tested on OMAP3430 but this fix should apply to OMAP2 chips as=
=20
well, as seen from the TRMs.

What do you think?

Regards,
Jean.

    OMAP: MMC: recover from transfer failures

    Timeouts during a command that has a data phase can result in the
    next command issued after the command that failed not being processed,
    i.e. no interrupt ever occurs to indicate the command has completed.
    This failure can result in a deadlock.

    The indication that the mmc host controller is in this error state is
    that the DATI bit is set in the PSTATE register.  This patch checks
    to see if the DATI bit is set before starting a new command, and if it
    is set it resets the data state machine to clear the error.

    Tested on OMAP3430 chip and intensive MMC/SD device removal while
    transferring data.

Regards,
Jean


=46rom 48a40925a4d57f6e7e45809a4b5c09b20f9314d7 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Tue, 16 Dec 2008 19:44:12 +0100
Subject: [PATCH] OMAP: MMC: recover from transfer failures

Timeouts during a command that has a data phase can result in the
next command issued after the command that failed not being processed,
i.e. no interrupt ever occurs to indicate the command has completed.
This failure can result in a deadlock.

The indication that the mmc host controller is in this error state is
that the DATI bit is set in the PSTATE register.  This patch checks
to see if the DATI bit is set before starting a new command, and if it
is set it resets the data state machine to clear the error.

Tested on OMAP3430 chip and intensive MMC/SD device removal while
transferring data.

Signed-off-by: Andy Lowe <alowe@mvista.com>
Signed-off-by: Jean Pihet <jpihet@mvista.com>
=2D--
 drivers/mmc/host/omap_hsmmc.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1fcc544..b7d111e 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -44,6 +44,7 @@
 #define OMAP_HSMMC_RSP54       0x0118
 #define OMAP_HSMMC_RSP76       0x011C
 #define OMAP_HSMMC_DATA                0x0120
+#define OMAP_HSMMC_PSTATE      0x0124
 #define OMAP_HSMMC_HCTL                0x0128
 #define OMAP_HSMMC_SYSCTL      0x012C
 #define OMAP_HSMMC_STAT                0x0130
@@ -89,6 +90,7 @@
 #define DUAL_VOLT_OCR_BIT      7
 #define SRC                    (1 << 25)
 #define SRD                    (1 << 26)
+#define DATI                   (1 << 1)
=20
 /*
  * FIXME: Most likely all the data using these _DEVID defines should come
@@ -273,6 +275,15 @@ mmc_omap_start_command(struct mmc_omap_host *host, str=
uct=20
mmc_command *cmd,
                mmc_hostname(host->mmc), cmd->opcode, cmd->arg);
        host->cmd =3D cmd;
=20
+       if (OMAP_HSMMC_READ(host->base, PSTATE) & DATI) {
+               dev_dbg(mmc_dev(host->mmc), "mmc_omap_start_command: "
+                       " resetting data state machine\n");
+               OMAP_HSMMC_WRITE(host->base, SYSCTL,
+                       OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
+               while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
+                       ;
+       }
+
        /*
         * Clear status bits and enable interrupts
         */
=2D-=20
1.5.4.4.21.gc4a6c


On Wednesday 07 January 2009 11:18:13 Tony Lindgren wrote:
> * Pierre Ossman <drzeus-mmc@drzeus.cx> [081231 19:59]:
> > On Tue, 30 Dec 2008 10:36:26 +0200
> >
> > Tony Lindgren <tony@atomide.com> wrote:
> > > Here's one more version that leaves out the unnecessary TWL4030
> > > dependency in the Kconfig as pointed out by David Brownell.
> >
> > Looks ok.
> >
> > Acked-by: Pierre Ossman <drzeus@drzeus.cx>
>
> Thanks, I'll queue it up with Russell with one change
> to include <mach/dma.h> instead of <asm/dma.h>.
>
> All further patches to this driver will come to you via
> LKML.
>
> Regards,
>
> Tony
>
> > --
> >      -- Pierre Ossman
> >
> >   Linux kernel, MMC maintainer        http://www.kernel.org
> >   rdesktop, core developer          http://www.rdesktop.org
> >
> >   WARNING: This correspondence is being monitored by the
> >   Swedish government. Make sure your server uses encryption
> >   for SMTP traffic and consider using PGP for end-to-end
> >   encryption.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
>
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kern=
el
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php



--Boundary-00=_bPIZJXG+e6BEYbc
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="OMAP-MMC-recover-from-transfer-failures.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="OMAP-MMC-recover-from-transfer-failures.patch"

=46rom 48a40925a4d57f6e7e45809a4b5c09b20f9314d7 Mon Sep 17 00:00:00 2001
=46rom: Jean Pihet <jpihet@mvista.com>
Date: Tue, 16 Dec 2008 19:44:12 +0100
Subject: [PATCH] OMAP: MMC: recover from transfer failures

Timeouts during a command that has a data phase can result in the
next command issued after the command that failed not being processed,
i.e. no interrupt ever occurs to indicate the command has completed.
This failure can result in a deadlock.

The indication that the mmc host controller is in this error state is
that the DATI bit is set in the PSTATE register.  This patch checks
to see if the DATI bit is set before starting a new command, and if it
is set it resets the data state machine to clear the error.

Tested on OMAP3430 chip and intensive MMC/SD device removal while
transferring data.

Signed-off-by: Andy Lowe <alowe@mvista.com>
Signed-off-by: Jean Pihet <jpihet@mvista.com>
=2D--
 drivers/mmc/host/omap_hsmmc.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 1fcc544..b7d111e 100644
=2D-- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -44,6 +44,7 @@
 #define OMAP_HSMMC_RSP54	0x0118
 #define OMAP_HSMMC_RSP76	0x011C
 #define OMAP_HSMMC_DATA		0x0120
+#define OMAP_HSMMC_PSTATE	0x0124
 #define OMAP_HSMMC_HCTL		0x0128
 #define OMAP_HSMMC_SYSCTL	0x012C
 #define OMAP_HSMMC_STAT		0x0130
@@ -89,6 +90,7 @@
 #define DUAL_VOLT_OCR_BIT	7
 #define SRC			(1 << 25)
 #define SRD			(1 << 26)
+#define DATI			(1 << 1)
=20
 /*
  * FIXME: Most likely all the data using these _DEVID defines should come
@@ -273,6 +275,15 @@ mmc_omap_start_command(struct mmc_omap_host *host, str=
uct mmc_command *cmd,
 		mmc_hostname(host->mmc), cmd->opcode, cmd->arg);
 	host->cmd =3D cmd;
=20
+	if (OMAP_HSMMC_READ(host->base, PSTATE) & DATI) {
+		dev_dbg(mmc_dev(host->mmc), "mmc_omap_start_command: "
+			" resetting data state machine\n");
+		OMAP_HSMMC_WRITE(host->base, SYSCTL,
+			OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
+		while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
+			;
+	}
+
 	/*
 	 * Clear status bits and enable interrupts
 	 */
=2D-=20
1.5.4.4.21.gc4a6c


--Boundary-00=_bPIZJXG+e6BEYbc--
