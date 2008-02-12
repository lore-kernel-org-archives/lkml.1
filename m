Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYBLFH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYBLFH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 00:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbYBLFHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 00:07:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757052AbYBLFHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 00:07:48 -0500
Message-ID: <47B1298D.2000600@redhat.com>
Date: Tue, 12 Feb 2008 00:07:25 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] firewire: fw-sbp2: fix I/O errors during reconnect
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.8110272bacc3f714@s5r6.in-berlin.de> <47B08F6B.2020502@redhat.com> <47B0AE54.8090602@s5r6.in-berlin.de>
In-Reply-To: <47B0AE54.8090602@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Jarod Wilson wrote:
>> Stefan Richter wrote:
>>> +static void sbp2_conditionally_block(struct sbp2_logical_unit *lu)
>>> +{
>>> +    struct fw_card *card =
>>> fw_device(lu->tgt->unit->device.parent)->card;
>>> +
>>> +    if (!atomic_read(&lu->tgt->dont_block) &&
>>> +        lu->generation != card->generation &&
>>> +        atomic_cmpxchg(&lu->blocked, 0, 1) == 0) {
>> Just to be absolutely sure, we don't need any barriers here to ensure we
>> get the right generations, do we?
> 
> I didn't think so.  But I will carefully look at it again later this
> week.  The function definitely must not block the device when the
> generation is current.  We look at two data fields here which makes this
> even more problematic.  Could be that we need locks after all.

I didn't see anything else earlier on that guaranteed we got the current 
generation in both cases, but I didn't look exhaustively, and you know 
this code a lot better than I do, so I definitely defer to your better 
judgment, just wanted to make sure it had been considered.


>> Also, this isn't expected to let I/O survive a disk being unplugged
>> briefly, then plugged back in, is it?
> 
> No, this only tells the SCSI core to not bother fw-sbp2's
> .queuecommand() with new commands before reconnect.  This will
> mysteriously convince the SCSI core to not put the device offline too
> quickly and will stabilize application client behavior thanks to
> considerably fewer command retries.

Okay, that's what I thought and what I observed in operation.

> To survive real or perceived temporary unplugs ("perceived" unplugs can
> happen if a third node is slowly plugged in or out), we need to do
> something in fw-device.c.  We have to keep the fw_device around after
> node removal event until a timeout, to check newly added devices whether
> they are in fact one of the undead devices, and to revive that one
> rather than creating a new one.

Gotcha. So basically, a temporary table of devices recently "removed", 
which will expire to full/actual removal after some relatively short 
interval, but which we'll also check for matches of "newly" connected 
devices to see if we should cancel removing the device and just pretend 
like it never actually went away. Right? I wonder if there's any sort of 
guidance on this sort of thing in the firewire specs... I'll make an 
effort to search for relevant info, unless you've already got it.

>> (I recall that being discussed, but I think it was as a 'would be
>> nice to do in the future' thing).
> 
> I realized now that it is a 'need it sooner than later' thing because of
> these "perceived" unplugs.  We need this feature at least with a minimal
> timeout, otherwise people will sometimes lose connection to their
> devices (the scsi_device will be destroyed and a new one created) when
> they plug a 3rd or 4th or nth node.  As mentioned in another post, this
> is an actual regression for those who migrated from ieee1394 to fw-core.
> But fear not, it looks like I will have a prolonged weekend.  :-)

Heh, sounds good. I missed out on my entire past weekend (and half a 
week of work) due to family illnesses. Hoping to throw a bunch of time 
at further firewire work this week though.

-- 
Jarod Wilson
jwilson@redhat.com
