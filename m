Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZJKWZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZJKWZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZJKWZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:25:51 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:58868 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZJKWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=KVtyDcMz6TrJWN8UeD/cKZvr4R2TPbthCCLJT3MoRh5hr8KAlc1+RkbnZAIcpxxfoN
         R1fz0KCrqhES6t9qDNg76yzZSpSSxlL+gKPSuOGrZLlp8NDnEGOi1r9JVXy4vxK6xDTU
         W2jOCjxox/phyHKLNyNVXnwGWfbrEbFC0G/tk=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] generic_nvram: Turn nvram_ioctl into an unlocked ioctl
Date: Mon, 12 Oct 2009 00:25:05 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, John Kacur <jkacur@redhat.com>,
       "Sven-Thorsten Dietrich" <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200910112131.40608.arnd@arndb.de> <1255299165-8618-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1255299165-8618-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910120025.05208.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Frederic Weisbecker wrote:
> nvram_ioctl is a bkl locked ioctl, but it can be an unlocked ioctl.
> 
> - part is provided by the user
> - offset is provided by pmac_get_partition() which is safe as it only
>   touches nvram_partitions, an array inistialized on __init time and
>   read-only the rest of the time.
> - nvram_sync() only relies on core99_nvram_sync() which checks
>   is_core_99, nvram_data, nvram_image. Those are variables initialized
>   on __init time only and their direct values are not touched further.
>   The rest modifies the nvram image header, protected by nv_lock
>   already.
> 
> So it's safe to call nvram_ioctl without the big kernel lock held.
> 
> Reported-by: Arnd Bergmann <arndbergmann@googlemail.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Alessio Igor Bogani <abogani@texware.it>
> Cc: Arnd Bergmann <arndbergmann@googlemail.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

Hmm, I wish I had not started using the gmail MTA for sending out
mail, not that address is public forever.

>  drivers/char/generic_nvram.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
> index c49200e..fd448aa 100644
> --- a/drivers/char/generic_nvram.c
> +++ b/drivers/char/generic_nvram.c
> @@ -118,11 +118,11 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
>  }
>  
>  const struct file_operations nvram_fops = {
> -	.owner		= THIS_MODULE,
> -	.llseek		= nvram_llseek,
> -	.read		= read_nvram,
> -	.write		= write_nvram,
> -	.ioctl		= nvram_ioctl,
> +	.owner			= THIS_MODULE,
> +	.llseek			= nvram_llseek,
> +	.read			= read_nvram,
> +	.write			= write_nvram,
> +	.unlocked_ioctl		= nvram_ioctl,
>  };
>  
>  static struct miscdevice nvram_dev = {

The ioctl and unlocked_ioctl functions have a different signature, so you
need to adapt that, not just rename it.

Not sure if we should do it in the same patch, but this driver should also 
have a compat_ioctl method pointing to the same function. The ioctl numbers
in this driver are all 32/64 bit clean, but are not listed in fs/compat_ioctl.c,
so adding a .compat_ioctl pointer is the easiest way to fix 32 bit userland
accessing the device.

	Arnd <><
