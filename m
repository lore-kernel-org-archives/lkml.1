Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYIIJGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYIIJGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYIIJGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:06:17 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:50572 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbYIIJGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:06:16 -0400
Date: Tue, 9 Sep 2008 11:06:13 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, oakad@yahoo.com
Subject: Re: MMC host driver requirements
Message-ID: <20080909090613.GA22158@rere.qmqm.pl>
References: <20080907215228.GA19193@rere.qmqm.pl> <20080909091800.37eccc0f@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080909091800.37eccc0f@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 09:18:00AM +0200, Pierre Ossman wrote:
> On Sun, 7 Sep 2008 23:52:28 +0200
> Micha³ Miros³aw <mirq-linux@rere.qmqm.pl> wrote:
> > I'm writing a driver for ENE CB710/720 memory card readers found in some
> > laptops (ie. some versions of HP Compaq nx9500). This chip has three
> > memory card interfaces: MMC/SD, SmartMedia, MemoryStick. I started with
> > the MMC interface as I have a card to test it with, but I could not find
> > any documentation about MMC stack besides the source code.
> Hmm... I thought the CB710/720 only had an SDHCI interface for the
> MMC/SD portion.

SDHCI supports CB712/714 parts. I already investigated that CB710 is not
SDHCI-compatible (register layout is a bit different, for a start).

> > So here are some questions:
> > 
> > 1. Can I call mmc_detect_change() after mmc_alloc_host() but before or
> >    during mmc_add_host() (ie. from interrupt handler)? If yes, what
> >    if mmc_alloc_host() fails then?
> No you can't.

> > 2. Can I call mmc_request_done() from ->request() handler?
> Yes, although I'm not sure how well tested it is.

I checked yesterday that indeed nothing bad happens, but looking at
the code I can see that mmc_request_done can call ->request() with
a retried request so, unless gcc optimizes tail-calls, recursion
there might eat up all stack space someday.

> > 3. Does MMC stack serialize calls to ->request() or any other host
> >    driver ops?
> Requests are serialised, yes. But you could in theory get set_ios()
> calls during an ongoing request. Doing so would be very undefined
> though so it should be sufficient to just avoid crashing the entire
> system if that happens.

This should be easy.

> > 4. What is the difference (if any) between mrq->data and mrq->cmd->data
> >    as seen from ->request()?
> Not much really. The cmd->data pointer is for convenience as it allows
> common code paths for handling mrq->cmd and mrq->stop.

Is it safe to assume that cmd->data is NULL when command type is other
than ADTC? I've looked briefly through drivers/mmc/core/*_ops.c, but
maybe I missed something?

> > 5. Are there any constraints to scatterlist passed to ->request()
> >    - number of elements, data alignment, element data size?
> >    (At first I assumed that there are none and have writted a simple
> >    wrapper to guarantee multiple-of-16-byte data blocks - but maybe
> >    its just not needed?)
> None at all. You have to specify your restrictions in the mmc_host
> structure fields (note that you cannot restrict alignment in any way).
> The mmc_test driver is useful for testing some of the corner cases.

I'll give it a try.

Thanks for your reply. I'll post the code for review when it does more
than just blinking LEDs. ;)

Best Regards,
Micha³ Miros³aw

