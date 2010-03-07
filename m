Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0CGMNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 07:13:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab0CGMNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 07:13:05 -0500
Date: Sun, 7 Mar 2010 14:08:13 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Xin Xiaohui <xiaohui.xin@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] vhost - cleanup
Message-ID: <20100307120813.GB20121@redhat.com>
References: <20100304211014.GA7882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304211014.GA7882@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 04:10:14PM -0500, Jeff Dike wrote:
> commit 1191aa42193d030470dbd4ab17e4fb57772534ff
> Author: Jeff Dike <jdike@localhost.localdomain>
> Date:   Thu Mar 4 14:51:20 2010 -0500
> 
>     Delete a label and goto from vhost_net_set_backend
>     
>     Inverting a test allows a label and goto to be eliminated.
>     
>     Signed-off-by: Jeff Dike <jdike@linux.intel.com>


Thanks!
I am in fixes-only mode for 2.6.34, will queue this for the next release.

> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 4ada4b4..7abb883 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -518,13 +518,12 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>  
>  	/* start polling new socket */
>  	oldsock = vq->private_data;
> -	if (sock == oldsock)
> -		goto done;
> +	if (sock != oldsock){
> +                vhost_net_disable_vq(n, vq);
> +                rcu_assign_pointer(vq->private_data, sock);
> +                vhost_net_enable_vq(n, vq);
> +	}
>  
> -	vhost_net_disable_vq(n, vq);
> -	rcu_assign_pointer(vq->private_data, sock);
> -	vhost_net_enable_vq(n, vq);
> -done:
>  	if (oldsock) {
>  		vhost_net_flush_vq(n, index);
>  		fput(oldsock->file);
