Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604Ab0AFJLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0AFJLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656Ab0AFJLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:11:34 -0500
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4346 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0AFJLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:11:33 -0500
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2010 04:11:32 EST
Message-ID: <4B44514F.7080307@yahoo.es>
Date: Wed, 06 Jan 2010 17:01:03 +0800
From: Hein_Tibosch <hein_tibosch@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ben Nizette <bn@niasdigital.com>, Pierre Ossman <pierre@ossman.eu>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2] mmc: lower init clock frequency to 300kHz
References: <2A48D9AC-90D7-405F-A64C-0703F5FEC175@niasdigital.com> <20100106070141.GC1382@ucw.cz>
In-Reply-To: <20100106070141.GC1382@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6-1-2010 15:01, Pavel Machek wrote:
> Machine with minimum clock of 1MHz is clearly broken, yet you issue
> "soft" warning.
>
> What about:
>
>      if (f_min > 400k)
>      	print existing warning
>      else if (f_min > 300k)
>         print warning 'if your card does not work, its broken,  but
> 	      	           	your host is unhelpful'
>      clock = f_min
>      if (clock < 3o0)
>      	 clock = 300
>
> ?
>   
Later in this thread I mentioned that initialization at 300 Khz is
too fast for some platforms/cards (avr32 AP7000/main-stream cards).
They will report CRC-errors so the above won't work.

I have looked at the time it will take to exchange the initial data (about
85 bytes), using different busses and frequencies:
	
        Intface:  8-bits  4-bits  SPI
Bus-freq:
400000 (Hz)       0.213   0.425    1.700 (ms)
300000            0.283   0.567    2.267
200000            0.425   0.850    3.400
100000            0.850   1.700    6.800
50000             1.700   3.400   13.600
100               850     1700    6800

These are netto times, without the msleep's for power-up and without
overhead.

Looking at this table, I would use a fixed bottom of 100 Khz:

	if (f_min > 400k)
		print existing warning
	clock = max (100k, host->f_min);

Regards, Hein







