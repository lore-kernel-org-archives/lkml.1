Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbXIUN2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbXIUN2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbXIUN2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:28:33 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:45086 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbXIUN2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:28:32 -0400
Date: Fri, 21 Sep 2007 14:28:19 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Gerd Hoffmann <kraxel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Yinghai.Lu@Sun.COM, bryan.wu@analog.com,
       dilinger@queued.net, lethal@linux-sh.org, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
In-Reply-To: <46F3BC3A.8060703@redhat.com>
Message-ID: <Pine.LNX.4.64N.0709211352560.2724@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl>
 <20070921010349.2caee558.akpm@linux-foundation.org> <46F3BC3A.8060703@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Gerd Hoffmann wrote:

> Well, I placed the printk there is for user interface reasons.  I think
> especially in case the early console and the real console go to
> different physical devices it is useful to have the reason it stops
> printing messages displayed on the early console.  So people don't think
> the computer hangs although it just prints messages elsewhere ...

 I have thought this might be the reason, but did not want to suggest 
anything.  Yes, it is useful in a way and I was bitten a few times in the 
past with the output disappearing on the boot console with no further 
output (and usually a complete hang) because of a problem in the real 
console driver.  It just happens I always knew which driver was involved.

> If that isn't going to work due to two instances not knowing each other
> (kernel & firmware) should not mess with the same physical device, then
> I'd just drop the printk.  And I see no pretty and easy way around that
> issue :-(

 Not so fast please. :-)

> We could do the printk and unregister before we setup the new console.
> Which has the drawback that we are in trouble in case the setup() call
> for the new console fails ...
> 
> We could split the printk into two, one early ("trying to setup new
> console foo") which goes to the boot console, then (assuming the setup
> worked ok) unregister silently and print a message about the successful
> init and boot console unregister on the new console only.  Which results
> in two lines being printed for the handover when both consoles address
> the same physical device.  Not that nice IMHO, but maybe still the best
> way to handle it.

 I have thought of it too.  It is just the "for" loop responsible for 
doing this is somewhat convoluted so I did not want to proceed with a 
possibly complicated patch just to demonstrate the problem.

 I think it is not a bad approach and in some sense it could be nicer as 
would provide some feedback on which drivers are tried for the console.  
The drawback is if there are many candidate console drivers that may fail 
for some reason, like being optional for the platform, then a lot of 
output will result.  The way it could work might be by printing the:

handover: boot [<foo>] -> real [<bar>]

line to the boot console only and then printing:

console [<bar>] enabled

unconditionally if registering of <bar> succeeded and once <foo> has been 
unregistered.

 On the other hand the current approach has this limitation that if it 
actually works for a given platform, then the two lines may be printed to 
the same devices and overlap.  This is for example the case with the SWARM 
board (using drivers/serial/sb1250-duart.c) which also uses a firmware 
call for the initial console.  It does not seem to be that concerned about 
the transmitter being disabled, but it does not wait for the transmitter 
shift register to drain and output is garbled.  Here is an excerpt from a 
SWARM boot log as seen on the serial port (codes in agle brackets coming 
from the interpretation of non-ASCII characters by `less'):

PID hash table entries: 1024 (order: 10, 8192 bytes)
Using 1.000 MHz high precision timer.
Console: colour dum7<BD><B9><CD><BD><B1><95><81>handover: boot [early0] -> real [duart0]
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar

Though frankly it is even some previous line being destroyed here...

  Maciej
