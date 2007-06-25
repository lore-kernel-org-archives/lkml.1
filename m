Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXFYO47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXFYO47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXFYO4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:56:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbXFYO4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:56:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Date: Mon, 25 Jun 2007 17:03:42 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pavel Machek <pavel@ucw.cz>, Uli Luckas <u.luckas@road.de>,
       linux-kernel@vger.kernel.org
References: <20070625104332.GA147@tv-sign.ru>
In-Reply-To: <20070625104332.GA147@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706251703.42979.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 June 2007 12:43, Oleg Nesterov wrote:
> Rafael J. Wysocki wrote:
> >
> >  static int usermodehelper_pm_callback(struct notifier_block *nfb,
> >  					unsigned long action,
> >  					void *ignored)
> >  {
> > +	long retval;
> > +
> >  	switch (action) {
> >  	case PM_HIBERNATION_PREPARE:
> >  	case PM_SUSPEND_PREPARE:
> >  		usermodehelper_disabled = 1;
> > -		return NOTIFY_OK;
> > +		/*
> > +		 * From now on call_usermodehelper_exec() won't start any new
> > +		 * helpers, so it is sufficient if running_helpers turns out to
> > +		 * be zero at one point (it may be increased later, but that
> > +		 * doesn't matter).
> > +		 */
> > +		retval = wait_event_timeout(running_helpers_waitq,
> > +					atomic_read(&running_helpers) == 0,
> > +					RUNNING_HELPERS_TIMEOUT);
> > +		if (retval) {
> > +			return NOTIFY_OK;
> > +		} else {
> > +			usermodehelper_disabled = 0;
> > +			return NOTIFY_BAD;
> 
> I think this is racy. First, this needs smp_mb() between "usermodehelper_disabled = 1"
> and wait_event_timeout().

Yes ...

> Second, call_usermodehelper's path should first increment the counter, and only
> then check usermodehelper_disabled,

It does this already.

> and it needs an mb() in between too. Otherwise, the helper can see
> usermodehelper_disabled == 0, then PM_SUSPEND_PREPARE comes and 
> returns NOTIFY_OK, then the helper increments the counter and starts application.
> 
> Sadly, you can't use srcu/qrcu because it doesn't handle timeouts.	

OK

If I understand that correctly, it should suffice to place smp_mb() after
usermodehelper_disabled = 1; in usermodehelper_pm_callback() and another
smp_mb() after atomic_inc(&running_helpers); in new_helper().

Is that correct?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
