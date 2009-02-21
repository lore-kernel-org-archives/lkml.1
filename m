Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZBUE7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZBUE7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 23:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZBUE6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 23:58:53 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:63091 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZBUE6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 23:58:53 -0500
Date: Fri, 20 Feb 2009 23:58:42 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ACPI: bus.c, fix error handling in acpi_bus_init
In-reply-to: <1234731354-7472-1-git-send-email-jirislaby@gmail.com>
Message-id: <alpine.LFD.2.00.0902202352551.19156@localhost.localdomain>
References: <1234731354-7472-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Feb 2009, Jiri Slaby wrote:

> There was a misplaced status test. Move it to correct place and
> rollback appropriately.

hmm, looks like this has been broken since the day
acpi_os_initialize1() was invented in 2004.

Turns out that the bug and its fix are moot, however,
as acpi_os_initialize1() is hard-coded to return success,
opting for BUG_ON() if it sees a failure...

So unless that changes, I'd prefer to keep the code
simple and just not check its status -- which is effectively
what we're doing right now.

thanks,
-Len

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/acpi/bus.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 765fd1c..79efef6 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -760,18 +760,17 @@ static int __init acpi_bus_init(void)
>  
>  
>  	status = acpi_os_initialize1();
> -
> -	status =
> -	    acpi_enable_subsystem(ACPI_NO_HARDWARE_INIT | ACPI_NO_ACPI_ENABLE);
>  	if (ACPI_FAILURE(status)) {
>  		printk(KERN_ERR PREFIX
> -		       "Unable to start the ACPI Interpreter\n");
> -		goto error1;
> +		       "Unable to initialize ACPI OS objects\n");
> +		goto error0;
>  	}
>  
> +	status =
> +	    acpi_enable_subsystem(ACPI_NO_HARDWARE_INIT | ACPI_NO_ACPI_ENABLE);
>  	if (ACPI_FAILURE(status)) {
>  		printk(KERN_ERR PREFIX
> -		       "Unable to initialize ACPI OS objects\n");
> +		       "Unable to start the ACPI Interpreter\n");
>  		goto error1;
>  	}
>  
> @@ -832,6 +831,7 @@ static int __init acpi_bus_init(void)
>  	/* Mimic structured exception handling */
>        error1:
>  	acpi_terminate();
> +error0:
>  	return -ENODEV;
>  }
>  
> -- 
> 1.6.1.3
> 
