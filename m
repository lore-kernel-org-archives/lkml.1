Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYHJTIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYHJTIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 15:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYHJTIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 15:08:07 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:32890 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYHJTIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 15:08:06 -0400
Date: Sun, 10 Aug 2008 21:08:02 +0200
From: Andreas Mohr <andi@lisas.de>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Andreas Mohr <andi@lisas.de>, LKML <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-acpi@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: ACPI PM-Timer on K6-3 SiS5591: Houston...
Message-ID: <20080810190759.GA1879@rhlx01.hs-esslingen.de>
References: <20080810101730.GA10024@rhlx01.hs-esslingen.de> <20080810162920.GA9860@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810162920.GA9860@comet.dominikbrodowski.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 06:29:20PM +0200, Dominik Brodowski wrote:
> Hi Andreas,
> 
> On Sun, Aug 10, 2008 at 12:17:30PM +0200, Andreas Mohr wrote:
> > Result: catastrophic timer behaviour (a large backwards skip is possible),
> > even in case we do a triple-read workaround, due to a floating bit at
> > 0x0400 (possibly caused by underclocking from 400 to 150, but whatever...).
> 
> this isn't the bug which is handled by the read-three-times-workaround.
> Instead, that handels the following PIIX4 errata:

OK, right, technically this workaround is not related to this
different bug.
And it's in fact not this triple-read which has any weakness here but rather
the init check.

> > And my system does pass the bootup PM-Timer check quite often despite
> > this severe defect (2 in 4 bootups _did_ register my defective
> > acpi_pm clocksource).
> 
> No surprise there -- it is the first time I see such an error; and it might
> actually be a bug specific to your computer's motherboard. 

Yeah, might be motherboard only, but likely still chipset-global,
since probably not too many people tried this beast with ACPI / acpi_pm even
(we're not even talking about the usual Linux ACPI 2001 blacklist limit
with this board, more like 1999, 1998 or even 1997 stoneage).

OK, dmidecode said:
        Vendor: Award Software International, Inc.
        Version: 4.51 PG
        Release Date: 07/05/99

Might be a generic Award date value in this case, but still quite stoneage.


> > I realized that in historic versions (e.g. 2.6.12) read_pmtmr()
> > encompassed the _entire_ "triple-reading due to latch bug" logic.
> > Nowadays read_pmtmr() is the raw inline version of a single inl() only!
> > However despite this large change, the initial hardware check
> > (at init_acpi_pm_clocksource()) _kept using_ the now single-read read_pmtmr()
> > as if nothing had happened.
> 
> See patch below. Is there a proper format modifier for cycle_t ?

_DAMN_ you're fast! ;)

Technically it's related to the base type of cycle_t (i.e., u64 and thus
probably "unsigned long long"), thus %llx is the format specifier
that I'd have chosen as well.

> Well, we could do something like this for sure, but I haven't seen any other
> such bug report before...

I guess I'm treading on new land here...

> > - "known good workaround" systems should provide workaround from the beginning
> => see patch below.
> > - initial timer check should then do at least 10 increment checks with
> >   10 of 10 successful
> => might do this, but currently I'm not yet convinced whether we really need
> it.

Even if it's not a systematic chipset / layout error, then I'm sure there's always
the occasional custom-broken (read: damaged) system which would need a
useful check to avoid counter-related lockups.

IMHO the current init check is too weak, it will catch the very simplest
types of problems only, and that's not a good thing.

About Arjan's suggestion to use DMI blacklisting here: not the right
method here IMHO since one could easily catch such problems generically
and thus much more reliably than maintaining an ever-growing and thus
always-incomplete blacklist collection.
Anyway, he provided important input still ;)

Andreas Mohr
