Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXDJB5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXDJB5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030309AbXDJB5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:57:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40093 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030302AbXDJB5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:57:09 -0400
Date: Mon, 9 Apr 2007 18:57:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: wally@theblackmoor.net
Cc: linux-kernel@vger.kernel.org, "Jung-Ik  Lee" <jilee@google.com>,
       linux-acpi@vger.kernel.org
Subject: Re: PROBLEM:  ACPI Thermal Zone for CPU0 does not update after   
 hibernation
Message-Id: <20070409185702.bbea2cb9.akpm@linux-foundation.org>
In-Reply-To: <33389.192.168.0.107.1176169658.squirrel@panacea.theblackmoor.net>
References: <11584.192.146.101.26.1175890435.squirrel@panacea.theblackmoor.net>
	<20070409174700.2e0a14d8.akpm@linux-foundation.org>
	<33389.192.168.0.107.1176169658.squirrel@panacea.theblackmoor.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 21:47:38 -0400 (EDT) "Walter Francis" <wally@theblackmoor.net> wrote:

> > On Fri, 6 Apr 2007 16:13:55 -0400 (EDT)
> > "Walter Francis" <wally@theblackmoor.net> wrote:
> 
> >> After hibernating, the CPU0 thermal zone never updates.  It will stay at 59C
> >> forever for example.
> 
> > Yeah, John spotted a bug in there the other day.
> >
> > Does this fix it?
> >
> > --- a/drivers/acpi/thermal.c~acpi-thermal-fix-mod_timer-interval
> > +++ a/drivers/acpi/thermal.c
> > @@ -758,7 +758,8 @@ static void acpi_thermal_check(void *dat
> >  			del_timer(&(tz->timer));
> >  	} else {
> >  		if (timer_pending(&(tz->timer)))
> > -			mod_timer(&(tz->timer), (HZ * sleep_time) / 1000);
> > +			mod_timer(&(tz->timer),
> > +					jiffies + (HZ * sleep_time) / 1000);
> >  		else {
> >  			tz->timer.data = (unsigned long)tz;
> >  			tz->timer.function = acpi_thermal_run;
> 
> No joy, didn't help.
>
> Didn't apply clean to 21-pre6 (still latest I see on kernel.org), but here's
> the section that seemed right.
> 
>         /*
>          * Schedule Next Poll
>          * ------------------
>          */
>         if (!sleep_time) {
>                 if (timer_pending(&(tz->timer)))
>                         del_timer(&(tz->timer));
>         } else {
>                 if (timer_pending(&(tz->timer)))
>                         mod_timer(&(tz->timer),jiffies + (HZ * sleep_time) /
> 1000);
>                 else {
>                         tz->timer.data = (unsigned long)tz;
>                         tz->timer.function = acpi_thermal_run;
>                         tz->timer.expires = jiffies + (HZ * sleep_time) / 1000;
>                         add_timer(&(tz->timer));

Yes, the above looks like the correct change.

> Also, I think this is new with the line replaced..  Not sure exactly what's
> causing it, but when I restart the cpuspeed daemon:
> 
> Starting cpuspeed: Error: Not an integer:
> /proc/acpi/thermal_zone/TZS1/temperature

Strange.  Maybe a timing thing.

> # cat /proc/acpi/thermal_zone/TZS1/temperature
> temperature:             41 C
> 
> Looks normal to me?

Yes it does.  What happens of you stop and restart the daemon a second
time?

fwiw, /proc/acpi/thermal_zone/ATF0/temperature seems to do the right thing
here.

