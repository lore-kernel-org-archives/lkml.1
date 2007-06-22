Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbXFVVIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbXFVVIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXFVVIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:08:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4565 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbXFVVID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:08:03 -0400
Date: Fri, 22 Jun 2007 21:07:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RC][PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Message-ID: <20070622210750.GA4267@ucw.cz>
References: <200706221647.50509.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706221647.50509.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> At present, if a user mode helper is running while usermodehelper_pm_callback()
> is executed, the helper may be frozen and the completion in
> call_usermodehelper_exec() won't be completed until user space processes are
> thawed.  As a result, the freezing of kernel threads may fail, which is not
> desirable.
> 
> Prevent this from happening by introducing a counter of running user mode
> helpers and allowing usermodehelper_pm_callback() to succeed for
> action = PM_HIBERNATION_PREPARE or action = PM_SUSPEND_PREPARE only if there
> are no helpers running.  [Namely, usermodehelper_pm_callback() waits for at most
> RUNNING_HELPERS_TIMEOUT for the number of running helpers to become zero and
> fails if that doesn't happen.]
> 
> Special thanks to Uli Luckas <u.luckas@road.de> for reviewing the previous
> versions of this patch and for very useful comments.
...
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

Eh, not sure this header is worth anything. Sometimes I'm lazy and
stop when I see first problem.

>  	switch (action) {
>  	case PM_HIBERNATION_PREPARE:
>  	case PM_SUSPEND_PREPARE:
>  		usermodehelper_disabled = 1;
> -		return NOTIFY_OK;
> +		retval = wait_event_timeout(running_helpers_waitq,
> +					atomic_read(&running_helpers) == 0,

Are you sure here? What happens when atomic variable changes between
the atomic_read and the function call?
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
