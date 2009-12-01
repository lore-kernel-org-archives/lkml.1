Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZLAQBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZLAQBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZLAQBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:01:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45042 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbZLAQBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:01:51 -0500
Date: Tue, 1 Dec 2009 17:01:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: divide by zero in termios when setting bluetooth
Message-ID: <20091201160151.GD2262@elf.ucw.cz>
References: <20091201151315.GC2262@elf.ucw.cz>
 <20091201155244.0523d9c9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201155244.0523d9c9@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I triggered this by mistake... "W" taint is from the  WARN_ON()
> > before.
> 
> This ought to fix it
> 
> serial: Fix crash if the minimum rate of the device is > 9600 baud
> 
> From: Alan Cox <alan@linux.intel.com>
> 
> In that situation if the old rate is invalid and the new rate is invalid
> and the chip cannot do 9600 baud we report zero, which makes all the
> drivers explode.
> 
> Instead force the rate based on min/max
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

>  		}
>  
>  		/*
> -		 * As a last resort, if the quotient is zero,
> -		 * default to 9600 bps
> +		 * As a last resort, if the range cannot be met then clip to
> +		 * the nearest chip supported rate.
>  		 */
> -		if (!hung_up)
> -			tty_termios_encode_baud_rate(termios, 9600, 9600);
> +		if (!hung_up) {
> +			if (baud <= min)                
> +				tty_termios_encode_baud_rate(termios,
> +							min + 1, min + 1);
> +			else
> +				tty_termios_encode_baud_rate(termios,
> +							max - 1, max - 1);
> +		}
>  	}
> -
> +	/* Should never happen */
> +	WARN_ON(1);
>  	return 0;

Does this mean WARN_ON() on user error? Maybe printk(KERN_ERR) with
explanation would be better?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
