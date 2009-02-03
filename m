Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZBCEBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZBCEBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZBCEAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:00:52 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53842 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbZBCEAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:00:50 -0500
Message-ID: <4987C168.5060807@garzik.org>
Date: Mon, 02 Feb 2009 23:00:40 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Hugh Dickins <hugh@veritas.com>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils> <20090126191256.04dfb6d3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090126191256.04dfb6d3@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> And while we are at it fix the 32bit PIO handling for VLB for this case
> too
> 
> pata_legacy: For VLB 32bit PIO don't try tricks with slop
> 
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> These devices are generally used with ATA anyway and it seems that some
> ATAPI will need us to issue the right number of words. Therefore as we
> can't switch mid burst on VLB devices we should only use 32bit I/O for
> suitable block sizes.
> ---
> 
>  drivers/ata/pata_legacy.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
> index 6c1d778..e3bc1b4 100644
> --- a/drivers/ata/pata_legacy.c
> +++ b/drivers/ata/pata_legacy.c
> @@ -283,9 +283,10 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
>  static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
>  			unsigned char *buf, unsigned int buflen, int rw)
>  {
> -	if (ata_id_has_dword_io(dev->id)) {
> +	int slop = buflen & 3;
> +	/* 32bit I/O capable *and* we need to write a whole number of dwords */
> +	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)) {
>  		struct ata_port *ap = dev->link->ap;
> -		int slop = buflen & 3;
>  		unsigned long flags;
>  
>  		local_irq_save(flags);
> @@ -735,7 +736,7 @@ static unsigned int vlb32_data_xfer(struct ata_device *adev, unsigned char *buf,
>  	struct ata_port *ap = adev->link->ap;
>  	int slop = buflen & 3;
>  
> -	if (ata_id_has_dword_io(adev->id)) {
> +	if (ata_id_has_dword_io(adev->id) && (slop == 0 || slop == 3)) {
>  		if (rw == WRITE)
>  			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);

tested etc.?  I don't see a sign-off...


