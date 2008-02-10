Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYBJXRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYBJXRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYBJXQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:16:56 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:38982 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYBJXQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:16:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uipLyN7p2h/1XRUnCM2Gz9dl1g+yfWsBcJ3NIoQbGe5OEFnhGx+BWXvZOd3Hjf5kw9Tc4Z0NjZ5JgXc5P2HTk1vByFmElQx1r/TkROFYZSlkm6MfMPXZLpbYNXQsvXSY5ljFDHGALUHmk2cbjJqNr+SlH6e2ny6LOZbC5nn+qKY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 7/8] ide: add struct ide_port_info instances to legacy host drivers
Date: Mon, 11 Feb 2008 00:16:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain> <20080211.010729.115910395.anemo@mba.ocn.ne.jp> <200802101804.49154.bzolnier@gmail.com>
In-Reply-To: <200802101804.49154.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802110016.08078.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 10 February 2008, Atsushi Nemoto wrote:
> > On Sun, 06 Jan 2008 18:03:10 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > > +	/* reset DMA masks only for SFF-style DMA controllers */
> > > +	if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
> > > +		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
> > 
> > It might be too late, but "host_flags && IDE_HFLAGS_NO_DMA" seems
> > wrong for me.
> 
> It is too late for -git but not too late for 2.6.25-rc1. ;-)
> 
> Could you make a patch please?

I went ahead and made a patch (sorry, I needed it for git pull request :).

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: ide_init_port() bugfix

On Sunday 10 February 2008, Atsushi Nemoto wrote:
> On Sun, 06 Jan 2008 18:03:10 +0100, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > +	/* reset DMA masks only for SFF-style DMA controllers */
> > +	if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
> > +		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
> 
> It might be too late, but "host_flags && IDE_HFLAGS_NO_DMA" seems
> wrong for me.

Fix regression caused by commmit c413b9b94d9a8e7548cc4b2e04b7df0439ce76fd
("ide: add struct ide_port_info instances to legacy host drivers").

Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1355,7 +1355,7 @@ static void ide_init_port(ide_hwif_t *hw
 	hwif->ultra_mask = d->udma_mask;
 
 	/* reset DMA masks only for SFF-style DMA controllers */
-	if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
+	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
 		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
 
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)

