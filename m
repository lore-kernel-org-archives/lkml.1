Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZC0Lh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZC0Lh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZC0LhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:37:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47274 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZC0LhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:37:07 -0400
Date: Fri, 27 Mar 2009 12:40:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: TOMOYO in linux-next
Message-ID: <20090327114001.GD2585@elf.ucw.cz>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <200903270412.n2R4CG7o054009@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903270412.n2R4CG7o054009@www262.sakura.ne.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > This is quite nasty. I don't think turning off enforcement in
> > interrupt is good idea. ("fails open").
> This is not "fails open". TOMOYO deals only operations which are allowed to
> sleep (e.g. opening files, making directories). This in_interrupt() check is
> for safety in case somebody who are not allowed to sleep called TOMOYO's
> function by error.

If it never happens, why not fail closed?

> > I'm not sure basing security on pids is good idea...
> PID is used for reaching a domain which that PID is in, not for access control
> decisions.

Can I get some documentation about domains etc? How will it interact
with containers?

> > Hmm, barrier is spelled otherwise, and I'm not sure I'd trust this:
> > 
> > +struct tomoyo_path_info_with_data {
> > +       /* Keep "head" first, for this pointer is passed to tomoyo_free(). */
> > +       struct tomoyo_path_info head;
> > +       char bariier1[16]; /* Safeguard for overrun. */
> > 
> > I guess constants should be used here:
> Oh, typo, thanks.
> I think there is no need to use #define here, for nobody accesses
> barrier1/barrier2.

I do believe that those barriers should be deleted. You should just
avoid buffer overruns; there's no reason 16 bytes should be enough to
protect you.

> > +#ifdef TOMOYO_DEBUG_DOMAIN_UNDELETE
> > +                       if (domain2->is_deleted != 255)
> > +                               printk(KERN_DEBUG
> > +                                      "Marked %p as non undeletable\n",
> > +                                      domain2);
> > +#endif
> > +                       domain2->is_deleted = 255;
> > 
> > (I don't know why we want undelete in tomoyo.)
> This "undelete domain" feature was introduced to allow administrators switch
> domain policy periodically.

255 needs a constant at the very least.

> > If it contains copyright, it should contain copyright. It probably
> > should not contain version numbers.
> TOMOYO's management tools want /sys/kernel/security/tomoyo/version .

So fix them. It is better than carrying "version" forever. 

> > Can we get an interface that does not need as many strings/ as much
> > string parsing?
> A plain text interface splitted by ' ' and '\n' is cleaner than introducing
> binary interface. (TOMOYO uses \040 for ' ' and \012 for '\n'. No worry for
> ' ' and '\n' in pathnames.)

\0 terminated strings?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
