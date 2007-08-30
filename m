Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXH3KuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXH3KuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbXH3KuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:50:08 -0400
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:44831 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753214AbXH3KuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:50:06 -0400
X-YMail-OSG: enbPWUIVM1lD5ZTEWjSI0HfhOWPd9GyGJOairBPEN4xPIm6G1SZg.oIgtlr8zI0TbGycrHZQ5IxqPCW0XX.yqy725A--
X-RocketYMMF: knobi.rm
Date: Thu, 30 Aug 2007 03:50:05 -0700 (PDT)
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
Message-ID: <627732.90093.qm@web32605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jens Axboe <jens.axboe@oracle.com> wrote:

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
Hi Jens,

 how exactely is the queue depth related to the max # of commands? I
ask, because with the 2.6.22 kernel the "maximum queue depth since
init" seems to be never higher than 16, even with much higher
outstanding commands. On a 2.6.19 kernel, maximum queue depth is much
higher, just a bit below "max # of commands since init".

[2.6.22]# cat /proc/driver/cciss/cciss0
cciss0: HP Smart Array 6i Controller
Board ID: 0x40910e11
Firmware Version: 2.76
IRQ: 51
Logical drives: 1
Max sectors: 2048
Current Q depth: 0
Current # commands on controller: 145
Max Q depth since init: 16
Max # commands on controller since init: 204
Max SG entries since init: 31
Sequential access devices: 0

[2.6.19] cat /proc/driver/cciss/cciss0
cciss0: HP Smart Array 6i Controller
Board ID: 0x40910e11
Firmware Version: 2.76
IRQ: 51
Logical drives: 1
Current Q depth: 0
Current # commands on controller: 0
Max Q depth since init: 197
Max # commands on controller since init: 198
Max SG entries since init: 31
Sequential access devices: 0

Cheers
Martin




------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
