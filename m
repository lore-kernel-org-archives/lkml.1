Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbXH2O0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbXH2O0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXH2O0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:26:22 -0400
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:34847 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751936AbXH2O0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:26:22 -0400
X-YMail-OSG: 5.3m1AYVM1me_V_w9Agurbks8uwrJHmKnDkkmnyYAUyhWoHUVREME7q.2JAdd_.3cL4AJ6tpV3UG1Fj4bWRVJyljow--
X-RocketYMMF: knobi.rm
Date: Wed, 29 Aug 2007 07:26:21 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour - next try
To: Jens Axboe <jens.axboe@oracle.com>,
       Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com
In-Reply-To: <20070829094801.GK23758@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <318042.34559.qm@web32605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Aug 28 2007, Martin Knoblauch wrote:
> > Keywords: I/O, bdi-v9, cfs
> > 
> 
> Try limiting the queue depth on the cciss device, some of those are
> notoriously bad at starving commands. Something like the below hack,
> see
> if it makes a difference (and please verify in dmesg that it prints
> the
> message about limiting depth!):
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 084358a..257e1c3 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -2992,7 +2992,12 @@ static int cciss_pci_init(ctlr_info_t *c,
> struct pci_dev *pdev)
>  		if (board_id == products[i].board_id) {
>  			c->product_name = products[i].product_name;
>  			c->access = *(products[i].access);
> +#if 0
>  			c->nr_cmds = products[i].nr_cmds;
> +#else
> +			c->nr_cmds = 2;
> +			printk("cciss: limited max commands to 2\n");
> +#endif
>  			break;
>  		}
>  	}
> 
> -- 
> Jens Axboe
> 
> 
>
Hi Jens,

 thanks for the suggestion. Unfortunatelly the non-direct [parallel]
writes to the device got considreably slower. I guess the "6i"
controller copes better with higher values.

 Can nr_cmds be changed at runtime? Maybe there is a optimal setting.

[   69.438851] SCSI subsystem initialized
[   69.442712] HP CISS Driver (v 3.6.14)
[   69.442871] ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 51 (level,
low) -> IRQ 51
[   69.442899] cciss: limited max commands to 2 (Smart Array 6i)
[   69.482370] cciss0: <0x46> at PCI 0000:04:03.0 IRQ 51 using DAC
[   69.494352]       blocks= 426759840 block_size= 512
[   69.498350]       heads=255, sectors=32, cylinders=52299
[   69.498352]
[   69.498509]       blocks= 426759840 block_size= 512
[   69.498602]       heads=255, sectors=32, cylinders=52299
[   69.498604]
[   69.498608]  cciss/c0d0: p1 p2

Cheers
Martin


------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
