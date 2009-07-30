Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbZG3O0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbZG3O0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbZG3O0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:26:17 -0400
Received: from ru.mvista.com ([213.79.90.228]:31806 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751167AbZG3O0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:26:17 -0400
Date: Thu, 30 Jul 2009 18:26:16 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH] ds2760: fix integer overflow for time_to_empty_now
Message-ID: <20090730142616.GA797@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1248441573-32712-1-git-send-email-daniel@caiaq.de>
 <20090730140041.GA25759@oksana.dev.rtsoft.ru>
 <20090730141259.GV19257@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090730141259.GV19257@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 04:12:59PM +0200, Daniel Mack wrote:
> On Thu, Jul 30, 2009 at 06:00:41PM +0400, Anton Vorontsov wrote:
> > On Fri, Jul 24, 2009 at 03:19:33PM +0200, Daniel Mack wrote:
> > > On the device we're currently developing, battery sizes of ~2.8Ah and
> > > current flow of ~600mA are typical.
> > > 
> > > With that values, the life_sec computation overflows due to the
> > > multiplication by 3600.
> > > 
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> > > Cc: Matt Reimer <mreimer@vpop.net>
> > > Cc: Anton Vorontsov <cbou@mail.ru>
> > > 
> > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > ---
> > >  drivers/power/ds2760_battery.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
> > > index d545fee..5d30dc0 100644
> > > --- a/drivers/power/ds2760_battery.c
> > > +++ b/drivers/power/ds2760_battery.c
> > > @@ -212,8 +212,8 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
> > >  		di->rem_capacity = 100;
> > >  
> > >  	if (di->current_uA)
> > > -		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) *
> > > -				 3600L) / di->current_uA;
> > > +		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) * 36L)
> > > +					/ (di->current_uA / 100L);
> > 
> > Hm... "(di->current_uA / 100L)" might result to 0, so you'll get
> > div by zero. Removing the parenthesis will help.
> 
> Hmm, no, then it gets the precedence wrong.

Ah.

> But checking for values >=
> 100 of current_uA helps. Thanks for spotting this.

Yeah, that'll be fine indeed.

> Daniel
> 
> 
> >From c60e23e2ba6667bec882338bfe3cb12304ee1ab6 Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Fri, 24 Jul 2009 15:08:11 +0200
> Subject: [PATCH] ds2760: fix integer overflow for time_to_empty_now
> 
> On the device we're currently developing, battery sizes of ~2.8Ah and
> current flow of ~600mA are typical.
> 
> With that values, the life_sec computation overflows due to the
> multiplication by 3600.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> Cc: Matt Reimer <mreimer@vpop.net>
> Cc: Anton Vorontsov <cbou@mail.ru>
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> ---
>  drivers/power/ds2760_battery.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
> index d545fee..2ef29dd 100644
> --- a/drivers/power/ds2760_battery.c
> +++ b/drivers/power/ds2760_battery.c
> @@ -211,9 +211,9 @@ static int ds2760_battery_read_status(struct ds2760_device_info *di)
>  	if (di->rem_capacity > 100)
>  		di->rem_capacity = 100;
>  
> -	if (di->current_uA)
> -		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) *
> -				 3600L) / di->current_uA;
> +	if (di->current_uA >= 100L)
> +		di->life_sec = -((di->accum_current_uAh - di->empty_uAh) * 36L)
> +					/ (di->current_uA / 100L);
>  	else
>  		di->life_sec = 0;
>  
> -- 
> 1.6.3.3
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
