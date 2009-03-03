Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZCCV75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZCCV75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZCCV7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:59:17 -0500
Received: from gw.goop.org ([64.81.55.164]:55341 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbZCCV7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:59:14 -0500
Message-ID: <49ADA82A.6080508@goop.org>
Date: Tue, 03 Mar 2009 13:59:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kris Shannon <kris@shannon.id.au>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix kernel NULL pointer dereference in xen-blkfront
References: <e51f4f550903020047m7f110039v48bcac6a345f1fd6@mail.gmail.com>
In-Reply-To: <e51f4f550903020047m7f110039v48bcac6a345f1fd6@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kris Shannon wrote:
> When booting Xen Dom0 on a pre-release 3.2.1 hypervisor the system Oopses on a
> "Unable to handle kernel NULL pointer dereference" in xenwatch.
>
> From the backtrace it looks like backend_changed is calling bdget_disk
> with a NULL pointer.  Checking for NULL and returning ENODEV instead
> allows the kernel to boot.
>   

Thanks, applied.  (BTW, please cc: me and xen-devel for Xen-related 
reports.)

Jens: could you pull this; I think this is probably -rc material.  This 
crash just started happening, so I guess its a side-effect of some core 
kernel change.

The following changes since commit c7241227f61ca6606a7fa3555391360d92bd8d9b:
  Jens Axboe (1):
        xen/blkfront: use blk_rq_map_sg to generate ring entries

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/frontend/blkfront

Kris Shannon (1):
      Fix kernel NULL pointer dereference in xen-blkfront

 drivers/block/xen-blkfront.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


Thanks,
    J

> ---
>  drivers/block/xen-blkfront.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index f2fff5799ddf0fe1b41909b64d606d..3e2ab6d53adaeb70efa12f0a1f33bb 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -905,6 +905,8 @@ static void backend_changed(struct xenbus_device *dev,
>  		break;
>
>  	case XenbusStateClosing:
> +		if (info->gd == NULL)
> +			xenbus_dev_fatal(dev, -ENODEV, "gd is NULL");
>  		bd = bdget_disk(info->gd, 0);
>  		if (bd == NULL)
>  			xenbus_dev_fatal(dev, -ENODEV, "bdget failed");
>   

