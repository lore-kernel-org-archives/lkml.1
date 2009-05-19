Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZESVOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZESVOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbZESVOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:14:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64169 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZESVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DIFxudPHWhctsB+MmLAYDn6I4hJgyjPF0wciFNQQZW50Yna5SkuFLNuzCrcA6NuHpP
         M9Co01jNnT6BjLA3l32YPXxVOCiO11EKaHorHbBeYGYpcH4sIVTqgFWmDsashqp1PeMO
         yJb2lH5McIADjiHz/soIU9oncN0GAIMs/YdAk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Date: Tue, 19 May 2009 23:11:21 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <20090517091224.GA8280@wanza.invalid> <20090519182928.GA8172@wanza.invalid> <200905192131.00168.bzolnier@gmail.com>
In-Reply-To: <200905192131.00168.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905192311.22310.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009 21:30:59 Bartlomiej Zolnierkiewicz wrote:

[...]

> > The offer for testing patches remains open :-).
> 
> We will get there. ;-)
> 
> I've reproduced the problem and I'm testing the fix currently...

The following patch should fix OOPS w/ vanilla 2.6.30-rc6 and 40-wire cable:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix OOPS during ide-cd error recovery

On Tuesday 19 May 2009 20:29:28 Martin Lottermoser wrote:

>   hdc: cdrom_decode_status: error=0x40 <3>{ LastFailedSense=0x04 }
>   ide: failed opcode was: unknown
>   hdc: DMA disabled
>   ------------[ cut here ]------------
>   kernel BUG at drivers/ide/ide-io.c:872!

It is possible for ide-cd to ignore ide_error()'s return value under
some circumstances.  Workaround it in ide_intr() and ide_timer_expiry()
by checking if there is a device/port reset pending currently.

Reported-by: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
in the longer-term ide-cd should be fixed to not do such things
(too invasive for 2.6.30 and 2.6.29)

 drivers/ide/ide-io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -696,7 +696,7 @@ void ide_timer_expiry (unsigned long dat
 		}
 		spin_lock_irq(&hwif->lock);
 		enable_irq(hwif->irq);
-		if (startstop == ide_stopped) {
+		if (startstop == ide_stopped && hwif->polling == 0) {
 			ide_unlock_port(hwif);
 			plug_device = 1;
 		}
@@ -868,7 +868,7 @@ irqreturn_t ide_intr (int irq, void *dev
 	 * same irq as is currently being serviced here, and Linux
 	 * won't allow another of the same (on any CPU) until we return.
 	 */
-	if (startstop == ide_stopped) {
+	if (startstop == ide_stopped && hwif->polling == 0) {
 		BUG_ON(hwif->handler);
 		ide_unlock_port(hwif);
 		plug_device = 1;

