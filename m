Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYHEO0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYHEO0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYHEO0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:26:25 -0400
Received: from h155.mvista.com ([63.81.120.155]:19471 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754811AbYHEO0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:26:24 -0400
Message-ID: <4898630C.7090403@ru.mvista.com>
Date: Tue, 05 Aug 2008 18:26:20 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: petkovbb@gmail.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_legacy: export functionality to ide
References: <20080715053356.GA18628@gollum.tnic> <200808021902.12191.bzolnier@gmail.com> <20080802183253.GA2239@gollum.tnic> <200808022046.16990.bzolnier@gmail.com> <20080803073756.GA8762@gollum.tnic> <20080803125907.67676948@lxorguk.ukuu.org.uk> <20080803143837.GA26672@gollum.tnic> <20080803162214.394b13a1@lxorguk.ukuu.org.uk> <20080803165135.GA31977@gollum.tnic>
In-Reply-To: <20080803165135.GA31977@gollum.tnic>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:

> Avoid probing the io-ports in case an IDE PCI controller is present and it uses
> the legacy iobases. If we still want to enforce the probing, we do

> ide_generic.probe_mask=0x3f

> on the kernel command line. The iobase checking code is adapted from
> drivers/ata/pata_legacy.c

> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

> diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
> index 8fe8b5b..e9b7b69 100644
> --- a/drivers/ide/ide-generic.c
> +++ b/drivers/ide/ide-generic.c
[...]
> @@ -100,19 +100,71 @@ static const u16 legacy_bases[] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
>  static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
>  #endif
>  
> +

    Extra newline...

> +static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
> +{
> +	struct pci_dev *p = NULL;
> +	u16 val;
> +
> +	for_each_pci_dev(p) {
> +		int r;
> +
> +		for (r = 0; r < 6; r++) {
> +			if (pci_resource_start(p, r) == 0x1f0)
> +				*primary = 1;
> +			if (pci_resource_start(p, r) == 0x170)
> +				*secondary = 1;
> +		}
> +
> +		/* Cyrix CS5510 pre SFF MWDMA ATA on the bridge */
> +		if (p->vendor == 0x1078 && p->device == 0x0000)
> +			*primary = *secondary = 1;
> +
> +		/* Cyrix CS5520 pre SFF MWDMA ATA on the bridge */
> +		if (p->vendor == 0x1078 && p->device == 0x0002)
> +			*primary = *secondary = 1;

    I think the above two if statements should be collapsed into a single one.

> +
> +		/* Intel MPIIX - PIO ATA on non PCI side of bridge */
> +		if (p->vendor == 0x8086 && p->device == 0x1234) {

    Also, perhaps it makes sense to #include <linux/pci_ids.h> and use the 
macros defined there...

MBR, Sergei
