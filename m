Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbYBVThN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbYBVThN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbYBVTg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:36:57 -0500
Received: from zeratul.whoi.edu ([128.128.76.62]:35342 "EHLO mx1.whoi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704AbYBVTgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:36:55 -0500
Message-ID: <47BF2455.8030904@whoi.edu>
Date: Fri, 22 Feb 2008 14:36:53 -0500
From: Ned Forrester <nforrester@whoi.edu>
Organization: Woods Hole Oceanographic Institution
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, marc.pignat@hevs.ch,
       linux-kernel@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [spi-devel-general] [PATCH] atmel_spi: support zero length	 transfer
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp> <200802201855.02605.marc.pignat@hevs.ch> <20080221.105233.41199605.nemoto@toshiba-tops.co.jp> <200802211026.17816.marc.pignat@hevs.ch> <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <47BED734.5030002@whoi.edu> <20080222190228.2B0CB28E363@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20080222190228.2B0CB28E363@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>> However, if the transfer is by DMA, note that the PXA255 and PXA270
>> Developer's Manuals have the following language regarding DMA lengths:
>>
>> 	LEN = 0 means zero bytes for descriptor-fetch transactions.
>> 	LEN = 0 is an invalid setting for no-descriptor-fetch
>> 	transactions. ...
>>
>> Because the pxa2xx_spi driver does not currently use DMA descriptors,
>> zero length DMAs are invalid.
> 
> In that case the pxa2xx_spi driver should add a special case to
> avoid starting such transfers in DMA mode.

So, what I think you said is that it would be better for pxa2xx_spi to
silently ignore a zero-length message, passing it back with the rest of
the message when all is complete, than to reject the message.  I see no
reason why that could not be done, though it may be tricky to set other
things like SSP modes and chip select and *not* start the DMA.  It would
have to be tested, so I'm not sure when I could try that.

>> I agree with Marc: any such delay will be undefined, in the general
>> case.  It might work for a specific driver implementation.
> 
> Is that what Marc said?  I couldn't tell.  In any case, I disagree;
> the semantics of that delay are clearly define.

Maybe I am missing something.  Aren't we talking about a transfer in a
message, with or without other transfers, who's only unique
characteristic is that that its length is zero?    What is clearly
defined about what should happen during that transfer?  I think (maybe
we are all confused) that Marc and I are talking about the delay, likely
short, caused by the processing or ignoring of that zero length transfer.

Or are you and Atsushi talking about using spi_transfer.delay_usecs
*with* a zero length transfer to effectively put a delay between the
assertion of CS and the start of the first clock?  If so, then I guess I
missed the original point.  Sorry.

--

By the way, reading spi.h again, it looks like spi_transfer.delay_usecs
is supposed to be implemented between the last bit movement of a
transfer and any change of CS at the end of a transfer.  Is that right?
 I think that pxa2xx_spi is dropping CS, if requested, immediately at
the end of transfer, and then putting spi_transfer.delay_usecs between
that transfer and the next.

-- 
Ned Forrester                                       nforrester@whoi.edu
Oceanographic Systems Lab                                  508-289-2226
Applied Ocean Physics and Engineering Dept.
Woods Hole Oceanographic Institution          Woods Hole, MA 02543, USA
http://www.whoi.edu/sbl/liteSite.do?litesiteid=7212
http://www.whoi.edu/hpb/Site.do?id=1532
http://www.whoi.edu/page.do?pid=10079

