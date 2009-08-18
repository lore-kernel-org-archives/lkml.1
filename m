Return-Path: <linux-kernel-owner+w=401wt.eu-S1751371AbZHRVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbZHRVou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbZHRVou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:44:50 -0400
Received: from ru.mvista.com ([213.79.90.228]:43956 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750803AbZHRVos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:44:48 -0400
Date: Wed, 19 Aug 2009 01:44:49 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben@fluff.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/6] mtd: m25p80: Convert to device table matching
Message-ID: <20090818214449.GA12848@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
 <20090731004100.GB8371@oksana.dev.rtsoft.ru>
 <200908031954.50955.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200908031954.50955.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for the review, and sorry for the delayed response.

On Mon, Aug 03, 2009 at 07:54:50PM -0700, David Brownell wrote:
> On Thursday 30 July 2009, Anton Vorontsov wrote:
> > This patch converts the m25p80 driver so that now it uses .id_table
> > for device matching, making it properly detect devices on OpenFirmware
> > platforms (prior to this patch the driver misdetected non-JEDEC chips,
> > seeing all chips as "m25p80").
> 
> I suspect "detect" is a misnomer there.  It only "detects" JEDEC chips.

Currently the driver always tries JEDEC probing, and it wrongly "assumed"
that all non-JEDEC chips are m25p80, because an entry for m25p80 chips
had "0" in jedec id field, which isn't correct ID, but 0 is returned by
most non-JEDEC chips. Having 0 in the m25p80 entry was a hack.

> All others got explicit declarations ... so if there's misbehavior for
> other chips, it's because those declarations were poorly handled.  Maybe
> they were not properly flagged as non-JDEC

> > Also, now jedec_probe() only does jedec probing, nothing else. If it
> > is not able to detect a chip, NULL is returned and the driver fall
> > backs to the information specified by the platform (platform_data, or
> > exact ID).
> 
> I'd rather keep the warning, so there's a clue about what's really
> going on:  JEDEC chip found, but its ID is not handled.

We can't tell if the chip was actually found.

M25Px0 chips can be JEDEC and non-JEDEC, e.g. Nymonyx manufacturing
"M25P80" chips in two variants: "The RDID instruction is available only
for parts made with Technology T9HX (0.11μm), ..."

Most (but not all) non-JEDEC EEPROMs will return "0" for RDID opcode
though (in that case warning is misleading). And for the chips that
don't return 0, we shouldn't probe them with jedec at all.

[...]
> > @@ -608,32 +615,38 @@ static int __devinit m25p_probe(struct spi_device *spi)
> >  	 */
> >  	data = spi->dev.platform_data;
> >  	if (data && data->type) {
> 
> At this point I wonder why you're not changing the probe sequence
> more.

Yep, I was going to do it anyway, but for another reason: to support
CAT25 chips.

> There's a new error case of course:  new-style but data->type
> doesn't match id->name.
[...]
> > +		if (i == ARRAY_SIZE(m25p_ids) - 1) {
> 
> Better:  "if (info == NULL) ..."   You've got all the pointers
> in hand; don't use indices.
[...]
> > +			if (id != &m25p_ids[i]) {
> 
> Again, don't use indices except during the lookup.

Yep, good ideas. Though, the code will vanish anyway.

Patches on the way...
