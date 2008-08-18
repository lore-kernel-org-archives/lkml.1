Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbYHROdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbYHROdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYHROdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:33:46 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:16818 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752809AbYHROdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:33:45 -0400
Date: Mon, 18 Aug 2008 18:33:43 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: linuxppc-dev@ozlabs.org, Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Message-ID: <20080818143343.GA30812@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <200808141645.56418.laurentp@cse-semaphore.com> <20080814151022.GA9885@oksana.dev.rtsoft.ru> <200808181558.50182.laurentp@cse-semaphore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <200808181558.50182.laurentp@cse-semaphore.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 03:58:46PM +0200, Laurent Pinchart wrote:
[...]
> > Not exactly. But you can do this way, if you need to preserve
> > a direction. What I did is a bit different though.
> > 
> > qe_gpio_set_dedicated() actually just restores a mode that
> > firmware had set up, including direction (since direction could
> > be a part of dedicated configuration).
> > 
> > That is, upon GPIO controller registration, we save all registers,
> > then driver can set up a pin to a GPIO mode via standard API, and
> > then it can _revert_ a pin to a dedicated function via
> > qe_gpio_set_dedicated() call. Dedicated function is specified by
> > the firmware (or board file), we're just restoring it.
> 
> The semantic of the set_dedicated() operation needs to be clearly
> defined then.

It is. We set up a dedicated function that firmware (or board file)
has configured.

> I can live with this behaviour, but it might not be
> acceptable for everybody.

For example?

> Your patch requires the firmware to set a pin in dedicated mode at
> bootup in order to be used later in dedicated mode.

Yes. On a PowerPC this is always true: firmware should set up PIO
config. Linux' board file could fixup the firmware though.

Another option would be to add some argument to the set_dedicated
call, thus the software could specify arbitrary dedicated
function (thus no need to save/restore anything). But this would
be SOC-model specific, thus no driver can use this argument anyway.

> If, for some
> reason (driver not loaded, ...), no GPIO user shows up for that
> pin, it will stay configured in dedicated mode.

Yes.

> It might be better to set the PAR bit unconditionally in

Why it might be better? That way you may set up wrong _GPIO_
mode, because you didn't set PAR bit (when PAR bit set
DIR/ODR/DAT bits are losing their meanings).

> qe_gpio_set_dedicated() instead of restoring its value. That way
> the board initialization code could just set the DIR, DAT and ODR
> bits for dedicated mode but still configure the pin in GPIO mode.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
