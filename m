Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYEIOyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYEIOyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 10:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYEIOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 10:54:12 -0400
Received: from rtr.ca ([76.10.145.34]:2389 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYEIOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 10:54:11 -0400
Message-ID: <48246591.7040209@rtr.ca>
Date: Fri, 09 May 2008 10:54:09 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: =?UTF-8?B?IkouQS4gTWFnYWxsw7NuIg==?= <jamagallon@ono.com>
Cc: Jeff Garzik <jeff@garzik.org>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linus-IDE <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] Re: [git patches] libata updates - (improve post-reset
 device ready test) regression
References: <20080506154847.GA15299@havoc.gtf.org>	<20080507145616.GA2210@gentoox2.trippelsdorf.de>	<48231DAF.7070900@garzik.org> <20080508234300.3c2a38af@werewolf.home>
In-Reply-To: <20080508234300.3c2a38af@werewolf.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> On Thu, 08 May 2008 11:35:11 -0400, Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Markus Trippelsdorf wrote:
>>>> Tejun Heo (12):
>>>>       libata: improve post-reset device ready test
>>> This commit (78ab88f04f44bed566d51dce0c7cbfeff6449a06) causes a long
>>> boot delay with my onboard Promise controller. It seems like libata
>>> probes for a nonexisting PATA drive...
>>>
> 
> I also had this patch collected from LKML, that still applies to -git6.
> Is it really needed ?
> ref: http://marc.info/?l=linux-ide&m=120913178617926&w=2
..
> --- upstream/drivers/ata/libata-eh.c	2008-04-30 17:35:36.000000000 -0400
> +++ linux/drivers/ata/libata-eh.c	2008-04-30 17:35:45.000000000 -0400
> @@ -1312,8 +1312,7 @@
>  		err_mask |= AC_ERR_ATA_BUS;
>  		action |= ATA_EH_RESET;
>  	}
> -	if (serror &
> -	    (SERR_DATA_RECOVERED | SERR_COMM_RECOVERED | SERR_DATA)) {
> +	if (serror & (SERR_DATA_RECOVERED | SERR_DATA)) {
>  		err_mask |= AC_ERR_ATA_BUS;
>  		action |= ATA_EH_RESET;
>  	}

..

The original problem I had, which prompted this patch, eventually was
resolved in other ways.  But I do think that a hw-recovered bit in SError
is not a good reason to reset everything.

Tejun suggested that we still want to know about such errors,
and eventually do something if they repeat often enough.
But doing a port/link reset every single time ? 

> @@ -1924,7 +1923,7 @@
>  	}
>  
>  	if (ehc->i.serror)
> -		ata_port_printk(ap, KERN_ERR,
> +		ata_link_printk(link, KERN_ERR,
>  		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
>  		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
>  		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
> 
..

That portion of the patch is still a very good idea.

Cheers
