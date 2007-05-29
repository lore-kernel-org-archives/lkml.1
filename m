Return-Path: <linux-kernel-owner+w=401wt.eu-S1761814AbXE2Tgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761814AbXE2Tgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 15:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbXE2Tgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 15:36:40 -0400
Received: from waste.org ([66.93.16.53]:46637 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbXE2Tgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 15:36:39 -0400
Date: Tue, 29 May 2007 14:35:08 -0500
From: Matt Mackall <mpm@selenic.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Theodore Tso <tytso@mit.edu>, M Macnair <mmacnair@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529193508.GX11115@waste.org>
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <20070529131501.GA9899@thunk.org> <20070529174614.GG11166@waste.org> <465C7DB3.104@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <465C7DB3.104@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 09:23:31PM +0200, Eric Dumazet wrote:
> Matt Mackall a écrit :
> >On Tue, May 29, 2007 at 09:15:01AM -0400, Theodore Tso wrote:
> >>Another thing which I noticed is that when Matt Mackall took over
> >>maintainership of /dev/random, he apparently took out one of the
> >>safeguards I had, which was that before, when entropy was extracted
> >>from the pool the time stamp when it was extracted was mixed back into
> >>the pool.  The theory was that an external attacker might not know
> >>when a program might be calling /dev/random, so mixing in the time of
> >>that entropy was extracted wouldn't hurt, and might help.  I'll submit
> >>a patch to add that support back in, which will help you a little.
> >
> >It's still there, and in the same place, it just looks different:
> >
> >static void add_timer_randomness(struct timer_rand_state *state,
> >unsigned num)
> >{
> >...
> >        sample.jiffies = jiffies;
> >        sample.cycles = get_cycles();
> >        sample.num = num;
> >        add_entropy_words(&input_pool, (u32 *)&sample,
> >	sizeof(sample)/4);
> >
> >Trouble is the write(2) interface calls add_entropy_words directly, as
> >does the pool initialization function.
> >
> >We might as well mix jiffies and cycles in at init time in a manner
> >similar to the above. Something like this (untested):
> >
> >Index: l/drivers/char/random.c
> >===================================================================
> >--- l.orig/drivers/char/random.c	2007-05-29 12:45:00.000000000 -0500
> >+++ l/drivers/char/random.c	2007-05-29 12:44:02.000000000 -0500
> >@@ -559,6 +559,26 @@ static struct timer_rand_state input_tim
> > static struct timer_rand_state *irq_timer_state[NR_IRQS];
> > 
> > /*
> >+ * Mix a sample of the current time into the pool with no entropy
> >+ * accounting
> >+ */
> >+static long __add_timer_randomness(void)
> >+{
> >+	struct {
> >+		cycles_t cycles;
> >+		long jiffies;
> >+		unsigned num;
> >+	} sample;
> >+
> >+	sample.jiffies = jiffies;
> >+	sample.cycles = get_cycles();
> >+	sample.num = num;
> >+	add_entropy_words(&input_pool, (u32 *)&sample, sizeof(sample)/4);
> 
> Well, you need to pass 'num' argument I guess.

Yep, fixed version already posted.
 
> But... How is this supposed to work on 64 bits arches ?
> 
> Because of alignment, 'struct sample' will include a 4 bytes filler after 
> 'unsigned num', and sizeof(sample) will include this (null) filler in 
> entropy pool.

Doesn't matter, just churns the pool a bit more. It gets XORed over
existing data (aka NOP) and doesn't get counted as extra entropy or
anything.

-- 
Mathematics is the supreme nostalgia of our time.
