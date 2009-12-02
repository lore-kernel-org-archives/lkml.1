Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZLBVqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZLBVqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZLBVqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:46:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614AbZLBVqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:46:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH] uswsusp: automatically free the in-memory image once s2disk has finished with it
Date: Wed, 2 Dec 2009 22:47:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, Pavel Machek <pavel@ucw.cz>
References: <4B1575AC.6080904@tuffmail.co.uk> <20091202122019.GD1457@csn.ul.ie> <4B16797C.3010304@tuffmail.co.uk>
In-Reply-To: <4B16797C.3010304@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912022247.24705.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 December 2009, Alan Jenkins wrote:
> The original in-kernel suspend (swsusp) frees the in-memory hibernation
> image before powering off the machine.  s2disk doesn't, so there is
> _much_ less free memory when it tries to power off.
> 
> This is a gratuitous difference.  The userspace suspend interface
> /dev/snapshot only allows the hibernation image to be read once.
> Once the s2disk program has read the last page, we can free the entire
> image.
> 
> This avoids a hang after writing the hibernation image which was
> triggered by commit 5f8dcc21211a3d4e3a7a5ca366b469fb88117f61
> "page-allocator: split per-cpu list into one-list-per-migrate-type":
> 
>     [top of trace lost due to screen height]
>     ? shrink_zone
>     ? try_to_free_pages
>     ? isolate_pages_global
>     ? __alloc_pages_nodemask
>     ? kthread
>     ? __get_free_pages
>     ? copy_process
>     ? kthread
>     ? do_fork
>     ...
> 
>     INFO: task s2disk:2036 blocked for more than 120 seconds
>     ...
>     Call Trace:
>     ...
>     ? wait_for_common
>     ? default_wake_function
>     ? kthread_create
>     ? worker_thread
>     ? create_workqueue_thread
>     ? worker_thread
>     ? __create_workqueue_key
>     ? stop_machine_create
>     ? disable_nonboot_cpus
>     ? hibernation_platform_enter
>     ? snapshot_ioctl
>     ...
>     ? sys_ioctl
>     ...
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Thanks for tracking this, great job!

I'm going to push this patch to Linus in the next batch (before 2.6.32 if I
manage to).

Best,
Rafael


> ---
>  kernel/power/user.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index bf0014d..94d0210 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -165,6 +165,10 @@ static ssize_t snapshot_read(struct file *filp, char __user *buf,
>  			res = -EFAULT;
>  		else
>  			*offp = data->handle.offset;
> +	} else {
> +		swsusp_free();
> +		memset(&data->handle, 0, sizeof(struct snapshot_handle));
> +		data->ready = 0;
>  	}
>  
>   Unlock:
> 

