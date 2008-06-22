Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYFVRez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYFVRez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYFVRep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:34:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:64521 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbYFVRep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nopg9/TqyZz70TI/Q+peZpHUbc4FQ2x5qVE8XrEC7ZC1sAAmOg0ZG/EIWODohkY7nq
         h2ITIrABoNIILxqDZwSXY8CwqP705n1R66LF5r4EDeX4WOgGIJOII7nl+VaE/Vn8pPk9
         DpalmRPliraFdu2uTY5qa3JAH2pQvWk2af19U=
Date: Sun, 22 Jun 2008 19:33:37 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Fix open/close race in saa7134
Message-ID: <20080622172826.GA7487@joi>
References: <20080622100507.779acc59@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622100507.779acc59@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 10:05:07AM -0700, Arjan van de Ven wrote:
> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 22 Jun 2008 10:03:02 -0700
> Subject: [PATCH] Fix open/close race in saa7134
> 
> The saa7134 driver uses a (non-atomic) variable in an attempt to
> only allow one opener of the device (how it deals with sending
> the fd over unix sockets I don't know).
> 
> Unfortunately, the release function first decrements this variable,
> and THEN goes on to disable more of the device. This allows for
> a race where another opener of the device comes in after the decrement of
> the variable, configures the hardware just to then see the hardware
> be disabled by the rest of the release function.

Simplier fix:
http://lkml.org/lkml/2008/6/9/308
But I don't remember whether it was applied or not...

> 
> This patch makes the release function use the same lock as the open
> function to protect the hardware as well as the variable (which now
> at least has some locking to protect it).
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  drivers/media/video/saa7134/saa7134-empress.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
> index 81431ee..9108843 100644
> --- a/drivers/media/video/saa7134/saa7134-empress.c
> +++ b/drivers/media/video/saa7134/saa7134-empress.c
> @@ -110,6 +110,8 @@ static int ts_release(struct inode *inode, struct file *file)
>  {
>  	struct saa7134_dev *dev = file->private_data;
>  
> +	mutex_lock(&dev->empress_tsq.vb_lock);
> +
>  	videobuf_stop(&dev->empress_tsq);
>  	videobuf_mmap_free(&dev->empress_tsq);
>  	dev->empress_users--;
> @@ -121,6 +123,8 @@ static int ts_release(struct inode *inode, struct file *file)
>  	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
>  		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
>  
> +	mutex_unlock(&dev->empress_tsq.vb_lock);
> +
>  	return 0;
>  }
>  
> -- 
> 1.5.5.1

PS: I can't access 2.6.25 oopses anymore (timeout). Can you fix it?
http://kerneloops.org/version.php?start=1671168&end=1703935&version=25-release&count=4509

Marcin

