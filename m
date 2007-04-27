Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbXD0OPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbXD0OPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXD0OPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:15:45 -0400
Received: from cnc.isely.net ([64.81.146.143]:51739 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866AbXD0OGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:06:13 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2007 10:06:13 EDT
Date: Fri, 27 Apr 2007 08:55:50 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
cc: video4linux-list@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH 4/5] pvrusb2: use mutex instead of semaphore
In-Reply-To: <20070427085027.GF4213@traven>
Message-ID: <Pine.LNX.4.64.0704270854500.16942@cnc.isely.net>
References: <20070427083857.GB4213@traven> <20070427085027.GF4213@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Whoops.  A straggler.

Signed-off-by: Mike Isely <isely@pobox.com>

On Fri, 27 Apr 2007, Matthias Kaehlcke wrote:

> the pvrusb2 driver use a semaphore as mutex. use the mutex API instead
> of the (binary) semaphore
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
> --
> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> index 9916cf3..ea450b0 100644
> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
> @@ -83,7 +83,7 @@ static struct pvr2_string_table pvr2_client_lists[] = {
>  };
>  
>  static struct pvr2_hdw *unit_pointers[PVR_NUM] = {[ 0 ... PVR_NUM-1 ] = NULL};
> -static DECLARE_MUTEX(pvr2_unit_sem);
> +static DEFINE_MUTEX(pvr2_unit_mtx);
>  
>  static int ctlchg = 0;
>  static int initusbreset = 1;
> @@ -2069,14 +2069,14 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
>  	hdw->ctl_read_urb = usb_alloc_urb(0,GFP_KERNEL);
>  	if (!hdw->ctl_read_urb) goto fail;
>  
> -	down(&pvr2_unit_sem); do {
> +	mutex_lock(&pvr2_unit_mtx); do {
>  		for (idx = 0; idx < PVR_NUM; idx++) {
>  			if (unit_pointers[idx]) continue;
>  			hdw->unit_number = idx;
>  			unit_pointers[idx] = hdw;
>  			break;
>  		}
> -	} while (0); up(&pvr2_unit_sem);
> +	} while (0); mutex_unlock(&pvr2_unit_mtx);
>  
>  	cnt1 = 0;
>  	cnt2 = scnprintf(hdw->name+cnt1,sizeof(hdw->name)-cnt1,"pvrusb2");
> @@ -2174,13 +2174,13 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
>  	}
>  	pvr2_i2c_core_done(hdw);
>  	pvr2_hdw_remove_usb_stuff(hdw);
> -	down(&pvr2_unit_sem); do {
> +	mutex_lock(&pvr2_unit_mtx); do {
>  		if ((hdw->unit_number >= 0) &&
>  		    (hdw->unit_number < PVR_NUM) &&
>  		    (unit_pointers[hdw->unit_number] == hdw)) {
>  			unit_pointers[hdw->unit_number] = NULL;
>  		}
> -	} while (0); up(&pvr2_unit_sem);
> +	} while (0); mutex_unlock(&pvr2_unit_mtx);
>  	kfree(hdw->controls);
>  	kfree(hdw->mpeg_ctrl_info);
>  	kfree(hdw->std_defs);
> 
> 

-- 
                        |         Mike Isely          |     PGP fingerprint
     Spammers Die!!     |                             | 03 54 43 4D 75 E5 CC 92
                        |   isely @ pobox (dot) com   | 71 16 01 E2 B5 F5 C1 E8
                        |                             |
