Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZAMAhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZAMAhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZAMAhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:37:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46804 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZAMAhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:37:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/2] resume: wait for device probing to finish
Date: Tue, 13 Jan 2009 01:36:58 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, Len Brown <lenb@kernel.org>
References: <20090109211346.3ccc36e3@infradead.org> <20090109211457.6b1d37ed@infradead.org>
In-Reply-To: <20090109211457.6b1d37ed@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901130136.59293.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009, Arjan van de Ven wrote:
> (this patch needs testing on a few different machines; compile tested only)
> 
> 
> From 10b3e25671c817933e232498a56640fd48964345 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 9 Jan 2009 21:11:23 -0800
> Subject: [PATCH] resume: wait for device probing to finish
> 
> the resume code does not currently wait for device probing to finish.
> Even without async function calls this is dicey and not correct,
> but with async function calls during the boot sequence this is going
> to get hit more...
> 
> This patch adds the synchronization using the newly introduced helper.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Sorry for the delay, but I only could do the testing today.

It appears that 2.6.29-rc1 with the two patches in this series applied resumes
from hibernation correctly.

Please push the second one to Len with my ack.

Thanks,
Rafael


> ---
>  kernel/power/disk.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/disk.c b/kernel/power/disk.c
> index 45e8541..d2d24b7 100644
> --- a/kernel/power/disk.c
> +++ b/kernel/power/disk.c
> @@ -585,6 +585,12 @@ static int software_resume(void)
>  	unsigned int flags;
>  
>  	/*
> +	 * If the user said "noresume".. bail out early.
> +	 */
> +	if (noresume)
> +		return 0;
> +
> +	/*
>  	 * name_to_dev_t() below takes a sysfs buffer mutex when sysfs
>  	 * is configured into the kernel. Since the regular hibernate
>  	 * trigger path is via sysfs which takes a buffer mutex before
> @@ -600,6 +606,11 @@ static int software_resume(void)
>  			mutex_unlock(&pm_mutex);
>  			return -ENOENT;
>  		}
> +		/*
> +		 * Some device discovery might still be in progress; we need
> +		 * to wait for this to finish.
> +		 */
> +		wait_for_device_probe();
>  		swsusp_resume_device = name_to_dev_t(resume_file);
>  		pr_debug("PM: Resume from partition %s\n", resume_file);
>  	} else {
> -- 
> 1.6.0.6
