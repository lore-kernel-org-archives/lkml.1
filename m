Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbXEIIOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbXEIIOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXEIINy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:13:54 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:34292 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbXEIINw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:13:52 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11 (PCI_MULTITHREAD_PROBE)
Date: Wed, 9 May 2007 10:14:16 +0200
User-Agent: KMail/1.9.6
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org> <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705091014.17109.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Instead of changing existign probe functionality to be asynchronous, we 
> could *add* a new and asynchronous part to it. For example, we could make 
> the rule for PCI - or other bus - devices be:
> 
>  - the bus will *first* call the "probe()" function synchronously.
> 
>  - after that one has completed, we will call "probe_async()" 
>    asynchronously at some point (it ie might be scheduled immediately 
>    after the "probe()" call, but delayed by some arbitrary issues like 
>    just already having too many asynchronous probes on-going or similar)

the usbatm USB ADSL modem drivers have this functionality.  These drivers
need to load firmware before they become useful.  The natural place to do
this is in the probe() method, but because firmware loading can take quite
some time (10 seconds, or even an infinite amount of time if the firmware
is not available and the timeout has been turned off) and would block the
USB hub thread if done from probe(), it's done in a separate kernel thread.
Clients of usbatm, like the speedtch driver, register themselves with usbatm,
providing a "bind" and a "heavy_init" method.  "bind" is like probe(), while
"heavy_init" is like probe_async().  First bind is called, and if successful
and heavy_init has been defined, then heavy_init is run in its own thread.
If the device is unplugged, usbatm takes care of making sure that the heavy_init
thread has stopped before calling unbind and destroying device related structures.

A bunch of other USB drivers could do with similar functionality for the
same reason (slow probe), and there was some discussion about generalizing
this functionality to the USB layer but I didn't find time to do anything
about it yet.  See http://marc.info/?l=linux-usb-devel&m=116551653026075&w=2

Best wishes,

Duncan.
