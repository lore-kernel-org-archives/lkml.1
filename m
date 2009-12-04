Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbZLDQTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbZLDQTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbZLDQTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:19:38 -0500
Received: from poutre.nerim.net ([62.4.16.124]:63580 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104AbZLDQTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:19:37 -0500
Date: Fri, 4 Dec 2009 17:19:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] DMI: allow omitting ident strings in DMI tables
Message-ID: <20091204171941.4554fa41@hyperion.delvare>
In-Reply-To: <20091204073421.GA17012@core.coreip.homeip.net>
References: <20091203031240.GB9121@core.coreip.homeip.net>
	<20091203093009.059197a6@hyperion.delvare>
	<20091203085629.GN9121@core.coreip.homeip.net>
	<20091203102542.6df59efc@hyperion.delvare>
	<20091204073421.GA17012@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> DMI: allow omitting ident strings in DMI tables
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> The purpose of dmi->ident is twofold - it may be used by DMI callback
> functions when composing log messages; it is also used to determine
> end of DMI table in dmi_check_system() and dmi_first_match(). However,
> in case when callbacks are not interested in using ident at all it just
> wastes memory. Let's make enties with empty first match slot serve as
> end-of-table markers instead.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Looks good to me.

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
> 
>  drivers/firmware/dmi_scan.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 938100f..3a2ccb0 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -429,7 +429,7 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
>  	for (i = 0; i < ARRAY_SIZE(dmi->matches); i++) {
>  		int s = dmi->matches[i].slot;
>  		if (s == DMI_NONE)
> -			continue;
> +			break;
>  		if (dmi_ident[s]
>  		    && strstr(dmi_ident[s], dmi->matches[i].substr))
>  			continue;
> @@ -440,6 +440,15 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
>  }
>  
>  /**
> + *	dmi_is_end_of_table - check for end-of-table marker
> + *	@dmi: pointer to the dmi_system_id structure to check
> + */
> +static bool dmi_is_end_of_table(const struct dmi_system_id *dmi)
> +{
> +	return dmi->matches[0].slot == DMI_NONE;
> +}
> +
> +/**
>   *	dmi_check_system - check system DMI data
>   *	@list: array of dmi_system_id structures to match against
>   *		All non-null elements of the list must match
> @@ -457,7 +466,7 @@ int dmi_check_system(const struct dmi_system_id *list)
>  	int count = 0;
>  	const struct dmi_system_id *d;
>  
> -	for (d = list; d->ident; d++)
> +	for (d = list; !dmi_is_end_of_table(d); d++)
>  		if (dmi_matches(d)) {
>  			count++;
>  			if (d->callback && d->callback(d))
> @@ -484,7 +493,7 @@ const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
>  {
>  	const struct dmi_system_id *d;
>  
> -	for (d = list; d->ident; d++)
> +	for (d = list; !dmi_is_end_of_table(d); d++)
>  		if (dmi_matches(d))
>  			return d;
>  


-- 
Jean Delvare
