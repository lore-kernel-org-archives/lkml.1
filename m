Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZDNHhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZDNHhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZDNHgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:36:46 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:51047 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbZDNHgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:36:45 -0400
Date: Tue, 14 Apr 2009 09:38:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
Message-ID: <20090414073850.GA11577@uranus.ravnborg.org>
References: <1239654768.6542.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239654768.6542.10.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian.

I see that most of the point raised in last round has been addressed.
An incremental changelog would be nice during this RFC phase
so we know what has been changed from one version to the next.

> +/*
> + * write out the date in bcd format
> + * in the appropriate part of the 
> + * directory entry
> + */
> +static unsigned long vmufat_save_bcd(char *bh, int z)
> +{
> +	unsigned char day, year, century, nl_day, month;
> +	unsigned char u8year;
> +	unsigned long unix_date = CURRENT_TIME.tv_sec;
> +
> +	day = unix_date / 86400 - 3652;
> +	year = day / 365;
> +
> +	if ((year + 3) / 4 + 365 * year > day)
> +		year--;
> +
> +	day -= (year + 3) / 4 + 365 * year;
> +	if (day == 59 && !(year & 3)) {
> +		nl_day = day;
> +		month = 2;
> +	} else {
> +		nl_day = (year & 3) || day <= 59 ? day : day - 1;
> +		for (month = 0; month < 12; month++)
> +			if (day_n[month] > nl_day)
> +				break;
> +	}
> +
> +	century = 19;
> +	if (year > 19)
> +		century = 20;
> +
> +	bh[z + 0x10] = bin2bcd(century);
> +	u8year = year + 80;
> +	if (u8year > 99)
> +		u8year = u8year - 100;
> +
> +	bh[z + 0x11] = bin2bcd(u8year);
> +	bh[z + 0x12] = bin2bcd(month);
> +	bh[z + 0x13] =
> +	    bin2bcd(day - day_n[month - 1] + 1);
> +	bh[z + 0x14] =
> +	    bin2bcd((unix_date / 3600) % 24);
> +	bh[z + 0x15] = bin2bcd((unix_date / 60) % 60);
> +	bh[z + 0x16] = bin2bcd(unix_date % 60);
> +	return unix_date;
> +}

Can we get all these numbers replaced by a set of descriptive constants?
You can then use the definition of the constants to more-or-less document
the on-disk format.

You have it in several places - the above is just one of them.

I did not look into the rest of the filesystem this time,
I may do so later.

Please ntoe that this part of the excercise is to make the filesystem
ready to be reviewed by someone who knows how to write a filesystem.
What I provide to you is only the janitorial level..

	Sam
