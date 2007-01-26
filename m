Return-Path: <linux-kernel-owner+w=401wt.eu-S1030736AbXAZEHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030736AbXAZEHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030737AbXAZEHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:07:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030736AbXAZEHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:07:44 -0500
Message-ID: <45B97D28.1090404@redhat.com>
Date: Thu, 25 Jan 2007 23:01:44 -0500
From: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060803)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Pete Zaitcev <zaitcev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Juju
References: <20070124223745.33278eb4.zaitcev@redhat.com>	<45B91EAB.9080004@redhat.com> <20070125153824.8d7f50c5.zaitcev@redhat.com> <45B968E7.1070402@s5r6.in-berlin.de>
In-Reply-To: <45B968E7.1070402@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Pete Zaitcev wrote:
>> On Thu, 25 Jan 2007 16:18:35 -0500, Kristian Høgsberg <krh@redhat.com> wrote:
> ...
>>> will do a status write to the status address specified in the ORB, at which 
>>> point the SBP-2 transaction is complete.
>> You know, I wanted to use this picture for a long time:
>>  http://www.flickr.com/photos/zaitcev/369269557/

Haha, sure :)

> The fundamental thing about SBP-2 is that ORBs ( = SCSI command blocks
> plus SBP-2 header) and data buffers all reside in the memory of the
> initiator (or of a 3rd party on the FireWire bus). The target peeks and
> pokes them when and how it sees fit. The initiator pushes only tiny
> notifications about availability of new ORBs to the target. The target
> eventually completes SCSI commands in-order or out-of-order and signals
> so by pushing a status block per one or more completed commands.
> 
> (Juju's fw-sbp2 gives only one command at a time to the target.
> Mainline's sbp2 can optionally give more commands in a row, but the
> implementation is subtly broken in several ways and therefore disabled
> by default until I fix it right after hell froze over.)
> 
> Another important thing to know in order to understand fw-sbp2 and sbp2
> is that they currently rely on OHCI-1394's physical DMA feature, which
> I'll not explain here. It means two things: 1. FireWire bus addresses of
> ORBs and buffers are directly derived from the DMA mapped address.
> (FireWire bus addresses are the addresses used in communication between
> SBP-2 initiator and target.) 2. Almost all of the transfers done by the
> target do not generate interrupts. (Just the status write generates an
> interrupt.)

Another thing that probably makes my explanation a little confusing is that 
there are two types of transactions: FireWire transactions which consists of a 
  request followed by a response and are pretty much the smallest interaction 
you can have with a remote device.  Then there are SBP-2 transactions, which 
are a higer level sequence layered on top of FireWire transactions.  An SBP-2 
transaction consists of a sequence of FireWire transactions, the first of 
which is initiated by the initiator.  This is the FireWire transaction that 
complete_transaction handles.  When this first FireWire transaction finishes 
succesfully, we know that the SBP-2 transaction has been started and we sit 
back and wait for the target to do it's part.  If that initial FireWire 
transaction fails, we need to fail the SBP-2 transaction we we're trying to start.

> ...
>> Now that you drew my attention to sbp2_status_write(), this looks wrong:
>>
>>         /* Lookup the orb corresponding to this status write. */
>>         spin_lock_irqsave(&card->lock, flags);
>>         list_for_each_entry(orb, &sd->orb_list, link) {
>>                 if (status_get_orb_high(status) == 0 &&
>>                     status_get_orb_low(status) == orb->request_bus) {
>>                         list_del(&orb->link);
>>                         break;
>>                 }
>>         }
>>         spin_unlock_irqrestore(&card->lock, flags);
>>
>> Why is it that fw_request can't carry a pointer?
> 
> The target wrote an SBP-2 status block into our memory. The status block
> contains the FireWire bus address of the ORB to which it belongs. Juju's
> fw-sbp2 does the same as mainline's sbp2: Looking through the pile of
> unfinished ORBs for one with the same FireWire bus address, which was
> previously derived from the DMA mapped address.

But the status write actually does carry the address of the ORB it signals the 
completion of.  So in theory, we could just read out the ORB address from the 
status write packet and map that back to kernel virtual memory and do an 
appropriate container_of() call and we should have the struct sbp2_orb 
pointer.  The reason I still search through the list is of course that this is 
way to much trust to put into hardware as buggy as external storage devices. 
Blindly dereferencing a pointer returned by storage driver firmware is 
probably a very bad idea.

One thing I want to do (though very low priority) is to allocate the ORBs out 
of a preallocated circular buffer.  We can then check that the ORB pointer 
returned in the status write points into this buffer and that it's a multiple 
of the ORB size, at which point it should be safe to dereference it.

 > Since there aren't many
> mapped ORBs per target, a linked list is a reasonable data structure to
> search over. That said --- Kristian, doesn't fw-sbp2 have at most 1 ORB
> in sd->orb_list?

Yes, there is only ever one pending ORB in the list, so looking through the 
list is not exactly a time sink :)

Kristian

