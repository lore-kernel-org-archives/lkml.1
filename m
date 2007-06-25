Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbXFYO7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbXFYO7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXFYO6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:58:55 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55943 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbXFYO6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:58:54 -0400
Date: Mon, 25 Jun 2007 07:58:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Uli Luckas <u.luckas@road.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Message-ID: <20070625145851.GB12976@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070625104332.GA147@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625104332.GA147@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 02:43:32PM +0400, Oleg Nesterov wrote:
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
> 
> Second, call_usermodehelper's path should first increment the counter, and only
> then check usermodehelper_disabled, and it needs an mb() in between too. Otherwise,
> the helper can see usermodehelper_disabled == 0, then PM_SUSPEND_PREPARE comes and
> returns NOTIFY_OK, then the helper increments the counter and starts application.
> 
> Sadly, you can't use srcu/qrcu because it doesn't handle timeouts.	

Interesting...  So the thought is to have a synchronize_srcu_timeout()
or something similar that waited for a grace period to elapse or for
a timeout to expire, whichever comes first?  It should not be too hard
to arrange something, if needed.

						Thanx, Paul
