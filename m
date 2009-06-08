Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZFHVXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZFHVXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZFHVXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:23:12 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:44316 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZFHVXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=aTNptjpHjeYi0OfC7NFngDKRLeqZAdoOeGvQdeadhSl2CuySvuJSoQ/KoS36hFBv/A
         styUv8Ixf9ATBpHtuoKkUM2F8imNUsfFtAeYpWAEtKgtzeevWnis2VXbRaRftq3+YQNA
         Jyrbdyt5ChRmcNbhjItLZ2dlE4MPdLvc+iYL8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH next] ide: fix PowerMac bootup oops
Date: Mon, 8 Jun 2009 23:28:02 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Joao Ramos <joao.ramos@inov.pt>,
       Sergei Shtylyov <sshtylyov@ru.montavista.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <Pine.LNX.4.64.0906082137120.22183@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906082137120.22183@sister.anvils>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906082328.02729.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Hugh,

On Monday 08 June 2009 22:45:28 Hugh Dickins wrote:
> PowerMac bootup with CONFIG_IDE=y oopses in ide_pio_cycle_time():
> because "ide: try to use PIO Mode 0 during probe if possible" causes
> pmac_ide_set_pio_mode() now to be called before drive->id has been set.

Good spotting, I overlooked this aspect of the change while testing it
with piix host driver..

> It does the right thing if id is not set, so long as we check for that.

After auditing some other host drivers I see that drive->id can be used
also directly in ->set_pio_mode methods..

Could you please instead try moving ->id allocation from probe_for_drive()
to ide_port_alloc_devices() (this would fix all such issues for good) and
verify that it also fixes the oops?

> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  drivers/ide/ide-timings.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- lnext/drivers/ide/ide-timings.c	2009-04-08 18:25:55.000000000 +0100
> +++ linux/drivers/ide/ide-timings.c	2009-06-03 19:45:58.000000000 +0100
> @@ -84,7 +84,7 @@ u16 ide_pio_cycle_time(ide_drive_t *driv
>  	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
>  	u16 cycle = 0;
>  
> -	if (id[ATA_ID_FIELD_VALID] & 2) {
> +	if (id && (id[ATA_ID_FIELD_VALID] & 2)) {
>  		if (ata_id_has_iordy(drive->id))
>  			cycle = id[ATA_ID_EIDE_PIO_IORDY];
>  		else
