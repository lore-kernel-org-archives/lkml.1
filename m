Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYIIHST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYIIHST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYIIHSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:18:10 -0400
Received: from server.drzeus.cx ([85.8.24.28]:51546 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753455AbYIIHSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:18:08 -0400
Date: Tue, 9 Sep 2008 09:18:00 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org, oakad@yahoo.com
Subject: Re: MMC host driver requirements
Message-ID: <20080909091800.37eccc0f@mjolnir.drzeus.cx>
In-Reply-To: <20080907215228.GA19193@rere.qmqm.pl>
References: <20080907215228.GA19193@rere.qmqm.pl>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Sep 2008 23:52:28 +0200
Michał Mirosław <mirq-linux@rere.qmqm.pl> wrote:

> Hello,
> 
> I'm writing a driver for ENE CB710/720 memory card readers found in some
> laptops (ie. some versions of HP Compaq nx9500). This chip has three
> memory card interfaces: MMC/SD, SmartMedia, MemoryStick. I started with
> the MMC interface as I have a card to test it with, but I could not find
> any documentation about MMC stack besides the source code.
> 

Hmm... I thought the CB710/720 only had an SDHCI interface for the
MMC/SD portion.

> So here are some questions:
> 
> 1. Can I call mmc_detect_change() after mmc_alloc_host() but before or
>    during mmc_add_host() (ie. from interrupt handler)? If yes, what
>    if mmc_alloc_host() fails then?

No you can't.

> 2. Can I call mmc_request_done() from ->request() handler?

Yes, although I'm not sure how well tested it is.

> 3. Does MMC stack serialize calls to ->request() or any other host
>    driver ops?

Requests are serialised, yes. But you could in theory get set_ios()
calls during an ongoing request. Doing so would be very undefined
though so it should be sufficient to just avoid crashing the entire
system if that happens.

> 4. What is the difference (if any) between mrq->data and mrq->cmd->data
>    as seen from ->request()?

Not much really. The cmd->data pointer is for convenience as it allows
common code paths for handling mrq->cmd and mrq->stop.

> 5. Are there any constraints to scatterlist passed to ->request()
>    - number of elements, data alignment, element data size?
>    (At first I assumed that there are none and have writted a simple
>    wrapper to guarantee multiple-of-16-byte data blocks - but maybe
>    its just not needed?)

None at all. You have to specify your restrictions in the mmc_host
structure fields (note that you cannot restrict alignment in any way).
The mmc_test driver is useful for testing some of the corner cases.

> If/when I finish the driver there is the question what are the
> requirements for it to be accepted to mainline? It's based on
> reverse-engineering work on a Windows driver so it will have
> some magic register-access sequences, as the original driver used
> completely different MMC/SD stack and probably not fully used chip's
> capabilities.

The requirements are generally low for merging. Mostly you just need to
promise to stick around and fix problems. You should be aware that the
style requirements and API adherence are very important. Run you stuff
through checkpatch.pl before submitting. Sparse can usually also find
quite a few problems.

> BTW, Google said nothing interesting about the hardware: most hits are
> about not existing drivers for it and manufacturer ignoring inquiries
> for datasheets.

As I said, to my knowledge the sdhci driver covers this hardware, but
the support is rather crappy as the controller is buggy as hell. And
ENE does indeed ignore all attempts at contact.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
