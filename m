Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbXEIJQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbXEIJQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXEIJPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:15:42 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:57915 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbXEIJPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:15:41 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
Date: Wed, 9 May 2007 11:16:06 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <200705091014.17109.duncan.sands@math.u-psud.fr> <20070509104541.48cc901e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070509104541.48cc901e@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091116.06995.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cornelia,

> > the usbatm USB ADSL modem drivers have this functionality.  These drivers
> > need to load firmware before they become useful.  The natural place to do
> > this is in the probe() method, but because firmware loading can take quite
> > some time (10 seconds, or even an infinite amount of time if the firmware
> > is not available and the timeout has been turned off) and would block the
> > USB hub thread if done from probe(), it's done in a separate kernel thread.
> > Clients of usbatm, like the speedtch driver, register themselves with usbatm,
> > providing a "bind" and a "heavy_init" method.  "bind" is like probe(), while
> > "heavy_init" is like probe_async().  First bind is called, and if successful
> > and heavy_init has been defined, then heavy_init is run in its own thread.
> > If the device is unplugged, usbatm takes care of making sure that the heavy_init
> > thread has stopped before calling unbind and destroying device related structures.
> > 
> > A bunch of other USB drivers could do with similar functionality for the
> > same reason (slow probe), and there was some discussion about generalizing
> > this functionality to the USB layer but I didn't find time to do anything
> > about it yet.  See http://marc.info/?l=linux-usb-devel&m=116551653026075&w=2
> 
> Would a general split between probe() (check if we can handle the
> device, do very basic stuff) and setup() (get the device up and
> running) make sense? Drivers could stay with today's probe() function
> if they want to (and still be working). setup() could be, but need not
> be async. As an added benefit for huge systems, setup() might only be
> called if explicitly requested (like "only do this heavy lifting
> if/when we really want to use the device"). probe() could call bind()
> and setup() (doing the firmware load etc.) heavy_init(). (This may be
> orthogonal to the probe()/probe_async() idea.)

yes that would be fine.  Like with your setup() suggestion, it is possible
to specify whether heavy_init should be called or not.  This is useful if
the firmware has already been uploaded - the probe() can detect this and
signal that heavy_init is not needed.

The main difficulties encountered with usbatm were: (1) avoiding race
conditions on device disconnect; (2) providing a way to cancel heavy_init.
As mentioned in my original email, heavy_init could run forever depending
on how the system is configured.  In the current implementation a signal
is sent on disconnect(), to indicate that the game is up, then disconnect()
blocks until heavy_init terminates, if it hasn't already.  A better method
would be to allow registration of a cancel() routine, which disconnect
would call before blocking on heavy_init termination.  This could send a
signal, or complete a completion, or whatever.  Sadly, the generic firmware
loading infrastructure doesn't have a way of asynchronously cancelling a
firmware load, so right now cancellation only does something if the firmware
has already been loaded from disk, in which case it cancels the upload to the
modem (which is the most time consuming part).

Best wishes,

Duncan.
