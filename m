Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZCDO7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZCDO7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbZCDO71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:59:27 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:27277 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbZCDO70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:59:26 -0500
Message-id: <49AE9741.9030109@acm.org>
Date: Wed, 04 Mar 2009 08:59:13 -0600
From: Corey Minyard <minyard@acm.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-version: 1.0
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       openipmi-developer@lists.sourceforge.net, kernalert.de@gmail.com,
       djwong@us.ibm.com, Adrian Bunk <bunk@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, cminyard@mvista.com,
       kbaidarov@ru.mvista.com, crquan@gmail.com
Subject: Re: [PATCH] ipmi: reduce stack size of msghandler
References: <49AE7274.2080206@suse.de>
In-reply-to: <49AE7274.2080206@suse.de>
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
>
> Reduce stack memory footprint in ipmi_msghandler
> for send_panic_events. (From 992 bytes on i386
> down to below 100)
>   
I'm not sure this is a good idea.  This only occurs in a panic
situation, so it may be best to not dynamically allocate memory.

However, 992 bytes is a big chunk of data to swallow on the stack, even
on a panic.  What may be best here is to use static data for this
operation, then use an atomic to control access to the static data.  I
believe an atomic is better than a lock because it avoids problems with
possible re-entrancy with another panic on the same CPU.

Thanks,

-corey

> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/char/ipmi/ipmi_msghandler.c |   39 ++++++++++++++++++++++++------------
>  1 file changed, 27 insertions(+), 12 deletions(-)
>
> --- a/drivers/char/ipmi/ipmi_msghandler.c
> +++ b/drivers/char/ipmi/ipmi_msghandler.c
> @@ -4001,8 +4001,20 @@ static void send_panic_events(char *str)
>  	unsigned char                     data[16];
>  	struct ipmi_system_interface_addr *si;
>  	struct ipmi_addr                  addr;
> -	struct ipmi_smi_msg               smi_msg;
> -	struct ipmi_recv_msg              recv_msg;
> +	struct ipmi_smi_msg               *smi_msg;
> +	struct ipmi_recv_msg              *recv_msg;
> +
> +	smi_msg = kmalloc(sizeof(*smi_msg), GFP_KERNEL);
> +	recv_msg = kmalloc(sizeof(*recv_msg), GFP_KERNEL);
> +
> +	if (!smi_msg || !recv_msg) {
> +		printk(KERN_ERR PFX "Could not allocate memory\n");
> +		if (smi_msg)
> +			kfree(smi_msg);
> +		else if (recv_msg)
> +			kfree(recv_msg);
> +		return;
> +	}
>  
>  	si = (struct ipmi_system_interface_addr *) &addr;
>  	si->addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
> @@ -4030,8 +4042,8 @@ static void send_panic_events(char *str)
>  		data[7] = str[2];
>  	}
>  
> -	smi_msg.done = dummy_smi_done_handler;
> -	recv_msg.done = dummy_recv_done_handler;
> +	smi_msg->done = dummy_smi_done_handler;
> +	recv_msg->done = dummy_recv_done_handler;
>  
>  	/* For every registered interface, send the event. */
>  	list_for_each_entry_rcu(intf, &ipmi_interfaces, link) {
> @@ -4048,8 +4060,8 @@ static void send_panic_events(char *str)
>  			       0,
>  			       &msg,
>  			       intf,
> -			       &smi_msg,
> -			       &recv_msg,
> +			       smi_msg,
> +			       recv_msg,
>  			       0,
>  			       intf->channels[0].address,
>  			       intf->channels[0].lun,
> @@ -4107,8 +4119,8 @@ static void send_panic_events(char *str)
>  			       0,
>  			       &msg,
>  			       intf,
> -			       &smi_msg,
> -			       &recv_msg,
> +			       smi_msg,
> +			       recv_msg,
>  			       0,
>  			       intf->channels[0].address,
>  			       intf->channels[0].lun,
> @@ -4127,8 +4139,8 @@ static void send_panic_events(char *str)
>  				       0,
>  				       &msg,
>  				       intf,
> -				       &smi_msg,
> -				       &recv_msg,
> +				       smi_msg,
> +				       recv_msg,
>  				       0,
>  				       intf->channels[0].address,
>  				       intf->channels[0].lun,
> @@ -4195,8 +4207,8 @@ static void send_panic_events(char *str)
>  				       0,
>  				       &msg,
>  				       intf,
> -				       &smi_msg,
> -				       &recv_msg,
> +				       smi_msg,
> +				       recv_msg,
>  				       0,
>  				       intf->channels[0].address,
>  				       intf->channels[0].lun,
> @@ -4204,6 +4216,9 @@ static void send_panic_events(char *str)
>  		}
>  	}
>  #endif /* CONFIG_IPMI_PANIC_STRING */
> +
> +	kfree(smi_msg);
> +	kfree(recv_msg);
>  }
>  #endif /* CONFIG_IPMI_PANIC_EVENT */
>  
>
>   

