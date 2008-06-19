Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYFST41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYFST41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 15:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYFST4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 15:56:18 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:46372 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYFST4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 15:56:17 -0400
Message-ID: <485AB95E.5070609@s5r6.in-berlin.de>
Date: Thu, 19 Jun 2008 21:54:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, mdharm-usb@one-eyed-alien.net,
       linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de> <20080619185419.GN4392@parisc-linux.org>
In-Reply-To: <20080619185419.GN4392@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jun 19, 2008 at 08:39:38PM +0200, Stefan Richter wrote:
>> The problem is AFAIU not exactly how many Scsi_Host instances (initiator 
>> port representations, or something remotely related to that) are 
>> instantiated, but rather _when_ they are instantiated.  On multi 
>> protocol buses or networks like USB and FireWire, it makes sense to 
>> create the SCSI initiator port representation when we discovered that 
>> there are actually SCSI targets on the bus or network.
> 
> I'm not convinced of that.

Drivers like usb-storage and sbp2 are high-level drivers (protocol
drivers) on top of driver stacks.  They a priori talk to struct device
instances which represent subunits on "external" devices; they don't
have much business with the local host controller device.  For them,
"SCSI initiator port" is a rather hazy and, in the implementation,
uninteresting concept.  (That's how it is with sbp2; I'm only guessing
how it is with usb-storage.)

However, there are several ways to accomplish the same thing in the
implementation.  I heard there were more constraints under Linux 2.4;
some current implementation details may just be legacy.

> Why shouldn't we create one scsi host for
> all USB scsi devices?

Or one for each USB HCD.

I thought about that for FireWire but never started to actually try it
out.  Parent-child relationships of struct devices would be different
from what we have today.

[...]
> The mail that I just pinged described a way to enhance the
> API -- letting you tell scsi "I've started scanning, save me a place in
> the queue" and "I've finished scanning, hook me up".

When would be the right time to say "I've started scanning"?  SCSI
transport driver initialization?  Or end of USB/FireWire/... HCD
registration?

When to say "I've finished scanning"? --- I think the answer is:  When
(a) probing of a configurable number of SCSI targets or logical units
was finished or (b) a configurable timeout occurs, whatever of the two
happens first.

(Explanation, if one is necessary:  SCSI targets may pop out of the
woods any time; it is impossible to say "from this moment on there won't
show up any new ones anymore".  This is just as true for cold boot and
warm boot as it is for subsequent operation.)
-- 
Stefan Richter
-=====-==--- -==- =--==
http://arcgraph.de/sr/
