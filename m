Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbYENU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbYENU22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYENU2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 16:28:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:4750 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYENU2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 16:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=GZwRyqyOp3y/j13t0IV/vopr2quHQ5HmIFlDB/EztDSrlGJVAAHGNviOjeShT2ug1+r9VL/pDNux0RvawrjPeCel+uRCri6iRanHc3p6piL1deEtzivhrw+hvLWqbC4FQnrsJ4vG4w62GppU5kji5Zp1lzY8X8cP5ziIiqo8CK8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
Date: Wed, 14 May 2008 22:44:48 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <58cb370e0805080607n4f5de192o5a7371fd0fb1e9f8@mail.gmail.com> <200805091127.53737.bzolnier@gmail.com> <20080509.215601.208967867.takada@mbf.nifty.com>
In-Reply-To: <20080509.215601.208967867.takada@mbf.nifty.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805142244.48548.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2008, TAKADA Yoshihito wrote:
> Hi.
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
> Date: Fri, 9 May 2008 11:27:53 +0200
> 
> > On Friday 09 May 2008, TAKADA Yoshihito wrote:
> > > Thanks for quick reply.
> > > 
> > > I tried 2.6.26rc1. It hangs same as 2.6.25.
> > > kernel 2.6.26rc1 with cs5520 cannot boot. cs5520 scans ide0 and ide1.
> > > It seems 2nd port DMA base issue was solved.
> > 
> > [...]
> > 
> > Thanks.
> > 
> > The following patch for 2.6.26-rc1 disables VDMA, please give it a try
> > (I haven't time to fully audit VDMA support yet but lets see if it is
> > the main source of the problems).
> 
> I applied the patch. But kernel was hung.
> And I attempt to kill IDE_HFLAG_CS5520. It cannot boot, oo.
> 
>   kill IDE_HFLAG_VDMA  : hang  
>   kill IDE_HFLAG_CS5520: hang
>   kill both flags      : boot

Thanks for investigating this - I forgot that currently VDMA and CS5520
host flags use the same bit (so it also needs to be fixed).

I'm going to send the following patch to Linus (please verify it):

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cs5520: disable VDMA

Disable Virtual DMA support for now (it causes system hangs).

Thanks to TAKADA Yoshihito for the help with debugging the problem.

Reported-by: TAKADA Yoshihito <takada@mbf.nifty.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cs5520.c |    2 +-
 include/linux/ide.h      |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -119,6 +119,7 @@ static const struct ide_dma_ops cs5520_d
 	.dma_timeout		= ide_dma_timeout,
 };
 
+/* FIXME: VDMA is disabled because it caused system hangs */
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
@@ -126,7 +127,6 @@ static const struct ide_dma_ops cs5520_d
 		.dma_ops	= &cs5520_dma_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
 				  IDE_HFLAG_CS5520 |		\
-				  IDE_HFLAG_VDMA |		\
 				  IDE_HFLAG_NO_ATAPI_DMA |	\
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE, \
 		.pio_mask	= ATA_PIO4,			\
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1058,8 +1058,8 @@ enum {
 	IDE_HFLAG_NO_SET_MODE		= (1 << 9),
 	/* trust BIOS for programming chipset/device for DMA */
 	IDE_HFLAG_TRUST_BIOS_FOR_DMA	= (1 << 10),
-	/* host uses VDMA (tied with IDE_HFLAG_CS5520 for now) */
-	IDE_HFLAG_VDMA			= (1 << 11),
+	/* host is CS5510/CS5520 */
+	IDE_HFLAG_CS5520		= (1 << 11),
 	/* ATAPI DMA is unsupported */
 	IDE_HFLAG_NO_ATAPI_DMA		= (1 << 12),
 	/* set if host is a "non-bootable" controller */
@@ -1070,8 +1070,6 @@ enum {
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
 	/* host uses MMIO */
 	IDE_HFLAG_MMIO			= (1 << 16),
-	/* host is CS5510/CS5520 */
-	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */
 	IDE_HFLAG_NO_LBA48		= (1 << 17),
 	/* no LBA48 DMA */
@@ -1101,6 +1099,8 @@ enum {
 	IDE_HFLAG_NO_IO_32BIT		= (1 << 30),
 	/* never unmask IRQs */
 	IDE_HFLAG_NO_UNMASK_IRQS	= (1 << 31),
+	/* host uses VDMA (disabled for now) */
+	IDE_HFLAG_VDMA			= 0,
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
