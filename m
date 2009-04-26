Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZDZWVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZDZWVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 18:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZDZWU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 18:20:57 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4468 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZDZWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 18:20:56 -0400
Subject: Re: [PATCH] Acer Aspire One Fan Control
From: Joe Perches <joe@perches.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <cone.1240648971.372002.7492.1000@mentalhome>
References: <cone.1240623959.159615.9486.1000@mentalhome>
	 <cone.1240648971.372002.7492.1000@mentalhome>
Content-Type: text/plain
Date: Sun, 26 Apr 2009 15:20:54 -0700
Message-Id: <1240784454.22585.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-25 at 10:42 +0200, Peter Feuerer wrote:
> The patch is compiled and tested against current git/torvalds/linux-2.6.git checkout.
> 
> What do you think? Do you have any questions?

Trivial comments:

> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> new file mode 100644
> index 0000000..63dc485
> --- /dev/null
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -0,0 +1,594 @@
> +/*
> + * acerhdf - A kernelmodule which monitors the temperature

kernel module

> + *           of the aspire one netbook, turns on/off the fan
> + *           as soon as the upper/lower threshold is reached.
> + *
> + * (C) 2009 - Peter Feuerer     peter (a) piie.net
> + *                              http://piie.net
> + *
> + *
> + *
> + * Inspired by and many thanks to:
> + *  o acerfand   - Rachel Greenham
> + *  o acer_ec.pl - Michael Kurz     michi.kurz (at) googlemail.com
> + *               - Petr Tomasek     tomasek (#) etf,cuni,cz
> + *               - Carlos Corbacho  cathectic (at) gmail.com
> + *
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + *
> + *  06-February-2009: Version 0.1:
> + *  - first relase, containing absolutely no bugs! ;)
[]
> + *  25-April-2009: Version 0.5:
> + *  - ported to 2.6.30
> + *  - removed kthread and used polling of thermal api

Version information in comments isn't generally useful

> +/* print currend operation mode - kernel / user */

current

> +static int set_mode(struct thermal_zone_device *thermal,
> +		enum thermal_device_mode mode)
> +{
> +	if (mode == THERMAL_DEVICE_DISABLED) {
> +		if (verbose)
> +			printk(KERN_NOTICE "acerhdf: kernelmode OFF\n");
> +		thermal->polling_delay = 0;
> +		thermal_zone_device_update(thermal);
> +		change_fanstate(1);
> +		/* silly hack - let the polling thread disable
> +		 * kernelmode. This ensures, that the polling thread
> +		 * doesn't switch off the fan again */
> +		recently_changed = 1;
> +	} else if (mode == THERMAL_DEVICE_ENABLED) {
> +		if (verbose)
> +			printk(KERN_NOTICE "acerhdf: kernelmode ON\n");
> +		thermal->polling_delay = interval*1000;
> +		thermal_zone_device_update(thermal);
> +		kernelmode = 1;
> +	}
> +	return 0;
> +}

There's no other thermal device_mode state than ENABLED/DISABLED.
Maybe just if/else?

> +/* print the name of the trip point */
> +static int get_trip_type(struct thermal_zone_device *thermal,
> +		int trip, enum thermal_trip_type *type)
> +{
> +	if (trip == 0)
> +		*type = THERMAL_TRIP_ACTIVE;
> +	return 0;
> +}

Comment doesn't match code.  I see no printing here.

> +/* print the temperature at which the trip point gets active */
> +static int get_trip_temp(struct thermal_zone_device *thermal,
> +		int trip, unsigned long *temp)
> +{
> +	if (trip == 0)
> +		*temp = fanon;
> +	return 0;
> +}

No printing here either.

You could #define pr_fmt(fmt) "acerhd: " fmt
instead of prefixing all the printks with "acerhd:"


