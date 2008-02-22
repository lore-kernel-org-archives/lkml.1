Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYBVOdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYBVOdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYBVOdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:33:25 -0500
Received: from zeratul.whoi.edu ([128.128.76.62]:44413 "EHLO mx1.whoi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYBVOdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:33:24 -0500
Message-ID: <47BED734.5030002@whoi.edu>
Date: Fri, 22 Feb 2008 09:07:48 -0500
From: Ned Forrester <nforrester@whoi.edu>
Organization: Woods Hole Oceanographic Institution
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: marc.pignat@hevs.ch, anemo@mba.ocn.ne.jp,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH] atmel_spi: support zero length	transfer
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp>	<200802201855.02605.marc.pignat@hevs.ch>	<20080221.105233.41199605.nemoto@toshiba-tops.co.jp>	<200802211026.17816.marc.pignat@hevs.ch> <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>> David, do you think writing 0 bytes is a valid use of this API?
>
> Just a zero byte transfer ... no, though it depends what you mean
> by "valid".  (I'm not sure I'd expect all controller drivers to
> reject such requests.)  That has no effect on bits-on-the-wire,
> and would make trouble for various DMA engines.

FWIW, the pxa2xx_spi driver does not, near as I can tell, reject zero
length transfers, it will go through the motions, the same as for any
other transfer.

However, if the transfer is by DMA, note that the PXA255 and PXA270
Developer's Manuals have the following language regarding DMA lengths:

	"LEN = 0 means zero bytes for descriptor-fetch transactions.
	LEN = 0 is an invalid setting for no-descriptor-fetch
	transactions. Programming LEN = 0 in the descriptor-fetch mode
	when DCMD[CmpEn] is clear (normal data transfer mode) causes
	the channel to immediately discard the descriptor after it is
	fetched from memory. If the descriptor chain has more
	descriptors, the channel fetches the next valid descriptor.
	The channel stops if the descriptor chain has no more
	descriptors."

Because the pxa2xx_spi driver does not currently use DMA descriptors,
zero length DMAs are invalid.  I don't know what the DMA controller will
do if given a zero length.  If it were using using descriptors (as in my
development code, useful only when chaining transfers that don't need
any SSP parameters or chip selects changed, nor any time delays), then a
zero length transfer would only introduce the insignificant delay of
fetching one 4-word descriptor.

If, on the other hand, DMA is not used, it looks like the zero length
case is handled gracefully.  The chip select and other SSP registers are
set, but no bytes are transferred.  It does not look like any particular
delay would be involved in this, as all transfers within a message are
handled in interrupt context with an ISR and tasklet.  There is not much
code being executed to limit the minimum delay, and the maximum would
depend on interrupt/tasklet latency.

> Passing zero bytes to get an inline delay at an exact spot in the
> overall protocol message ... I don't see why not.  Better than
> adding delay fields for every spot it might be needed by various
> oddball devices, for sure!!

I agree with Marc: any such delay will be undefined, in the general
case.  It might work for a specific driver implementation.

-- 
Ned Forrester                                       nforrester@whoi.edu
Oceanographic Systems Lab                                  508-289-2226
Applied Ocean Physics and Engineering Dept.
Woods Hole Oceanographic Institution          Woods Hole, MA 02543, USA
http://www.whoi.edu/sbl/liteSite.do?litesiteid=7212
http://www.whoi.edu/hpb/Site.do?id=1532
http://www.whoi.edu/page.do?pid=10079

