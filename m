Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZDVUy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZDVUy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZDVUyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:54:44 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:24225 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDVUyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:54:43 -0400
X-IronPort-AV: E=Sophos;i="4.40,232,1238976000"; 
   d="scan'208";a="157857128"
Date: Wed, 22 Apr 2009 13:54:27 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jamie Lokier <jamie@shareable.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090422205427.GA28435@cuplxvomd02.corp.sa.net>
References: <20090421230849.GA29555@cuplxvomd02.corp.sa.net> <Pine.LNX.4.44L0.0904221111320.3405-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904221111320.3405-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-6; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 11:40:09AM -0400, Alan Stern wrote:
> On Tue, 21 Apr 2009, David VomLehn wrote:
...
> > There is one other possible gotcha to this approach. The code as I wrote it is
> > bus-agnostic, i.e. it has no idea where the console is located. As far as
> > I know, the long time to probe possible console devices only arises with
> > USB. If this is not tree, we need to handle any other cases that can arise.
> 
> That is a very good objection.  For this sort of approach to work,
> ultimately it would have to be implemented for every hotpluggable bus
> of interest.

Alright, I know you (Alan (Stern)) know about USB. I think someone else
mentioned Firewire. What other hotpluggable buses do we need to worry about
and how can we get them interested?

> The console delay routine will then wait until the USB serial device is
> discovered and registered, at which point its job is done.  It won't
> continue to wait until all the USB devices present at boot time have
> been probed, since there's no reason to wait after the first console
> device is discovered.

For each boot device, we need to determine whether a) we for some subset
instance of a device class, or b) until all possible instances of a device
class have been probed. In case a, we exit the wait if either:
1.	A suitable device has been registered, i.e. any console, a specific
	network device, etc., or
2.	All devices have been probed
If we exit for reason 2, it means that no such device is present,
and we go on to the do the appropriate thing for that device class.

In case b, we exit the wait only when all devices have been probed. Then
we either have a device of that class or not, and we do the appropriate thing.

There is a special case for USB consoles, which might apply to other buses
and classes of devices, as well: if USB_CONSOLE is not configured, you don't
need to wait for notification from USB. This helps guide the design of the
required infrastructure.

> So not only would you not need to tune two different delay times, you 
> wouldn't even need to tune one!  You wouldn't need to specify any delay 
> times at all.

This would make me and, clearly, a lot of other people happy, as well.

> Which essentially means waiting until _all_ the devices present at boot 
> time (both USB and non-USB) have been probed.  Right?  And it 
> explicitly means ruling out waiting for new devices which the user 
> might plug in after the system has booted, since a new console device 
> could be plugged in at any time.

Yes, I think we absolutely exclude devices plugged in after boot. I think such
usage, if it needs to be supported, can be handled with hot plugging. I'm a
little squishy on whether we might to be able to hot plug USB consoles as I
have a request to support this, but I think it's a separate issue from
supporting hot pluggable boot devices and I'm not worrying about it now.

> > If there is a way to guarantee that we are done with the probing, I'm
> > all for using that. Will waiting for the USB hub driver to be idle do this?
> 
> I'm pretty sure something like it can be made to work, subject to the 
> delays caused by bad devices.

There will always be bad devices, but let's see if we can support the good
devices, first. If the bad devices will make a commitment to rehabilitate
themselves, perhaps we can consider their needs later.

I'm going to see if I can come up with some sort of concrete proposal for
waiting for hotpluggable boot devices. I'd appreciate it if you could think
about how to implement the USB-specific part of this. Once we have something
that makes sense, and works, we can go back and pick up the details for
the console, IP autoconfig, and anything else that someone might need done.

> Alan Stern

David VomLehn
