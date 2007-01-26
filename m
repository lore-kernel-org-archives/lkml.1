Return-Path: <linux-kernel-owner+w=401wt.eu-S933195AbXAZLaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbXAZLaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbXAZLaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:30:11 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:48763 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195AbXAZLaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:30:10 -0500
Message-ID: <45B9E640.4040400@s5r6.in-berlin.de>
Date: Fri, 26 Jan 2007 12:30:08 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: Pete Zaitcev <zaitcev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Juju
References: <20070124223745.33278eb4.zaitcev@redhat.com>	<45B91EAB.9080004@redhat.com> <20070125153824.8d7f50c5.zaitcev@redhat.com> <45B968E7.1070402@s5r6.in-berlin.de> <45B97D28.1090404@redhat.com>
In-Reply-To: <45B97D28.1090404@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> Another thing that probably makes my explanation a little confusing is that 
> there are two types of transactions: FireWire transactions which consists of a 
>   request followed by a response and are pretty much the smallest interaction 
> you can have with a remote device.  Then there are SBP-2 transactions, which 
> are a higer level sequence layered on top of FireWire transactions.
[...]

Exactly. One SBP-2 transaction is one SCSI task's request and completion
and contains
  1. one 1394 write transaction, requested by initiator node,
  2. one 1394 read transaction, requested by the target node,
  3. zero to many 1394 read or write transactions, requested by the
     target node,
  4. one 1394 write transaction, requested by the target node
(if everything goes well and if we don't have dynamically appended ORB
lists). So it might be less confusing if we only speak of "1394
transactions" and "SCSI tasks".

BTW, SBP-3 allows to wrap step 2 into step 1. I read that some SBP-2
targets support this SBP-3 feature.

[...]
>> The target wrote an SBP-2 status block into our memory. The status block
>> contains the FireWire bus address of the ORB to which it belongs. Juju's
>> fw-sbp2 does the same as mainline's sbp2: Looking through the pile of
>> unfinished ORBs for one with the same FireWire bus address, which was
>> previously derived from the DMA mapped address.
> 
> But the status write actually does carry the address of the ORB it signals the 
> completion of.  So in theory, we could just read out the ORB address from the 
> status write packet and map that back to kernel virtual memory

"Map back to virtual memory" is exactly what we do already, although in
a rather dumb fashion. It would be easier if there was a portable
bus_to_virt() which would do the job for us. This is much more of an
issue if we want to work without OHCI-1394 physical DMA: Then we have to
do this inverse DMA mapping also for arbitrary pieces of all scatter
gather elements of the SCSI data buffer.

[...]
> One thing I want to do (though very low priority) is to allocate the ORBs out 
> of a preallocated circular buffer.

Incidentally, one thing I want to do (though at low priority) is to use
a circular ORB buffer... Well, linux1394 has a number of more serious
issues pending at bugzilla.kernel.org, and meanwhile people are eager to
run things like FreeBob or Kino on Juju --- thus it remains to be seen
who of us gets to it first. :-)
-- 
Stefan Richter
-=====-=-=== ---= ==-=-
http://arcgraph.de/sr/
