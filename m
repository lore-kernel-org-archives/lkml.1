Return-Path: <linux-kernel-owner+w=401wt.eu-S1758663AbZCYJ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbZCYJ1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZCYJ1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:27:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57109 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZCYJ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:27:32 -0400
Message-ID: <49C9F965.3090003@redhat.com>
Date: Wed, 25 Mar 2009 10:29:09 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090303 Fedora/3.0-1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: stoyboyker@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/13] [hwmon] changed ioctls to unlocked
References: <1237929168-15341-12-git-send-email-stoyboyker@gmail.com>
In-Reply-To: <1237929168-15341-12-git-send-email-stoyboyker@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2 Notes:

On 03/24/2009 10:12 PM, stoyboyker@gmail.com wrote:
> From: Stoyan Gaydarov<stoyboyker@gmail.com>
>
> Signed-off-by: Stoyan Gaydarov<stoyboyker@gmail.com>
> ---
>   drivers/hwmon/fschmd.c |   15 +++++++++++----
>   1 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
> index d07f4ef..79efb7b 100644
> --- a/drivers/hwmon/fschmd.c
> +++ b/drivers/hwmon/fschmd.c
> @@ -40,6 +40,7 @@
>   #include<linux/hwmon-sysfs.h>
>   #include<linux/err.h>
>   #include<linux/mutex.h>
> +#include<linux/smp_lock.h>
>   #include<linux/sysfs.h>
>   #include<linux/dmi.h>
>   #include<linux/fs.h>
> @@ -769,15 +770,17 @@ static ssize_t watchdog_write(struct file *filp, const char __user *buf,
>   	return count;
>   }
>
> -static int watchdog_ioctl(struct inode *inode, struct file *filp,
> -	unsigned int cmd, unsigned long arg)
> +static long watchdog_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   {
>   	static struct watchdog_info ident = {
>   		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
>   				WDIOF_CARDRESET,
>   		.identity = "FSC watchdog"
>   	};
> -	int i, ret = 0;
> +
> +	lock_kernel();
> +
> +	int i, ret;
>   	struct fschmd_data *data = filp->private_data;
>
>   	switch (cmd) {
> @@ -837,6 +840,10 @@ static int watchdog_ioctl(struct inode *inode, struct file *filp,
>   		ret = -ENOTTY;
>   	}
>
> +	if(!ret)
> +		ret = -ENOTTY;
> +
> +	unlock_kernel();
>   	return ret;
>   }
>

1) Why on earth do you add that check a return value of 0 here means success, now the ioctl
no longer returns success ever ????

This does not inspire trust for your other 12 patches (which I did not check). Also please do
not ever, *never* hide bug-fixes like this one in other patches. If you believe you've found
a bug while working on something else, send the something else and the bugfix as 2 separate
patches! Otherwise little (potentially wrong) changes like these might slip under the radar
of the reviewer.

> @@ -846,7 +853,7 @@ static struct file_operations watchdog_fops = {
>   	.open = watchdog_open,
>   	.release = watchdog_release,
>   	.write = watchdog_write,
> -	.ioctl = watchdog_ioctl,
> +	.unlocked_ioctl = watchdog_ioctl,
>   };
>
>

2) I'm not completely familiar with char device locking semantics, but the
    watchdog_ioctl function is safe for being called multiple times simultaneous
    already (including being called together with other functions like write).
    So assuming the char device core kernel code is smart enough to not call
    watchdog_release while other operations such as ioctl are still being
    executed, then this above chunk is all that is needed. I guess this is my
    bad and I should have used unlocked_ioctl to begin with.

Regards,

Hans
