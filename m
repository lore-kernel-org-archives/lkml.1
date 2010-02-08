Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0BHGz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:55:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39904 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0BHGz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:55:26 -0500
Date: Mon, 8 Feb 2010 07:55:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100208065519.GE1290@ucw.cz>
References: <20100129185434.GH19501@one-eyed-alien.net> <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265045354.25750.52.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So, let's put this in the HCD drivers and be done with it.
> 
> The patch below is what fixes the I-D cache incoherency issues on ARM. I
> don't particularly like the solution but it seems to be the only one
> available.

Really? It looks like arm should just flush the caches when mapping
executable page to the userspace.... you can't expect all the drivers
to be modified like that...

Plus it does unneccessary flushes on x86, etc...

> @@ -904,6 +906,14 @@ __acquires(priv->lock)
>  			status = 0;
>  	}
>  
> +	if (usb_pipein(urb->pipe) && usb_pipetype(urb->pipe) == PIPE_BULK) {
> +		void *ptr;
> +		for (ptr = urb->transfer_buffer;
> +		     ptr < urb->transfer_buffer + urb->transfer_buffer_length;
> +		     ptr += PAGE_SIZE)
> +			flush_dcache_page(virt_to_page(ptr));
> +	}
> +
>  	/* complete() can reenter this HCD */
>  	usb_hcd_unlink_urb_from_ep(priv_to_hcd(priv), urb);
>  	spin_unlock(&priv->lock);
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
