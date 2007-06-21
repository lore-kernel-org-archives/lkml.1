Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbXFUNa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbXFUNa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXFUNau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:30:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41161 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753899AbXFUNat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:30:49 -0400
Date: Thu, 21 Jun 2007 15:30:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks
Message-ID: <20070621133015.GG18392@elf.ucw.cz>
References: <200706182329.58917.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706182329.58917.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
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
>

> -		return NOTIFY_OK;
> +		wait_event_timeout(running_helpers_waitq,
> +					atomic_read(&running_helpers) == 0,
> +					RUNNING_HELPERS_TIMEOUT);
> +		if (atomic_read(&running_helpers) == 0) {

Uff, this is suspect. What happens if running_helpers goes to 1 here.?

> +			return NOTIFY_OK;


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
