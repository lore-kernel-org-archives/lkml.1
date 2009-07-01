Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZGAR2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZGAR2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZGAR2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:28:17 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:64781 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZGAR2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cmon2XDpjL6pdRFuUQIEgG6hQDUrNjeOuniWQeJrGe7ZoncVt5S+yg6QaCO75h72Ac
         ho/+jGz1fUAdUf6otrIV6JAi+Y1VOIeRTmjekS1kIDc1ETdvgZaEemmjQd2YbfrmGOS1
         CVgvWfx+G2mtNHzp3KE8Mq0naq0M1n8U4RYvA=
MIME-Version: 1.0
In-Reply-To: <200907011829.16850.bzolnier@gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <1246459661.9660.40.camel@falcon>
	 <200907011821.26091.bzolnier@gmail.com>
	 <200907011829.16850.bzolnier@gmail.com>
Date: Thu, 2 Jul 2009 01:28:18 +0800
Message-ID: <b6a2187b0907011028r27d35be4xc62c7ed4496dfb2f@mail.gmail.com>
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: wuzhangjin@gmail.com, Etienne Basset <etienne.basset@numericable.fr>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n61HSboU031544

On Thu, Jul 2, 2009 at 12:29 AM, BartlomiejZolnierkiewicz<bzolnier@gmail.com> wrote:> Here is the more complete version, also taking into the account changes> in ide_intr() and ide_timer_expiry():
This works great for. Survived STR, STD. I just applied on top vanillalatest Linus's git pull. Nothing else to revert.
Thanks,Jeff.

> --->  drivers/ide/ide-io.c |   15 ++++++++++----->  1 file changed, 10 insertions(+), 5 deletions(-)>> Index: b/drivers/ide/ide-io.c> ===================================================================> --- a/drivers/ide/ide-io.c> +++ b/drivers/ide/ide-io.c> @@ -532,7 +532,8 @@ repeat:>>                if (startstop == ide_stopped) {>                        rq = hwif->rq;> -                       hwif->rq = NULL;> +                       if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0)> +                               hwif->rq = NULL;>                        goto repeat;>                }>        } else> @@ -679,8 +680,10 @@ void ide_timer_expiry (unsigned long dat>                spin_lock_irq(&hwif->lock);>                enable_irq(hwif->irq);>                if (startstop == ide_stopped && hwif->polling == 0) {> -                       rq_in_flight = hwif->rq;> -                       hwif->rq = NULL;> +                       if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {> +                               rq_in_flight = hwif->rq;> +                               hwif->rq = NULL;> +                       }>                        ide_unlock_port(hwif);>                        plug_device = 1;>                }> @@ -856,8 +859,10 @@ irqreturn_t ide_intr (int irq, void *dev>         */>        if (startstop == ide_stopped && hwif->polling == 0) {>                BUG_ON(hwif->handler);> -               rq_in_flight = hwif->rq;> -               hwif->rq = NULL;> +               if ((drive->dev_flags & IDE_DFLAG_BLOCKED) == 0) {> +                       rq_in_flight = hwif->rq;> +                       hwif->rq = NULL;> +               }>                ide_unlock_port(hwif);>                plug_device = 1;>        }>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
