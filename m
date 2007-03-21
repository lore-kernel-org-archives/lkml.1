Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbXCUGbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbXCUGbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbXCUGbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:31:47 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50486 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbXCUGbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:31:45 -0400
Date: Tue, 20 Mar 2007 22:31:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Fix SNAPSHOT_S2RAM ioctl
Message-Id: <20070320223109.7158eb9e.akpm@linux-foundation.org>
In-Reply-To: <200703202248.08665.rjw@sisk.pl>
References: <200703202248.08665.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 22:48:08 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The SNAPSHOT_S2RAM ioctl does not disable the nonboot CPUs before entering
> the suspend, although it should do this.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/power/user.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.21-rc4/kernel/power/user.c
> ===================================================================
> --- linux-2.6.21-rc4.orig/kernel/power/user.c
> +++ linux-2.6.21-rc4/kernel/power/user.c
> @@ -374,9 +374,12 @@ static int snapshot_ioctl(struct inode *
>  		if (error) {
>  			printk(KERN_ERR "Failed to suspend some devices.\n");
>  		} else {
> -			/* Enter S3, system is already frozen */
> -			suspend_enter(PM_SUSPEND_MEM);
> -
> +			error = disable_nonboot_cpus();
> +			if (!error) {
> +				/* Enter S3, system is already frozen */
> +				suspend_enter(PM_SUSPEND_MEM);
> +				enable_nonboot_cpus();
> +			}
>  			/* Wake up devices */
>  			device_resume();
>  		}

Do you consider this appropriate to 2.6.21?
