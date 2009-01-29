Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbZA2V3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbZA2V3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZA2V31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:29:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35695 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZA2V31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:29:27 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49821F99.4070108@s5r6.in-berlin.de>
Date: Thu, 29 Jan 2009 22:28:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jarod Wilson <jarod@redhat.com>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd
 generation iPods
References: <Pine.LNX.4.44L0.0901291536020.2394-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0901291536020.2394-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 29 Jan 2009, Stefan Richter wrote:
>> Obviously they changed something in Ubuntu 8.10 which suddenly made 3rd
>> gen iPods vulnerable too.  If the report is accurate, then this is /not/
>> the READ CAPACITY 10 issue where device's capacity report is off by one.
>> (The reported capacity without workaround is an even number and thus
>> possibly correct.)
> 
> Don't make that assumption.  One of the small number of devices which 
> really did have an odd number of sectors was an early iPod.

Ah, interesting.

(Jarod, didn't you see OS X report the same size on that 3rd gen. iPod
as Linux without quirk flag, or did I dream this?  In any case this
could of course simply mean that OS X uses a wrongly reported size...)

>>  Rather, this is apparently the kind of the bug where
>> an access which includes the last sector corrupts some state in the
>> firmware, causing the firmware to error out on subsequent accesses.  The
>> actual IO errors in the reporter's log happen at low LBAs, not at LBAs
>> at the end.
> 
> Are you aware of the last_sector_bug flag?  It prevents sectors near 
> the end of the device from being accessed using anything other than 
> single-sector reads or writes.  Some devices don't like it if, for 
> example, you do a 2-sector read that includes the last sector.

Now that you mention it I do remember.  I would need to ask the reporter
of the Ubuntu bug who has a fully working 3rd gen iPod (unlike Jarod's
3rd gen iPod which doesn't work reliably anymore) to compile a kernel
from patched sources if I really wanted to investigate whether the
last_sector_bug flag fixes the issue too.  The fix_capacity flag can be
easily enabled for FireWire disks by users of binary kernel packages at
runtime, so that's what I had the reporter try.

Hmm, I'm beginning to suspect that I should duplicate usb-storage's

	if (sdev->type == TYPE_DISK)
		sdev->last_sector_bug = 1;

into the FireWire drivers.  There aren't any fundamental downsides to
this, are there?

>> Now, what does OS X do with those iPods?  I don't know.  Maybe they have
>> quirks lists like we do.  There could be something to be found in the
>> Darwin sources.  But I consider it more likely that OS X simply does not
>> do the kind of accesses that Linux does which tend to crash all those
>> crap firmwares left and right.
>>
>> Evidently, at least popular Windows incarnations don't do such accesses,
>> at least not in normal usage.  Otherwise this class of firmware bugs
>> could simply not exist in mass market devices.
> 
> Linux uses the last-sector accesses to check whether or not the device 
> is part of a RAID.  Apparently Windows and OS X don't support the kinds 
> of RAID that need this.

Or they don't support these kinds of RAID over certain transports like
USB and FireWire...?
-- 
Stefan Richter
-=====-==--= ---= ===-=
http://arcgraph.de/sr/
