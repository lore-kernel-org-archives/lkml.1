Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZHTV5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZHTV5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZHTV5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:57:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57556 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751851AbZHTV5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:57:42 -0400
Date: Thu, 20 Aug 2009 22:58:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bruno =?ISO-8859-14?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090820225819.14c70306@lxorguk.ukuu.org.uk>
In-Reply-To: <20090820212549.7b4d93c9@neptune.home>
References: <20090819225034.470c52e8@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0908191834180.26174-100000@iolanthe.rowland.org>
	<20090820212549.7b4d93c9@neptune.home>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	/* For reasons that have been lost in antiquity, the TTY
> > layer calls
> > +	 * our close method even if the open call fails.  Hence we
> > must not
> > +	 * drop the reference obtained by usb_serial_get_by_index().

Not lost in antiquity:

The logic is this


	open
	do some opening work
	block on carrier
						HANGUP
	open returns error

	cleanup still required

So the tty layer always went that way so that the awkward cases around an
opening failing with a hangup just go away. For the normal drivers which
basically do

open:
	tty layer open work
		open hardware and set ASYNCB_INITIALIZED
	block for carrier

close:
	if (!hung_up) {
		if initialized
			shutdown()
	}

the USB layer works really hard to be completely different (in part
because the old code simply didn't implement open semantics properly or
hangup correctly - hence things like mgetty fail on them).

The later patches I was working on were trying to get USB serial to the
point where the model was that drv->open/drv->close were the hardware
init/shutdown and did indeed get called in nice matching open/close pairs
and not re-entered or called unserialized.

Nice spot on the ASYNC v ASYNCB bug Alan btw

Alan (the other one)

