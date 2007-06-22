Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXFVVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXFVVlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXFVVlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:41:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59086 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbXFVVlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:41:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RC][PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Date: Fri, 22 Jun 2007 23:47:55 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200706221647.50509.rjw@sisk.pl> <20070622210750.GA4267@ucw.cz>
In-Reply-To: <20070622210750.GA4267@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706222347.55717.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 June 2007 23:07, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > At present, if a user mode helper is running while usermodehelper_pm_callback()
> > is executed, the helper may be frozen and the completion in
> > call_usermodehelper_exec() won't be completed until user space processes are
> > thawed.  As a result, the freezing of kernel threads may fail, which is not
> > desirable.
> > 
> > Prevent this from happening by introducing a counter of running user mode
> > helpers and allowing usermodehelper_pm_callback() to succeed for
> > action = PM_HIBERNATION_PREPARE or action = PM_SUSPEND_PREPARE only if there
> > are no helpers running.  [Namely, usermodehelper_pm_callback() waits for at most
> > RUNNING_HELPERS_TIMEOUT for the number of running helpers to become zero and
> > fails if that doesn't happen.]
> > 
> > Special thanks to Uli Luckas <u.luckas@road.de> for reviewing the previous
> > versions of this patch and for very useful comments.
> ...
> > Reviewed-by: Pavel Machek <pavel@ucw.cz>
> 
> Eh, not sure this header is worth anything. Sometimes I'm lazy and
> stop when I see first problem.
> 
> >  	switch (action) {
> >  	case PM_HIBERNATION_PREPARE:
> >  	case PM_SUSPEND_PREPARE:
> >  		usermodehelper_disabled = 1;
> > -		return NOTIFY_OK;
> > +		retval = wait_event_timeout(running_helpers_waitq,
> > +					atomic_read(&running_helpers) == 0,
> 
> Are you sure here? What happens when atomic variable changes between
> the atomic_read and the function call?

Er, this is a macro. :-)

In fact we rely only on atomic_read(&running_helpers) being still zero after
helper_finished() has woken us up, but I think that's acceptable.

IOW, if the wait_event_timeout() returns with retval different from zero, this
means that atomic_read(&running_helpers) returned zero at one point after
we'd set usermodehelper_disabled, which is enough.  OTOH, if it doesn't
return with retval different from zero, this means that either one or more
helpers are waited for to finish or they are coming and going very quickly,
which would be suspicious enough to cancel the suspend, IMHO.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
