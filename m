Return-Path: <linux-kernel-owner+w=401wt.eu-S1763907AbXE2TYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763907AbXE2TYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXE2TYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:24:00 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:42766 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXE2TX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:23:59 -0400
Message-ID: <465C7DB3.104@cosmosbay.com>
Date: Tue, 29 May 2007 21:23:31 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Theodore Tso <tytso@mit.edu>, M Macnair <mmacnair@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <20070529131501.GA9899@thunk.org> <20070529174614.GG11166@waste.org>
In-Reply-To: <20070529174614.GG11166@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 29 May 2007 21:23:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall a écrit :
> On Tue, May 29, 2007 at 09:15:01AM -0400, Theodore Tso wrote:
>> Another thing which I noticed is that when Matt Mackall took over
>> maintainership of /dev/random, he apparently took out one of the
>> safeguards I had, which was that before, when entropy was extracted
>> from the pool the time stamp when it was extracted was mixed back into
>> the pool.  The theory was that an external attacker might not know
>> when a program might be calling /dev/random, so mixing in the time of
>> that entropy was extracted wouldn't hurt, and might help.  I'll submit
>> a patch to add that support back in, which will help you a little.
> 
> It's still there, and in the same place, it just looks different:
> 
> static void add_timer_randomness(struct timer_rand_state *state,
> unsigned num)
> {
> ...
>         sample.jiffies = jiffies;
>         sample.cycles = get_cycles();
>         sample.num = num;
>         add_entropy_words(&input_pool, (u32 *)&sample,
> 	sizeof(sample)/4);
> 
> Trouble is the write(2) interface calls add_entropy_words directly, as
> does the pool initialization function.
> 
> We might as well mix jiffies and cycles in at init time in a manner
> similar to the above. Something like this (untested):
> 
> Index: l/drivers/char/random.c
> ===================================================================
> --- l.orig/drivers/char/random.c	2007-05-29 12:45:00.000000000 -0500
> +++ l/drivers/char/random.c	2007-05-29 12:44:02.000000000 -0500
> @@ -559,6 +559,26 @@ static struct timer_rand_state input_tim
>  static struct timer_rand_state *irq_timer_state[NR_IRQS];
>  
>  /*
> + * Mix a sample of the current time into the pool with no entropy
> + * accounting
> + */
> +static long __add_timer_randomness(void)
> +{
> +	struct {
> +		cycles_t cycles;
> +		long jiffies;
> +		unsigned num;
> +	} sample;
> +
> +	sample.jiffies = jiffies;
> +	sample.cycles = get_cycles();
> +	sample.num = num;
> +	add_entropy_words(&input_pool, (u32 *)&sample, sizeof(sample)/4);

Well, you need to pass 'num' argument I guess.

But... How is this supposed to work on 64 bits arches ?

Because of alignment, 'struct sample' will include a 4 bytes filler after 
'unsigned num', and sizeof(sample) will include this (null) filler in entropy 
pool.

Shouldn't we use __attribute__((packed)) on 'struct sample' definition ?


