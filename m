Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbZEaQp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbZEaQp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 12:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbZEaQpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 12:45:20 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:65170 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607AbZEaQpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 12:45:19 -0400
Date: Mon, 01 Jun 2009 01:45:17 +0900 (JST)
Message-Id: <20090601.014517.169682203.anemo@mba.ocn.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       mpm@selenic.com
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090529162907.9cb1bba2.akpm@linux-foundation.org>
References: <1243350141-883-1-git-send-email-anemo@mba.ocn.ne.jp>
	<20090529162907.9cb1bba2.akpm@linux-foundation.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 16:29:07 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> I assume that the MIPS patch "[PATCH] TXx9: Add TX4939 RNG support"
> depends upon this patch?

To build kernel or driver, no dependencies.  To use this device
actually, both patches are needed.

> > +static u64 read_rng(void __iomem *base, unsigned int offset)
> > +{
> > +	/* Caller must disable interrupts */
> > +	return ____raw_readq(base + offset);
> > +}
> 
> What is the reasoning behind the local_irq_disable() requirement?
> 
> Because I'm wondering whether this is safe on SMP?

As Ralf replied, These local_irq_disable stuff are just for 64-bit
access on 32-bit kernel.  Maybe something like this is preferred?

static void ____raw_io_start(void)
{
#ifndef CONFIG_64BIT
	/* some comments... */
	local_irq_enable();
#endif
}

static void ____raw_io_end(void)
{
#ifndef CONFIG_64BIT
	/* see above */
	local_irq_disable();
#endif
}

For SMP concurrent access, these rountines are protected by mutex in
rng-core.  Also this SoC does not support SMP.  There should be no
problem here.

> > +	for (i = 0; i < 20; i++) {
...
> > +		udelay(1);
> > +	}
> > +	return rngdev->data_avail;
> > +}
> 
> The mysterious udelay() needs a comment, because there is no way in
> which the reader can otherwise work out why it is there.

Well, this comments can be applied most RNG drivers ;)

Anyway, I will add some comment here.  I take this loop (20 loops with
udelay) from other drivers and changed to udelay(1) because the
datasheed states "90 bus clock cycles by default" for generation
(typically 450ns for this SoC).

> > +static int tx4939_rng_data_read(struct hwrng *rng, u32 *buffer)
> > +{
> > +	struct tx4939_rng *rngdev = container_of(rng, struct tx4939_rng, rng);
> > +
> > +	rngdev->data_avail--;
> > +	*buffer = *((u32 *)&rngdev->databuf + rngdev->data_avail);
> > +	return sizeof(u32);
> > +}
> 
> Concurrent callers can corrupt rngdev->data_avail ?

This is protected by rng_mutex in rng-core.

> > +	/* Start RNG */
> > +	write_rng(TX4939_RNG_RCSR_ST, rngdev->base, TX4939_RNG_RCSR);
> > +	local_irq_enable();
> > +	/* drop first two results */
> 
> The comment doesn't provide the reason for doing this?

>From the datasheet:

	The quality of the random numbers generated immediately after
	reset can be insufficient.  Therefore, do not use random
	numbers obtained from the first and second generations; use
	the ones from the third or subsequent generation.

I will put this comment in the driver.

---
Atsushi Nemoto
