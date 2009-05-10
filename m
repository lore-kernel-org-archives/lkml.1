Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZEJOXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZEJOXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 10:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZEJOXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 10:23:05 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:33396 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbZEJOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 10:23:04 -0400
Message-ID: <4A06E344.4060901@rsk.demon.co.uk>
Date: Sun, 10 May 2009 15:23:00 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Chris Peterson <cpeterso@cpeterso.com>
CC: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use round_jiffies() for slow work thread pool's 5 second
   cull timer
References: <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop>
In-Reply-To: <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Peterson wrote:
> The slow work thread pool culls its idle threads after 5 seconds without any work requests. Also, the slow work thread pool waits 5 seconds before starting new threads after OOM.
> 
> This patch uses round_jiffies() to round these 5 second timers to whole seconds. In this case, the actual timer wait would be between 4.75 and 5.75 seconds (because round_jiffies() rounds < 0.25 seconds down and > 0.25 seconds up). This patch also refactors the mod_timer() logic into a separate helper function.
> 
> Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
> ---
> diff --git a/kernel/slow-work.c b/kernel/slow-work.c
> index b28d191..9bfcb53 100644
> --- a/kernel/slow-work.c
> +++ b/kernel/slow-work.c
> @@ -318,6 +318,12 @@ cant_get_ref:
>  }
>  EXPORT_SYMBOL(slow_work_enqueue);
>  
> +static void slow_work_defer_cull_time(void)
> +{
> +	mod_timer(&slow_work_cull_timer,
> +			  round_jiffies_relative(SLOW_WORK_CULL_TIMEOUT));
> +}
> +
Hi Chris,

Doesn't mod_timer take an absolute time not a relative one?

So I think this should be

	mod_timer(&timer,round_jiffies(jiffies + TIMEOUT) );

regards

Richard

