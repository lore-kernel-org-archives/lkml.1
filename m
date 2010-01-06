Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202Ab0AFHDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0AFHDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 02:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367Ab0AFHDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 02:03:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab0AFHDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 02:03:15 -0500
Date: Wed, 6 Jan 2010 08:01:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ben Nizette <bn@niasdigital.com>
Cc: Pierre Ossman <pierre@ossman.eu>, Adrian Hunter <adrian.hunter@nokia.com>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matt Fleming <matt@console-pimps.org>,
       Hein_Tibosch <hein_tibosch@yahoo.es>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2] mmc: lower init clock frequency to 300kHz
Message-ID: <20100106070141.GC1382@ucw.cz>
References: <2A48D9AC-90D7-405F-A64C-0703F5FEC175@niasdigital.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2A48D9AC-90D7-405F-A64C-0703F5FEC175@niasdigital.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-01-02 10:11:10, Ben Nizette wrote:
> 
> A good few months ago, commit
> 
> commit 8dfd0374be84793360db7fff2e635d2cd3bbcb21
> Author: Sascha Hauer <s.hauer@pengutronix.de>
> Date:   Thu Apr 9 08:32:02 2009 +0200
> 
>     MMC core: limit minimum initialization frequency to 400kHz
> 
> broke a few setups with cards which don't quite adhere to the MMC spec - 400kHz is just too fast for them.  In my testing, all of the cards which fail at 400kHz are OK by about 350Khz but this patch drops the floor to 300 to be on the safe side.
> 
> Dropping the floor also means that the warning will trigger on some valid setups, albeit ones which won't run particularly crappy cards.  This patch then slightly softens the language of said warning to make it clear it isn't always a problem.
> 
> V1 of this patch dropped the floor all the way to 50kHz on the basis that it was only for a few 100 bytes so that very low speed shouldn't matter.  After some discussion [1] the consensus was that 50 was too slow after all so this patch is a bit more sensible.
> 

(please wrap).

> @@ -891,12 +891,12 @@ static void mmc_power_up(struct mmc_host *host)
>  	 */
>  	mmc_delay(10);
>  
> -	if (host->f_min > 400000) {
> -		pr_warning("%s: Minimum clock frequency too high for "
> +	if (host->f_min > 300000) {
> +		pr_warning("%s: Minimum clock frequency may be too high for "
>  				"identification mode\n", mmc_hostname(host));
>  		host->ios.clock = host->f_min;
>  	} else
> -		host->ios.clock = 400000;
> +		host->ios.clock = 300000;
>  
>  	host->ios.power_mode = MMC_POWER_ON;
>  	mmc_set_ios(host);

Machine with minimum clock of 1MHz is clearly broken, yet you issue
"soft" warning.

What about:

     if (f_min > 400k)
     	print existing warning
     else if (f_min > 300k)
        print warning 'if your card does not work, its broken,  but
	      	           	your host is unhelpful'
     clock = f_min
     if (clock < 3o0)
     	 clock = 300

?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
