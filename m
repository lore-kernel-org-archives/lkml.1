Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751511AbYLRTbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbYLRTbs (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLRTbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:31:36 -0500
Received: from p02c12o148.mxlogic.net ([208.65.145.81]:52350 "EHLO
	p02c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYLRTbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:31:35 -0500
Message-ID: <494AA4DB.5000807@steeleye.com>
Date: Thu, 18 Dec 2008 14:30:35 -0500
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: nbd: fix locking in case of error
References: <20081218183310.GA21260@elf.ucw.cz>
In-Reply-To: <20081218183310.GA21260@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Dec 2008 19:30:35.0709 (UTC) FILETIME=[199D6ED0:01C96147]
X-Spam: [F=0.2000000000; S=0.200(2008120801)]
X-MAIL-FROM: <paul.clements@steeleye.com>
X-SOURCE-IP: [71.30.118.242]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> This cleans up error handling some more, and prevents return with lock
> held from nbd_handle_req when nbd_send_req() fails. It also switches

>  static struct request *nbd_find_request(struct nbd_device *lo,
> @@ -467,10 +467,9 @@ static void nbd_handle_req(struct nbd_de
>  
>  	mutex_lock(&lo->tx_lock);
>  	if (unlikely(!lo->sock)) {
> -		mutex_unlock(&lo->tx_lock);
>  		printk(KERN_ERR "%s: Attempted send on closed socket\n",
>  		       lo->disk->disk_name);
> -		goto error_out;
> +		goto error_out_unlock;
>  	}
>  
>  	lo->active_req = req;
> @@ -478,7 +477,7 @@ static void nbd_handle_req(struct nbd_de
>  	if (nbd_send_req(lo, req) != 0) {
>  		printk(KERN_ERR "%s: Request send failed\n",
>  				lo->disk->disk_name);
> -		goto error_out;
> +		goto error_out_unlock;
>  	} else {
>  		spin_lock(&lo->queue_lock);
>  		list_add(&req->queuelist, &lo->queue_head);
> @@ -491,6 +490,8 @@ static void nbd_handle_req(struct nbd_de
>  
>  	return;
>  
> +error_out_unlock:
> +	mutex_unlock(&lo->tx_lock);
>  error_out:
>  	req->errors++;
>  	nbd_end_request(req);

Not sure I see the problem. tx_lock is unlocked in every return path 
AFAICS. You introduced the tx_lock problem with the previous patch, 
where the second error_out was not correct.

--
Paul
