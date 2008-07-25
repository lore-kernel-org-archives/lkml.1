Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYGYWRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYGYWRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYGYWRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:17:10 -0400
Received: from trinity.fluff.org ([89.145.97.151]:50914 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYGYWRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:17:09 -0400
Date: Fri, 25 Jul 2008 23:17:03 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Dooks <ben-linux@fluff.org>, David Miller <davem@davemloft.net>,
       bzolnier@gmail.com, harvey.harrison@gmail.com, linux-ide@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: recent IDE regression
Message-ID: <20080725221703.GS26938@trinity.fluff.org>
References: <20080724.233831.193691312.davem@davemloft.net> <20080725083448.GE8301@fluff.org.uk> <alpine.LFD.1.10.0807250930190.5249@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807250930190.5249@nehalem.linux-foundation.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 09:37:25AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 25 Jul 2008, Ben Dooks wrote:
> > 
> > personally, i would much prefer to see the loop being less evil
> > like:
> > 
> > 	for (p = s; p < end; p += 2)
> > 		be16_to_cpus((u16 *)p);
> 
> Well, in this case, the code actually depends on 'p' being back at the 
> start of the buffer by the end of it all, so it would need some more 
> changes than that. 

I'm not adverse to the loop running backwards, it is just that we end
up evaluating macro with side-effects to the pointer itself, which is
"just asking for trouble". 

		for (p = end ; p != s; p -= 2)
			be16_to_cpus((u16 *)p);

This removes the side-effect of be16_to_cpus(), which means that the
change to p is moved back into the for statement; After all, the for
construct has three code blocks for a reason!

I just wonder what would happen if be16_to_cpus(x) evaluated 'x' more
than once... it would be difficult to find problems introduced if this
happened as it would fail to hang, just not do the 'right' thing... 

> But yes, I applied David's patch, but I _also_ suspect that we would be 
> better off without code that does horrid things like casts and assignments 
> inside the function arguments.
> 
> So it would be nice to re-code that loop to be more readable. But due to 
> the reliance of 'p' being 's' after the loop, the minimal patch would be 
> something like the appended.

As noted above, I don't have any problems with the looping going backwards,
just the problems with potential side-effects.
 
> Bartlomiej - take this or not, I'm not going to commit it - I haven't 
> tested it, nor do I even have any machines that would trigger it. So this 
> is more a "maybe something like this" than anything else.
> 
> 		Linus
> 
> ---
>  drivers/ide/ide-iops.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
> index 8aae917..ae03151 100644
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -506,14 +506,16 @@ void ide_fix_driveid (struct hd_driveid *id)
>  
>  void ide_fixstring (u8 *s, const int bytecount, const int byteswap)
>  {
> -	u8 *p = s, *end = &s[bytecount & ~1]; /* bytecount must be even */
> +	u8 *p, *end = &s[bytecount & ~1]; /* bytecount must be even */
>  
>  	if (byteswap) {
>  		/* convert from big-endian to host byte order */
> -		for (p = end ; p != s;)
> -			be16_to_cpus((u16 *)(p -= 2));
> +		for (p = s ; p != end ; p += 2)
> +			be16_to_cpus((u16 *) p);
>  	}
> +
>  	/* strip leading blanks */
> +	p = s;
>  	while (s != end && *s == ' ')
>  		++s;
>  	/* compress internal blanks and strip trailing blanks */

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

