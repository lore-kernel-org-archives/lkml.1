Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbZARBXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbZARBXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 20:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbZARBXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 20:23:21 -0500
Received: from ns2.suse.de ([195.135.220.15]:38322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbZARBXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 20:23:20 -0500
From: Andreas Schwab <schwab@suse.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] ide: small ide_register_port() cleanup
References: <200811122216.06257.bzolnier@gmail.com>
X-Yow: BARBARA STANWYCK makes me nervous!!
Date: Sun, 18 Jan 2009 02:23:18 +0100
In-Reply-To: <200811122216.06257.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Wed, 12 Nov 2008 22:16:06 +0100")
Message-ID: <jeocy58l15.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-probe.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> Index: b/drivers/ide/ide-probe.c
> ===================================================================
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -640,14 +640,9 @@ static int ide_register_port(ide_hwif_t 
>  	/* register with global device tree */
>  	dev_set_name(&hwif->gendev, hwif->name);
>  	hwif->gendev.driver_data = hwif;
> -	if (hwif->gendev.parent == NULL) {
> -		if (hwif->dev)
> -			hwif->gendev.parent = hwif->dev;
> -		else
> -			/* Would like to do = &device_legacy */
> -			hwif->gendev.parent = NULL;
> -	}
> +	hwif->gendev.parent = hwif->dev;

This breaks ide-pmac.  It overwrites the parent that
pmac_ide_macio_attach has set.

Signed-off-by: Andreas Schwab <schwab@suse.de>

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 312127e..0db1ed9 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -649,7 +649,8 @@ static int ide_register_port(ide_hwif_t *hwif)
 	/* register with global device tree */
 	dev_set_name(&hwif->gendev, hwif->name);
 	hwif->gendev.driver_data = hwif;
-	hwif->gendev.parent = hwif->dev;
+	if (hwif->gendev.parent == NULL)
+		hwif->gendev.parent = hwif->dev;
 	hwif->gendev.release = hwif_release_dev;
 
 	ret = device_register(&hwif->gendev);

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
