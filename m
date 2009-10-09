Return-Path: <linux-kernel-owner+w=401wt.eu-S934535AbZJIVyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535AbZJIVyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934513AbZJIVyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:54:14 -0400
Received: from [207.36.208.214] ([207.36.208.214]:42783 "EHLO mail.dvmed.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934514AbZJIVyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:54:04 -0400
Message-ID: <4ACFB0C9.605@garzik.org>
Date: Fri, 09 Oct 2009 17:53:13 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata build fix
References: <20091009043248.GA12304@havoc.gtf.org> <20091009083903.GA20687@elte.hu>
In-Reply-To: <20091009083903.GA20687@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2009 04:39 AM, Ingo Molnar wrote:
> From: Ingo Molnar<mingo@elte.hu>
> Date: Fri, 9 Oct 2009 10:13:56 +0200
> Subject: [PATCH] ahci: Fix "filter FPDMA non-zero offset enable for Aspire 3810T" on !CONFIG_ATA_ACPI
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
>
> Commit f80ae7e ("ahci: filter FPDMA non-zero offset enable for Aspire
> 3810T") introduced a new build breakage:
>
>    drivers/ata/ahci.c: In function ‘ahci_gtf_filter_workaround’:
>    drivers/ata/ahci.c:2927: error: ‘struct ata_device’ has no member named ‘gtf_filter’
>    make[2]: *** [drivers/ata/ahci.o] Error 1
>    make[1]: *** [drivers/ata] Error 2
>    make[1]: *** Waiting for unfinished jobs....
>
> As the acpi taskfile command filter support is a property of
> libata-acpi - so the ata_device::gtf_filter field only exists
> under CONFIG_ATA_ACPI.
>
> Add the trivial #ifdef to turn ahci_gtf_filter_workaround()
> into a NOP on !CONFIG_ATA_ACPI.
>
> Cc: Marcus Meissner<meissner@novell.com>
> Cc: Jeff Garzik<jgarzik@redhat.com>
> Signed-off-by: Ingo Molnar<mingo@elte.hu>
> ---
>   drivers/ata/ahci.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 4edca6e..fc8d527 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -2886,6 +2886,7 @@ static bool ahci_broken_online(struct pci_dev *pdev)
>
>   static void ahci_gtf_filter_workaround(struct ata_host *host)
>   {
> +#ifdef CONFIG_ATA_ACPI
>   	static const struct dmi_system_id sysids[] = {
>   		/*
>   		 * Aspire 3810T issues a bunch of SATA enable commands
> @@ -2926,6 +2927,7 @@ static void ahci_gtf_filter_workaround(struct ata_host *host)
>   			ata_for_each_dev(dev, link, ALL)
>   				dev->gtf_filter |= filter;
>   	}
> +#endif
>   }


Either way is fine with me.  I tend to prefer conditional compilation to 
be outside a function, but it's not a big deal.  Linus can pull my 
submit, or add
	Acked-by: Jeff Garzik <jgarzik@redhat.com>
to this Ingo patch.

Same end result; whichever makes people happier, and fixes builds the 
most rapidly...

	Jeff



