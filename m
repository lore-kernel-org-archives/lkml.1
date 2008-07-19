Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYGSQ7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYGSQ7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 12:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYGSQ7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 12:59:23 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:39399 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753933AbYGSQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 12:59:22 -0400
Message-ID: <48821D7B.1080209@suse.de>
Date: Sat, 19 Jul 2008 20:59:39 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] acpi: Rip out EC_FLAGS_QUERY_PENDING (prevent race
 condition)
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net> <487F3B6D.3090507@suse.de> <20080717162628.GB18457@khazad-dum.debian.net> <487F7724.5080905@tuffmail.co.uk> <20080717185032.GD18457@khazad-dum.debian.net> <487F986A.3070504@tuffmail.co.uk> <4881CE72.1090401@tuffmail.co.uk> <4881D239.4010402@tuffmail.co.uk>
In-Reply-To: <4881D239.4010402@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

I don't think this is very good idea -- now every interrupt will add a new entry to workqueue,
and given the rate of this interrupt, it could be become quite long.

Your second patch is redundant if you add queue entry for each interrupt, and as it does not
require any investments into memory, I like it more.

Also, it is very cool to rip of things you don't care for, but that essentially reverts a fix done for 9998,
so at least, you should ask these people if you broke their setups.

Regards,
Alex.

Alan Jenkins wrote:
> From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> 
> If several GPE interrupts arrive at a time, then perform an equal number of
> queries in the workqueue.  It doesn't matter if there are excess interrupts;
> the queries will just come back with nothing.
> 
> This won't fix anything, because it still switches to polling GPEs if more
> than five interrupts arrive at a time.  But it simplifies the code, and makes
> it easier to modify further without introducing race conditions.
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> 
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index 5622aee..8e4b1a4 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -77,7 +77,6 @@ enum ec_event {
>  
>  enum {
>  	EC_FLAGS_WAIT_GPE = 0,		/* Don't check status until GPE arrives */
> -	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
>  	EC_FLAGS_GPE_MODE,		/* Expect GPE to be sent for status change */
>  	EC_FLAGS_NO_GPE,		/* Don't use GPE mode */
>  	EC_FLAGS_RESCHEDULE_POLL	/* Re-schedule poll */
> @@ -230,8 +229,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
>  			       "finish-write timeout, command = %d\n", command);
>  			goto end;
>  		}
> -	} else if (command == ACPI_EC_COMMAND_QUERY)
> -		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
> +	}
>  
>  	for (; rdata_len > 0; --rdata_len) {
>  		result = acpi_ec_wait(ec, ACPI_EC_EVENT_OBF_1, force_poll);
> @@ -502,7 +508,7 @@ static u32 acpi_ec_gpe_handler(void *data)
>  		wake_up(&ec->wait);
>  
>  	if (state & ACPI_EC_FLAG_SCI) {
> -		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags))
> +		if (ec->handlers_installed)
>  			status = acpi_os_execute(OSL_EC_BURST_HANDLER,
>  				acpi_ec_gpe_query, ec);
>  	} else if (!test_bit(EC_FLAGS_GPE_MODE, &ec->flags) &&
> @@ -665,7 +671,6 @@ static struct acpi_ec *make_acpi_ec(void)
>  	struct acpi_ec *ec = kzalloc(sizeof(struct acpi_ec), GFP_KERNEL);
>  	if (!ec)
>  		return NULL;
> -	ec->flags = 1 << EC_FLAGS_QUERY_PENDING;
>  	mutex_init(&ec->lock);
>  	init_waitqueue_head(&ec->wait);
>  	INIT_LIST_HEAD(&ec->list);
> @@ -858,8 +863,6 @@ static int acpi_ec_start(struct acpi_device *device)
>  
>  	ret = ec_install_handlers(ec);
>  
> -	/* EC is fully operational, allow queries */
> -	clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
>  	ec_schedule_ec_poll(ec);
>  	return ret;
>  }
> 
> 

