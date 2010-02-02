Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0BBPfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:35:53 -0500
Received: from nat.nue.novell.com ([195.135.221.3]:54614 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756411Ab0BBPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:35:48 -0500
Message-ID: <4B684650.9070807@suse.de>
Date: Tue, 02 Feb 2010 18:35:44 +0300
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Darren Jenkins <darrenrjenkins@gmail.com>
CC: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/acpi/ec.c fix a small memory leak
References: <1265112730.4804.8.camel@ICE-BOX>
In-Reply-To: <1265112730.4804.8.camel@ICE-BOX>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK

saved_ec is allocated if flag EC_FLAGS_VALIDATE_ECDT is true.
EC_FLAGS_SKIP_DSDT_SCAN have no sense in such case, thus this new code path
is never executed.
On the other hand, unconditionally freeing pointer, which is might be NULL, is not
right either.
So, this patch introduced more problems as it tries to solve...

Regards,
Alex.

Darren Jenkins пишет:
> Plug a very small leak in acpi_ec_ecdt_probe()
> 
> Coverity CID: 13319
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com> 
> 
> diff --git drivers/acpi/ec.c drivers/acpi/ec.c
> index d6471bb..13061dc 100644
> --- drivers/acpi/ec.c
> +++ drivers/acpi/ec.c
> @@ -1009,8 +1009,10 @@ int __init acpi_ec_ecdt_probe(void)
>  	/* fall through */
>  	}
>  
> -	if (EC_FLAGS_SKIP_DSDT_SCAN)
> +	if (EC_FLAGS_SKIP_DSDT_SCAN) {
> +		kfree(saved_ec);
>  		return -ENODEV;
> +	}
>  
>  	/* This workaround is needed only on some broken machines,
>  	 * which require early EC, but fail to provide ECDT */
> 
> 

