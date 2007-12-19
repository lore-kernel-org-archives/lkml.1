Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbXLSABi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbXLSABi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXLSABa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:01:30 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:28026 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbXLSABa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:01:30 -0500
Date: Tue, 18 Dec 2007 18:01:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC/PATCH] 2.6.24-rcx: Make sys_poll() wait at least timeout ms
In-reply-to: <fa.QbT8/KZb1MTA5+n7SD6kFi6mqso@ifi.uio.no>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <47685F4B.8000207@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QbT8/KZb1MTA5+n7SD6kFi6mqso@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Wiese wrote:
> Hi,
> 
> while playing with jackd on 2.6.24-rcx, I found poll() timing out too early.
> That is: earlier than its timeout argument specified.
> Setting poll()'s timeout argument to "required timeout" + "1 jiffy in ms"
> fixed it. Patch below should fix it too. Correct?
> Untested.
> Otherwise 2.6.24-rc5 ticks just fine here, thanks.
> 
>       Karsten
>  
> ------------->
> Make sys_poll() wait at least timeout ms
> 
> schedule_timeout(jiffies) waits for at least jiffies - 1.
> Add 1 jiffie to the timeout_jiffies calculated in sys_poll() to wait at least
> timeout_msecs, like poll() manpage says.
> 
> Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
> ---
>  fs/select.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index 47f4792..5633fe9 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -739,7 +739,7 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
>  			timeout_jiffies = -1;
>  		else
>  #endif
> -			timeout_jiffies = msecs_to_jiffies(timeout_msecs);
> +			timeout_jiffies = msecs_to_jiffies(timeout_msecs) + 1;
>  	} else {
>  		/* Infinite (< 0) or no (0) timeout */
>  		timeout_jiffies = timeout_msecs;

That seems fishy. What is your value of HZ and what is the timeout value 
that was passed in the bad case?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

