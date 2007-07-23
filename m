Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbXGWAPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbXGWAPP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761148AbXGWAPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:15:00 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:48670 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760057AbXGWAO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:14:59 -0400
Date: Mon, 23 Jul 2007 09:14:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@snapgear.com>, Russell King <rmk@arm.linux.org.uk>,
       Tim Bird <tim.bird@am.sony.com>, bryan.wu@analog.com
Subject: Re: early_printk accessing __log_buf
Message-ID: <20070723001434.GB16374@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>,
	Russell King <rmk@arm.linux.org.uk>,
	Tim Bird <tim.bird@am.sony.com>, bryan.wu@analog.com
References: <200707181756.44074.rgetz@blackfin.uclinux.org> <200707181939.46910.rgetz@blackfin.uclinux.org> <20070718172603.231351ea.akpm@linux-foundation.org> <200707182358.24984.rgetz@blackfin.uclinux.org> <8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 07:50:47PM -0400, Mike Frysinger wrote:
> On 7/18/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> >On Wed 18 Jul 2007 20:26, Andrew Morton pondered:
> >> Robin Getz wrote:
> >> > [need to access _log_buf from external for early debugging code]
> >> >
> >> > Something simple like - early_copy_log_buff(void *dest, size_t n)
> >> >
> >> > copies n bytes from log_buf to memory area dest. Returns number of
> >> > bytes that could not be copied. Can find out how many bytes are in
> >> > the log_buff by calling with zero size.
> >>
> >> When I was at $EARLIER_EMPLOYER, we had code in there to copy the last
> >> kilobyte-odd of the log buffer into flash when the box oopsed.
> >>
> >
> >Hmm - I think that if you call with NULL dest, and have it advance the
> >pointer, you could do the same thing with something like:
> >
> > /* see how many bytes are in the buff */
> > length = early_copy_log_buff(NULL, NULL);
> > /* advance the pointer, so we only copy the last 1k */
> > if (length >= 1024 )
> >    left = early_copy_log_buff(NULL, length - 1024);
> > /* copy to temp buffer, to save to flash */
> > early_copy_log_buff(buff, 1024);
> > save_buff_to_flash(buff);
> >
> >That way - you can put this in the standard places for failure, and still 
> >have
> >only one function polluting printk.c (Although if you want to use it for
> >failure trapping - it's up for "normal" run time use, and doesn't go into
> >__init.
> >
> >> Probably there are others, but they'll mainly be in the consumer/embedded
> >>  area, and those sorts of engineers don't read this mailing list much.
> >
> >Adding a few more 'embedded' folks - who might have some thoughts/opinions.
> 
> i think the attached two functions account for what Robin and Andrew
> were thinking ...

I don't have any strong opinions on this one way or the other. We've been
playing more with kexec for a recovery mode, that coupled with the crash
dumps gives us most of the state we need. We would probably make use of
this printk log access functionality if it were added, though, depending
on customer environments.
