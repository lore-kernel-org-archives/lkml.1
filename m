Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbZBXWXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbZBXWXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZBXWXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:23:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2412 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZBXWXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:23:39 -0500
Date: Tue, 24 Feb 2009 22:23:29 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Message-ID: <20090224222328.GA21553@sirena.org.uk>
References: <200902081037.06645.david-b@pacbell.net> <20090210224851.GA6408@sirena.org.uk> <200902231245.44360.david-b@pacbell.net> <200902231252.01980.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902231252.01980.david-b@pacbell.net>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 12:52:01PM -0800, David Brownell wrote:

> Use those methods to force machine-level constraints into bounds.
> (Example:  regulator supports 1.8V, 2.4V, 2.6V, 3.3V, and board
> constraints for that rail are 2.0V to 3.6V ... so the range of
> voltages is then 2.4V to 3.3V on this board.)

Being able to support this is definitely a win, thanks for looking at
this.

> +	/* maybe force machine-wide voltage constraints to match the
> +	 * voltages supported by this regulator.  use the regulator's
> +	 * entire range for boards with no particular constraints.
> +	 */

I'd really rather the second bit weren't here.  I'd like to see a
warning for the first part.

> + * @count_voltages: Return the number of supported voltage indices which
> + *	may be passed to @list_voltage().  Some indices may correspond to
> + *	voltages that are not usable on this system.
> + * @list_voltage: Return one of the supported voltages, in microvolts;
> + *	or negative errno.  Indices range from zero to one less than
> + *	@count_voltages().  Voltages may be reported in any order.

I'm having a hard time loving this interface for the driver.  It feels
fairly cumbersome to have to provide two functions to look up what I'd
expect to be static data - I'd be fairly surprised to see it change at
runtime.  I think I'd expect to see something more like the way ALSA
represents dB scales where the driver supplies a list of ranges that can
either be simple values or value ranges expressed as (start, step,
count).  That would cover both complicated cases like the TWL4030 and
the other common case with large regular ranges of voltages.

This mostly applies to the driver interface - on the consumer side it
feels a bit cumbersome to use but I can't think of anything that's
particularly better.  An interface that also allows consumers to ask if
particular ranges can be satisfied might help here - it'd be nice for
things like MMC that want to check for a relatively small set of
voltages or voltage ranges (which I'd expect is the common case).
