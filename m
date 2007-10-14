Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbXJNQQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbXJNQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 12:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbXJNQQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 12:16:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:26712 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbXJNQQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 12:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UCczEV9UC4M8SrZ5mpIsh8Vi0Z7Uukd611WXB6VWPmRz+D5Zdr4+c0QnEovGd03W4/70hmP52hcjGn6MqQlhjBJ6QN9feNhk3WtJUDBSqe6f2fhPCcEDAAD4RrY4IpnNNoyi9yGRq6Nx2dU/wUIFzjquUBScYlL6CjSeLjNDX5A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [git patches] IDE updates (part 2)
Date: Sun, 14 Oct 2007 18:07:23 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710131825.24768.bzolnier@gmail.com> <200710140041.25152.bzolnier@gmail.com> <1192320489.22054.40.camel@pasglop>
In-Reply-To: <1192320489.22054.40.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710141807.24295.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007, Benjamin Herrenschmidt wrote:
> 
> On Sun, 2007-10-14 at 00:41 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 14 October 2007, Alan Cox wrote:
> > > > > > 		/* Probably a PCI interface... */
> > > > > > 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
> > > > > > 			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
> > > > > > 		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
> > > 
> > > Ok so in actual fact
> > > 
> > > - The piece of code above can't be executed anyway
> > > - The ctrl_port argument is not needed ?
> > 
> > pmac_ide_init_hwif_ports() is also called by ide_init_hwif_ports()
> > through ppc_ide_md.init_hwif.
> 
> In which case it should be called with a ctrl_port right ?

Yep.

How's about this patch?

[PATCH] ide-pmac: fix pmac_ide_init_hwif_ports()

* pmac_ide_init_hwif_ports() can be called by ide_init_hwif_ports()
  (through ppc_ide_md.ide_init_hwif hook) for non IDE PMAC interfaces.
  If this is the case the hw->io_ports[] should be already setup by
  ide_init_hwif_ports()->ide_std_init_ports() so remove redundant code
  from pmac_ide_init_hwif_ports().

  As side-effect this change fixes ctl_addr == 0 special handling in
  ide_init_hwif_ports().

* Fix misleading comment while at it.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -438,13 +438,8 @@ pmac_ide_init_hwif_ports(hw_regs_t *hw,
 		if (data_port == pmac_ide[ix].regbase)
 			break;
 
-	if (ix >= MAX_HWIFS) {
-		/* Probably a PCI interface... */
-		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
-			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
-		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
-		return;
-	}
+	if (ix >= MAX_HWIFS)
+		return;		/* not an IDE PMAC interface */
 
 	for (i = 0; i < 8; ++i)
 		hw->io_ports[i] = data_port + i * 0x10;
