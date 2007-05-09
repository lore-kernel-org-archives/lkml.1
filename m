Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbXEIIq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbXEIIq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbXEIIqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:46:00 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:58088 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbXEIIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:45:58 -0400
Date: Wed, 9 May 2007 10:45:41 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Greg K-H <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
 (PCI_MULTITHREAD_PROBE)
Message-ID: <20070509104541.48cc901e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200705091014.17109.duncan.sands@math.u-psud.fr>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com>
	<alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org>
	<alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
	<200705091014.17109.duncan.sands@math.u-psud.fr>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 10:14:16 +0200,
Duncan Sands <duncan.sands@math.u-psud.fr> wrote:

> the usbatm USB ADSL modem drivers have this functionality.  These drivers
> need to load firmware before they become useful.  The natural place to do
> this is in the probe() method, but because firmware loading can take quite
> some time (10 seconds, or even an infinite amount of time if the firmware
> is not available and the timeout has been turned off) and would block the
> USB hub thread if done from probe(), it's done in a separate kernel thread.
> Clients of usbatm, like the speedtch driver, register themselves with usbatm,
> providing a "bind" and a "heavy_init" method.  "bind" is like probe(), while
> "heavy_init" is like probe_async().  First bind is called, and if successful
> and heavy_init has been defined, then heavy_init is run in its own thread.
> If the device is unplugged, usbatm takes care of making sure that the heavy_init
> thread has stopped before calling unbind and destroying device related structures.
> 
> A bunch of other USB drivers could do with similar functionality for the
> same reason (slow probe), and there was some discussion about generalizing
> this functionality to the USB layer but I didn't find time to do anything
> about it yet.  See http://marc.info/?l=linux-usb-devel&m=116551653026075&w=2

Would a general split between probe() (check if we can handle the
device, do very basic stuff) and setup() (get the device up and
running) make sense? Drivers could stay with today's probe() function
if they want to (and still be working). setup() could be, but need not
be async. As an added benefit for huge systems, setup() might only be
called if explicitly requested (like "only do this heavy lifting
if/when we really want to use the device"). probe() could call bind()
and setup() (doing the firmware load etc.) heavy_init(). (This may be
orthogonal to the probe()/probe_async() idea.)
