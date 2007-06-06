Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbXFFSYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbXFFSYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 14:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXFFSYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 14:24:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:26497 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbXFFSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 14:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fe03bgWufVuyNKJop98Jy+IQkVSrFzg3Js/kUK8fyU9qRktXRe6SThc4a230A9xQt5i1TyfO1OqgbV8Wrf4gJmjGHy2C+Q6jF8ypfWUmc8TzTxqKvp9/pVtNKr5Wtu3c7YeBQw8cxAmS4uCXSlwBTL0AXItoYrAG7NI5Vo/fr7I=
Message-ID: <4666FBE8.3030103@gmail.com>
Date: Wed, 06 Jun 2007 20:24:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, htejun@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>	<4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org>
In-Reply-To: <20070606105650.bebf1c95.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Wed, 06 Jun 2007 17:34:16 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Mikael Pettersson napsal(a):
>>> On Wed, 06 Jun 2007 15:04:00 +0200, Jiri Slaby wrote:
>>>> Andrew Morton napsal(a):
>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>>>> It freezes during bootup while searching for sata drives on sata_promise. There
>>>> were 2 issues with sata_promise in -rc4 IIRC, one was fixed, the latter remains
>>>> unresolved. Or, should be this solved too, Mikael, Tejun and is this yet
>>>> eanother problem? (In this case I'll post dmesg and co.)
>>> I know of only one sata_promise-specific issue in 2.6.22-rc4.
>>> Tejun's "sata_promise: use TF interface for polling NODATA commands"
>>> patch posted today fixes it.
>> It's in that -mm, so I think, this seems to be another problem.
> 
> No, it wasn't in 2.6.22-rc4-mm1.

Huh, what did I smoke? Something rejects to patch and now I don't know what.

> Here it is - please test?

Ok, this solves this problem, but LVM is broken. Seems similar to
Re: 2.6.22-rc4-mm1 - 'lvm vgscan' busticated again...
Message-ID: <7929.1181146132@turing-police.cc.vt.edu>
Will try to play with this.

> From: Tejun Heo <htejun@gmail.com>
> 
> sata_promise uses two different command modes - packet and TF.  Packet mode
> is intelligent low-overhead mode while TF is the same old taskfile
> interface.  As with other advanced interface (ahci/sil24),
> ATA_TFLAG_POLLING has no effect in packet mode.  However, PIO commands are
> issued using TF interface in polling mode, so pdc_interrupt() considers
> interrupts spurious if ATA_TFLAG_POLLING is set.
> 
> This is broken for polling NODATA commands because command is issued using
> packet mode but the interrupt handler ignores it due to ATA_TFLAG_POLLING. 
> Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA commands are issued
> using TF interface if ATA_TFLAG_POLLING is set.
> 
> This patch fixes detection failure introduced by polling SETXFERMODE.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Acked-by: Mikael Pettersson <mikpe@it.uu.se>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/ata/sata_promise.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff -puN drivers/ata/sata_promise.c~sata_promise-use-tf-interface-for-polling-nodata-commands drivers/ata/sata_promise.c
> --- a/drivers/ata/sata_promise.c~sata_promise-use-tf-interface-for-polling-nodata-commands
> +++ a/drivers/ata/sata_promise.c
> @@ -784,9 +784,12 @@ static unsigned int pdc_qc_issue_prot(st
>  		if (qc->dev->flags & ATA_DFLAG_CDB_INTR)
>  			break;
>  		/*FALLTHROUGH*/
> +	case ATA_PROT_NODATA:
> +		if (qc->tf.flags & ATA_TFLAG_POLLING)
> +			break;
> +		/*FALLTHROUGH*/
>  	case ATA_PROT_ATAPI_DMA:
>  	case ATA_PROT_DMA:
> -	case ATA_PROT_NODATA:
>  		pdc_packet_start(qc);
>  		return 0;
>  
> @@ -800,7 +803,7 @@ static unsigned int pdc_qc_issue_prot(st
>  static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
>  {
>  	WARN_ON (tf->protocol == ATA_PROT_DMA ||
> -		 tf->protocol == ATA_PROT_NODATA);
> +		 tf->protocol == ATA_PROT_ATAPI_DMA);
>  	ata_tf_load(ap, tf);
>  }
>  
> @@ -808,7 +811,7 @@ static void pdc_tf_load_mmio(struct ata_
>  static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
>  {
>  	WARN_ON (tf->protocol == ATA_PROT_DMA ||
> -		 tf->protocol == ATA_PROT_NODATA);
> +		 tf->protocol == ATA_PROT_ATAPI_DMA);
>  	ata_exec_command(ap, tf);
>  }

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
