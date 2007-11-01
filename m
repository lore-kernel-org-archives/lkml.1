Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbXKAJw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbXKAJw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759697AbXKAJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:52:04 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:52679 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758803AbXKAJwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:52:01 -0400
Message-ID: <4729A1BF.8010800@s5r6.in-berlin.de>
Date: Thu, 01 Nov 2007 10:51:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Subject: dealing with barriers (was Re: [PATCH] firewire: fw-core: enforce
 write order when updating fw_device.generation)
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de> <200711011453.35268.nickpiggin@yahoo.com.au>
In-Reply-To: <200711011453.35268.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thursday 01 November 2007 12:49, Stefan Richter wrote:
>> fw_device.node_id and fw_device.generation are accessed without mutexes.
>> We have to ensure that all readers will get to see node_id updates
>> before generation updates.
>>
> 
> Hi, a few points:

Thanks, this is appreciated.

> - can change it to use spinlocks instead? This would be most
>   preferable.

It could be done, but I don't find it preferable for this purpose.
Although the struct members in question are basically part of fw-core's
API (kernel-internal API), there won't be a lot of places which access
these members.

(Besides, lockless algorithms are essential to FireWire driver code
everywhere where CPU and controller interact.  So IMO these lockless
accesses don't constitute a whole new level of complexity in these drivers.)

> - if not, you need comments.

So far I tended to disagree every time when checkpatch.pl bugged me
about barriers without comments.  But maybe that was because I had a
wrong idea of what kind of comment should go there.  There would
certainly be no value in a comment which effectively says "trust me, I
know we need a barrier here".  However, thinking about it again, it
occurs to me that I should add the following comments:

  1.) At respective struct type definitions:  A comment on how struct
      members are to be accessed and why.

  2.) At the occurrences of rmb() and wmb():  A comment on which
      accesses the particular barrier divides.  This is in order to get
      the barriers properly updated (i.e. moved or removed) when
      surrounding code is reordered, APIs reworked, or whatever.

Of course this division of the Why and the What only applies to accesses
like those in the patch --- i.e. API-like data types which aren't
abstracted by accessor functions --- while there may be other
requirements on comments for other usage types of barriers.

Or am I still wrong in my judgment of how barriers should be documented?

> - you also seem to be missing rmb()s now. I see a couple in the
>   firewire directory, but nothing that seems to be ordering loads
>   of these particular fields.

That's right.  Of course the wmb()s don't make sense if the reader side
isn't fixed up accordingly.  I did this for all places which I spotted
yesterday in the patches
"firewire: fw-core: react on bus resets while the config ROM is being
fetched", http://lkml.org/lkml/2007/10/31/464  (Hmm, this has an unclear
changelog.)
"firewire: fw-sbp2: enforce read order of device generation and node
ID", http://lkml.org/lkml/2007/10/31/465

I didn't fold all these patches into one because these two other patches
include also other changes to the respective read sides.  I should have
pointed this out in this first patch.

Also, it could be that I have overlooked one more reader last night; I
will reexamine it.

> - use smp_*mb() if you are just ordering regular cacheable RAM
>   accesses.

Hmm, right.  Looks like the smp_ variants are indeed the right thing to
do here.

> Also, diffstat is a bit wrong... maybe you posted the wrong version?

Oops, this happened when I worked on what became the "fw-core: react on
bus resets..." patch.  So the diffstat is wrong but...

>> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>> ---
>>  drivers/firewire/fw-device.c   |    6 ++++++
>>  drivers/firewire/fw-topology.c |    1 +
>>  2 files changed, 7 insertions(+)
>>
>> Index: linux/drivers/firewire/fw-device.c
>> ===================================================================
>> --- linux.orig/drivers/firewire/fw-device.c
>> +++ linux/drivers/firewire/fw-device.c
>> @@ -808,6 +813,7 @@ void fw_node_event(struct fw_card *card,
>>
>>  		device = node->data;
>>  		device->node_id = node->node_id;
>> +		wmb();
>>  		device->generation = card->generation;
>>  		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
>>  			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
>> Index: linux/drivers/firewire/fw-topology.c
>> ===================================================================
>> --- linux.orig/drivers/firewire/fw-topology.c
>> +++ linux/drivers/firewire/fw-topology.c
>> @@ -518,6 +518,7 @@ fw_core_handle_bus_reset(struct fw_card
>>  		card->bm_retries = 0;
>>
>>  	card->node_id = node_id;
>> +	wmb();
>>  	card->generation = generation;
>>  	card->reset_jiffies = jiffies;
>>  	schedule_delayed_work(&card->work, 0);

...the diff is what I intended.  Anyway, maybe I should make it a habit
to send patches only between 10 AM and 10 PM local time.  :-)
-- 
Stefan Richter
-=====-=-=== =-== ----=
http://arcgraph.de/sr/
