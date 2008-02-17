Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYBQRL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYBQRL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYBQRKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:10:43 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:4216 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbYBQRKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:10:41 -0500
Date: Sun, 17 Feb 2008 12:07:08 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 14/27] hwmon: fix section mismatch in coretemp
Message-ID: <20080217170708.GB2916@jupiter.solarsys.private>
References: <20080217121255.GA10519@uranus.ravnborg.org> <1203250984-11285-14-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203250984-11285-14-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam:

* Sam Ravnborg <sam@ravnborg.org> [2008-02-17 13:22:51 +0100]:
> Fix following warning:
> WARNING: vmlinux.o(.text+0xebfd04): Section mismatch in reference from the function coretemp_cpu_callback() to the function .cpuinit.text:coretemp_device_add()
> 
> coretemp_cpu_callback() are only used inside a
> HOTPLUG_CPU block so annotate it __cpuinit.
> The notifier referencing the function are annotated
> __refdata to silence warning from the exit function.
> The unregister function do not use the embedded pointer
> but clears the variable so the annotation is OK.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Mark M. Hoffman <mhoffman@lightlink.com>
> ---
>  drivers/hwmon/coretemp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index 3ee60d2..1439432 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -330,7 +330,7 @@ static void coretemp_device_remove(unsigned int cpu)
>  	mutex_unlock(&pdev_list_mutex);
>  }
>  
> -static int coretemp_cpu_callback(struct notifier_block *nfb,
> +static int __cpuinit coretemp_cpu_callback(struct notifier_block *nfb,
>  				 unsigned long action, void *hcpu)
>  {
>  	unsigned int cpu = (unsigned long) hcpu;
> @@ -347,7 +347,7 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
>  	return NOTIFY_OK;
>  }
>  
> -static struct notifier_block coretemp_cpu_notifier = {
> +static struct notifier_block coretemp_cpu_notifier __refdata = {
>  	.notifier_call = coretemp_cpu_callback,
>  };
>  #endif				/* !CONFIG_HOTPLUG_CPU */
> -- 
> 1.5.4.rc3.14.g44397

This rings a bell... hmmm, commit 59a35bafb223bbb0553ba1a3bb9280bda668a8d8.
AFAICT the warning is a false positive, but whatever.

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

