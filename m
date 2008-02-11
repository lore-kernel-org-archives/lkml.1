Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYBKUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYBKUWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYBKUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:22:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51767 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYBKUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:22:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B0AE54.8090602@s5r6.in-berlin.de>
Date: Mon, 11 Feb 2008 21:21:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] firewire: fw-sbp2: fix I/O errors during reconnect
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.8110272bacc3f714@s5r6.in-berlin.de> <47B08F6B.2020502@redhat.com>
In-Reply-To: <47B08F6B.2020502@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Stefan Richter wrote:
>> +static void sbp2_conditionally_block(struct sbp2_logical_unit *lu)
>> +{
>> +    struct fw_card *card =
>> fw_device(lu->tgt->unit->device.parent)->card;
>> +
>> +    if (!atomic_read(&lu->tgt->dont_block) &&
>> +        lu->generation != card->generation &&
>> +        atomic_cmpxchg(&lu->blocked, 0, 1) == 0) {
> 
> Just to be absolutely sure, we don't need any barriers here to ensure we
> get the right generations, do we?

I didn't think so.  But I will carefully look at it again later this
week.  The function definitely must not block the device when the
generation is current.  We look at two data fields here which makes this
even more problematic.  Could be that we need locks after all.

> Also, this isn't expected to let I/O survive a disk being unplugged
> briefly, then plugged back in, is it?

No, this only tells the SCSI core to not bother fw-sbp2's
.queuecommand() with new commands before reconnect.  This will
mysteriously convince the SCSI core to not put the device offline too
quickly and will stabilize application client behavior thanks to
considerably fewer command retries.

To survive real or perceived temporary unplugs ("perceived" unplugs can
happen if a third node is slowly plugged in or out), we need to do
something in fw-device.c.  We have to keep the fw_device around after
node removal event until a timeout, to check newly added devices whether
they are in fact one of the undead devices, and to revive that one
rather than creating a new one.

> (I recall that being discussed, but I think it was as a 'would be
> nice to do in the future' thing).

I realized now that it is a 'need it sooner than later' thing because of
these "perceived" unplugs.  We need this feature at least with a minimal
timeout, otherwise people will sometimes lose connection to their
devices (the scsi_device will be destroyed and a new one created) when
they plug a 3rd or 4th or nth node.  As mentioned in another post, this
is an actual regression for those who migrated from ieee1394 to fw-core.
But fear not, it looks like I will have a prolonged weekend.  :-)
-- 
Stefan Richter
-=====-==--- --=- -=-==
http://arcgraph.de/sr/
