Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXENTZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXENTZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbXENTZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:25:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbXENTZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:25:34 -0400
Date: Mon, 14 May 2007 12:25:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] timekeeping fix mismerge
In-Reply-To: <1179133802.22481.327.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0705141218390.6739@woody.linux-foundation.org>
References: <1179133802.22481.327.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 May 2007, Thomas Gleixner wrote:
>
> The time keeping code move to kernel/time/timekeeping.c broke the
> clocksource resume logic patch. Fix it up and move the
> clocksource_resume() call to the appropriate place.

Yeah, looks obvious enough. It had just enough context in the *wrong* 
place, that the patch would continue to apply if you used the default 
(insane) GNU patch semantics, because GNU patch defaults to --fuzz=2, and 
is thus ok if it can find even just a single line around the patch that is 
valid.

So it looks like Andrew's patch-application scripts happily added the 
"clocksource_resume()" to an insane place, because the one-line context 
was

>  
> +	clocksource_resume();
> +
>  	write_seqlock_irqsave(&xtime_lock, flags);

ie an empty line and a single write_seqlock_irqsave(). And those two lines 
could be found elsewhere in the wrong file.

There's a real reason I consider GNU patch defaults to be totally insane.

I personally use much stricter rules, but what happens is that Andrew's 
scripts will apply the patch to the wrong place, and then the diff gets 
*re-generated*, so by the time I see it, I see a nice diff that applies 
with no fuzz at all.

I don't think re-generating the diff is wrong, and in fact I think you 
have to do it, but I think Andrew should use "--fuzz=0" or at least 
"--fuzz=1" instead of the default 2. Yeah, it obviously causes more patch 
application failures, and it can be very irritating if *most* of those 
patches would have applied cleanly and correctly with --fuzz=2, but 
--fuzz=2 really is very dangerous. It literally just needed two lines to 
match in the wrong place (and as mentioned, those two lines can be 
trivial, like in the example - totally empty, even!)

		Linus
