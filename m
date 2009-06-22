Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbZFVOgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbZFVOgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZFVOgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:36:15 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46158 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZFVOgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=xWZ0PeNpqD4WQ7bFFHSaZNtpuB+IBdgxBou18erMHR8+xnFBXOB56SAxTAlZzfCk+C
         Azw45MDEmhYivvOptpj0u7YtJAGELZLK5N0VxcZ9nqZTwMxoXi/96eIEN+XObR0/+4mE
         IWFu7kCRxt+E63pDr1ooPNhKd5AeY4uR2bWDI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
Date: Mon, 22 Jun 2009 16:39:50 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906211446.38598.elendil@planet.nl> <200906221321.44672.bzolnier@gmail.com> <200906221604.17915.elendil@planet.nl>
In-Reply-To: <200906221604.17915.elendil@planet.nl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906221639.52205.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009 16:04:15 Frans Pop wrote:
> On Monday 22 June 2009, you wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: fix handling of unexpected IRQs vs request_irq()
> >
> > Add ide_host_enable_irqs() helper and use it in ide_host_register()
> > before registering ports.  Then remove no longer needed IRQ unmasking
> > from in init_irq().
> >
> > This should fix the problem with "screaming" shared IRQ on the first
> > port (after request_irq() call while we have the unexpected IRQ pending
> > on the second port) which was uncovered by my rework of the serialized
> > interfaces support.
> 
> Thanks Bart. This does solve the "nobody cared" problem.
> Tested-by: Frans Pop <elendil@planet.nl>
> 
> I also tested it without David's initial patch (i.e. *with* 
> IDE_HFLAG_SERIALIZE in host-flags) and that seems to work fine too:
> ide0 at 0x1fe02c00000-0x1fe02c00007,0x1fe02c0000a on irq 14 (serialized)
> ide1 at 0x1fe02c00010-0x1fe02c00017,0x1fe02c0001a on irq 14 (serialized)

Great, thanks for testing it (and once again sorry for the trouble).

> No idea whether serialized is to be preferred or not. Guess that's David's 
> call now.

Since you have verified that serialization is not needed we should get rid
of it while we are at it (it negatively affects performance of simultaneous
operations on both ports of the controller).

> I do still get the "bad DMA info in identify block" error for the CD 
> drive, so that's still a regression relative to 2.6.26:
>  hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> -hdd: MWDMA2 mode selected
> +hdd: bad DMA info in identify block
> +hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4

I begin to wonder whether this problem could be the one responsible for
generating the spurious IRQ that we are seeing on the second port (I think
that this is _very_ likely)..

I promised to look into it but I still need a identify block content to
tell more (you can add #define DEBUG to the ide-probe.c so we will get id
before and after changing of transfer mode settings):

---
 drivers/ide/ide-probe.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -39,6 +39,8 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#define DEBUG
+
 /**
  *	generic_id		-	add a generic drive id
  *	@drive:	drive to make an ID block for
