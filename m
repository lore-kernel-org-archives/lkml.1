Return-Path: <linux-kernel-owner+w=401wt.eu-S966767AbZLHWZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966767AbZLHWZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966760AbZLHWZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:25:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:18866 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966750AbZLHWZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:25:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EJxo7TIessNsjK1W57V5QJa7yY05Ns+ZSegYQLGJ59qAoFm84qL1vUsVX+ZLLQh84K
         SmZlNeSsnYOxDn57j0FaGIeEIcDRCmtbpBnk8aMc8XHvKhbMaQHMwVAqmNRwhyizPVcx
         fj6ahx6kwOrfJMPLs5ag79yuy5amv+eUxkSos=
Message-ID: <4B1ED241.4090803@gmail.com>
Date: Tue, 08 Dec 2009 23:25:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-9.1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com,
       achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com
Subject: Re: + hpsa-use-msleep-instead-of-schedule_timeout.patch added to
 -mm tree
References: <200912082204.nB8M48oL027313@imap1.linux-foundation.org>
In-Reply-To: <200912082204.nB8M48oL027313@imap1.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2009 11:04 PM, akpm@linux-foundation.org wrote:
> Subject: hpsa: use msleep() instead of schedule_timeout
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Use msleep() instead of schedule_timeout

The patch does more than that and moreover in a wrong manner, see below.

> @@ -3262,8 +3262,8 @@ static int hpsa_pci_init(struct ctlr_inf
>  		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
>  			break;
>  		/* delay and try again */
> -		set_current_state(TASK_INTERRUPTIBLE);
> -		schedule_timeout(10);
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		msleep(10);

Why do you change interruptible sleep to uninterruptible? And you
intermix jiffies with msecs. Use schedule_timeout_interruptible(10).

> @@ -3302,7 +3302,8 @@ static int __devinit hpsa_init_one(struc
>  
>  		/* Some devices (notably the HP Smart Array 5i Controller)
>  		   need a little pause here */
> -		schedule_timeout_uninterruptible(HPSA_POST_RESET_PAUSE);
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		msleep(HPSA_POST_RESET_PAUSE_MSECS);

Hmm, setting the state is superfluous, as msleep does the job itself.

> diff -puN drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout drivers/scsi/hpsa.h
> --- a/drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout
> +++ a/drivers/scsi/hpsa.h
...
> @@ -139,7 +139,7 @@ struct ctlr_info {
>  #define HPSA_BOARD_READY_ITERATIONS \
>  	((HPSA_BOARD_READY_WAIT_SECS * 1000) / \
>  		HPSA_BOARD_READY_POLL_INTERVAL_MSECS)
> -#define HPSA_POST_RESET_PAUSE (30 * HZ)
> +#define HPSA_POST_RESET_PAUSE_MSECS (3000)

Ehm?

-- 
js
