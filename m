Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYIMLVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYIMLVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 07:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYIMLVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 07:21:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1553 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753399AbYIMLVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 07:21:09 -0400
Date: Sat, 13 Sep 2008 13:20:51 +0200
From: Pavel Machek <pavel@suse.cz>
To: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] Document use of RTC in pm_trace
Message-ID: <20080913112051.GA6827@ucw.cz>
References: <200809101658.06935.elendil@planet.nl> <200809101856.24997.elendil@planet.nl> <alpine.LFD.1.10.0809101001360.3384@nehalem.linux-foundation.org> <200809102007.09670.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809102007.09670.elendil@planet.nl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-09-10 20:07:08, Frans Pop wrote:
> On Wednesday 10 September 2008, Linus Torvalds wrote:
> > On Wed, 10 Sep 2008, Frans Pop wrote:
> > > But I would not expect the RTC to get changed when the resume is
> > > successful. Or does it just get updated with every resume step
> > > without a reset to the pre-trace value on completion?
> >
> > Indeed. We don't know where the bug happens when tracing, so each
> > trace-point just writes its hash value into it. And nothing restores
> > it, since nothing knows that the resume is "done" (a lot of problems
> > happen due to X interactions much later than the 'core' resume thing).
> 
> Right. How about this patch then?
> 
> ---
> From: Frans Pop <elendil@planet.nl>
> 
> As pm_trace uses the system's hardware clock to save its magic
> value, users of that option should be warned that using this debug
> option will result in an incorrect system time after resume.
>     
> Signed-off-by: Frans Pop <elendil@planet.nl>

ACK.

> diff --git a/Documentation/power/s2ram.txt b/Documentation/power/s2ram.txt
> index b05f512..2ebdc60 100644
> --- a/Documentation/power/s2ram.txt
> +++ b/Documentation/power/s2ram.txt
> @@ -54,3 +54,21 @@ used to run with "radeonfb" (it's an ATI Radeon mobility). It turns out
>  that "radeonfb" simply cannot resume that device - it tries to set the
>  PLL's, and it just _hangs_. Using the regular VGA console and letting X
>  resume it instead works fine.
> +
> +NOTE
> +====
> +pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
> +Reason for this is that the RTC is the only reliably available piece of
> +hardware during resume operations where a value can be set that will
> +survive a reboot.
> +
> +Consequence is that after a resume (even if it is successful) your system
> +clock will have a value corresponding to the magic mumber instead of the
> +correct date/time! It is therefore advisable to use a program like ntp-date
> +or rdate to reset the correct date/time from an external time source when
> +using this trace option.
> +
> +As the clock keeps ticking it is also essential that the reboot is done
> +quickly after the resume failure. The trace option does not use the seconds
> +or the low order bits of the minutes of the RTC, but a too long delay will
> +corrupt the magic value.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
