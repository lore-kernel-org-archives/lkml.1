Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZA0Sw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZA0Sw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbZA0SwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:52:20 -0500
Received: from mail.work.de ([212.12.32.20]:45264 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZA0SwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:52:19 -0500
X-Greylist: delayed 680 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 13:52:19 EST
Message-ID: <497F552B.8090201@gmail.com>
Date: Tue, 27 Jan 2009 22:40:43 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: roel.kluin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DVB: negative internal->sub_range won't get noticed
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 00:35:47 +0100 Roel Kluin <roel.kluin@gmail.com>
wrote:

> internal->sub_range is unsigned, a negative won't get noticed.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/media/dvb/frontends/stb0899_algo.c
b/drivers/media/dvb/frontends/stb0899_algo.c
> index 83dc7e1..2ea32da 100644
> --- a/drivers/media/dvb/frontends/stb0899_algo.c
> +++ b/drivers/media/dvb/frontends/stb0899_algo.c
> @@ -464,13 +464,14 @@ static void next_sub_range(struct
stb0899_state *state)
>
>  	if (internal->sub_dir > 0) {
>  		old_sub_range = internal->sub_range;
> -		internal->sub_range = MIN((internal->srch_range / 2) -
> +		if (internal->tuner_offst + internal->sub_range / 2 >=
> +				internal->srch_range / 2)
> +			internal->sub_range = 0;
> +		else
> +			internal->sub_range = MIN((internal->srch_range / 2) -
>  					  (internal->tuner_offst + internal->sub_range / 2),
>  					   internal->sub_range);
>
> -		if (internal->sub_range < 0)
> -			internal->sub_range = 0;
> -
>  		internal->tuner_offst += (old_sub_range + internal->sub_range) / 2;
>  	}

> I hope someone understands that function :(


I guess the relevant people might. Sending it to wrong people and to
a wrong mailing list, doesn't help much i guess.


That function does a step through a "next slice" of the RF carrier
based on a RF center frequency, which is used for carrier acquisition.


> Do we actually need that test at all?  Perhaps it has never
triggered?


Ranges can go negative, from the current offset to the left anything
is negative, to the right it is positive. There of course is a bug
that the variable is not signed.

I have pushed out a fix out here at
http://jusst.de/hg/v4l-dvb/rev/368dc6078295

including your comment on the macros. Thanks for pointing the bug.

Regards,
Manu




