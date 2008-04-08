Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYDHJgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYDHJgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYDHJgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:36:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:50452 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYDHJgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=nkoUoeJ3q7Bac3oMq3Gf9Ll+HR00Z+VOmDVUOK4x8Elf2DVBVZjnH91jA5Uj5rk27oU1yAXZ8o+Xw4Eki+LgxiubDtriX9Qbt4FMWa6CttVo1FZjAZpALlKNsrePURiQlOLVp5BYWtQO0xaU3+BuBdUoMTd/FWDCzpP0YqygYKI=
Date: Tue, 8 Apr 2008 11:40:29 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Michael Schmitz <schmitz@debian.org>
Subject: Re: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and
	->ata_*put_data methods
Message-ID: <20080408094029.GA1005@linux-m68k.org>
References: <200803301714.04527.bzolnier@gmail.com> <200803302134.42569.bzolnier@gmail.com> <Pine.LNX.4.64.0803310750230.6871@anakin> <200804072113.42441.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200804072113.42441.bzolnier@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 09:13:42PM +0200, Bartlomiej Zolnierkiewicz wrote:

> 
> v2:
> * Add 'struct request *rq' argument to ->ata_{in,out}put_data methods
>   and don't byte-swap disk fs requests (we shouldn't un-swap fs requests
>   because fs itself is stored byte-swapped on the disk) - this is how
>   things were done before the patch (ideally device mapper should be
>   used instead but it would break existing setups and would have some
>   performance impact).

I like the part about checking 'struct request *rq', will make a  clean
distinction between ide command data and ide disk/medium data which is badly
needed.

However, not only FS data is byteswapped, complete disk including partition
table and everything else is. Will "rq->cmd_type == REQ_TYPE_FS" also catch
all these cases?



> Index: b/drivers/ide/legacy/falconide.c
> ===================================================================
> --- a/drivers/ide/legacy/falconide.c
> +++ b/drivers/ide/legacy/falconide.c
> @@ -44,6 +44,36 @@
>  int falconide_intr_lock;
>  EXPORT_SYMBOL(falconide_intr_lock);
>  
> +static void falconide_atapi_input_bytes(ide_drive_t *drive, void *buf,
> +					unsigned int len)
> +{
> +	insw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
> +}
> +
> +static void falconide_atapi_output_bytes(ide_drive_t *drive, void *buf,
> +					 unsigned int len)
> +{
> +	outsw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
> +}
> +
> +static void falconide_ata_input_data(ide_drive_t *drive, struct request *rq,
> +				     void *buf, unsigned int wcount)
> +{
> +	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
> +		return insw(drive->hwif->io_ports.data_addr, buf, wcount * 2);
> +
> +	falconide_atapi_input_bytes(drive, buf, wcount * 4);
> +}

this will still do double swapping for disk access, although this is very
easier to fix once the distinction between ide and disk data works fine.

So IMHO despite the little concerns this is the way to go.

Richard
