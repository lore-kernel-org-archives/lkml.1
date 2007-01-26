Return-Path: <linux-kernel-owner+w=401wt.eu-S1030708AbXAZCff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030708AbXAZCff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030710AbXAZCff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:35:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50401 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030708AbXAZCfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:35:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45B968E7.1070402@s5r6.in-berlin.de>
Date: Fri, 26 Jan 2007 03:35:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Juju
References: <20070124223745.33278eb4.zaitcev@redhat.com>	<45B91EAB.9080004@redhat.com> <20070125153824.8d7f50c5.zaitcev@redhat.com>
In-Reply-To: <20070125153824.8d7f50c5.zaitcev@redhat.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:
> On Thu, 25 Jan 2007 16:18:35 -0500, Kristian Høgsberg <krh@redhat.com> wrote:
...
>> will do a status write to the status address specified in the ORB, at which 
>> point the SBP-2 transaction is complete.
> 
> You know, I wanted to use this picture for a long time:
>  http://www.flickr.com/photos/zaitcev/369269557/

The fundamental thing about SBP-2 is that ORBs ( = SCSI command blocks
plus SBP-2 header) and data buffers all reside in the memory of the
initiator (or of a 3rd party on the FireWire bus). The target peeks and
pokes them when and how it sees fit. The initiator pushes only tiny
notifications about availability of new ORBs to the target. The target
eventually completes SCSI commands in-order or out-of-order and signals
so by pushing a status block per one or more completed commands.

(Juju's fw-sbp2 gives only one command at a time to the target.
Mainline's sbp2 can optionally give more commands in a row, but the
implementation is subtly broken in several ways and therefore disabled
by default until I fix it right after hell froze over.)

Another important thing to know in order to understand fw-sbp2 and sbp2
is that they currently rely on OHCI-1394's physical DMA feature, which
I'll not explain here. It means two things: 1. FireWire bus addresses of
ORBs and buffers are directly derived from the DMA mapped address.
(FireWire bus addresses are the addresses used in communication between
SBP-2 initiator and target.) 2. Almost all of the transfers done by the
target do not generate interrupts. (Just the status write generates an
interrupt.)

...
> Now that you drew my attention to sbp2_status_write(), this looks wrong:
> 
>         /* Lookup the orb corresponding to this status write. */
>         spin_lock_irqsave(&card->lock, flags);
>         list_for_each_entry(orb, &sd->orb_list, link) {
>                 if (status_get_orb_high(status) == 0 &&
>                     status_get_orb_low(status) == orb->request_bus) {
>                         list_del(&orb->link);
>                         break;
>                 }
>         }
>         spin_unlock_irqrestore(&card->lock, flags);
> 
> Why is it that fw_request can't carry a pointer?

The target wrote an SBP-2 status block into our memory. The status block
contains the FireWire bus address of the ORB to which it belongs. Juju's
fw-sbp2 does the same as mainline's sbp2: Looking through the pile of
unfinished ORBs for one with the same FireWire bus address, which was
previously derived from the DMA mapped address. Since there aren't many
mapped ORBs per target, a linked list is a reasonable data structure to
search over. That said --- Kristian, doesn't fw-sbp2 have at most 1 ORB
in sd->orb_list?
-- 
Stefan Richter
-=====-=-=== ---= ==-=-
http://arcgraph.de/sr/
