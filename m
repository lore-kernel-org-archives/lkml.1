Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbXJEMUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbXJEMUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbXJEMUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:20:46 -0400
Received: from guri.is.scarlet.be ([193.74.71.22]:34200 "EHLO
	guri.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbXJEMUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:20:45 -0400
X-Greylist: delayed 13694 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2007 08:20:44 EDT
Message-ID: <4705F658.1050106@joow.be>
Date: Fri, 05 Oct 2007 10:31:20 +0200
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@bitplanet.net>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       =?UTF-8?B?S3Jpc3RpYW4gSMO4?= =?UTF-8?B?Z3NiZXJn?= 
	<krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: adopt read cycle timer ABI from raw1394
References: <tkrat.9b780b2f580f1733@s5r6.in-berlin.de>	 <tkrat.4aa1f1b5ce7df936@s5r6.in-berlin.de> <4700BE87.2040107@joow.be> <59ad55d30710010903y76330624ka45747c0b5983cfd@mail.gmail.com>
In-Reply-To: <59ad55d30710010903y76330624ka45747c0b5983cfd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DCC-scarlet.be-Metrics: guri 20001; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> On 10/1/07, Pieter Palmers <pieterp@joow.be> wrote:
>> Stefan Richter wrote:
>>>> This duplicates the read cycle timer feature of raw1394 (added in Linux
>>>> 2.6.21) in firewire-core's userspace ABI.
>>> Kristian and Pieter, does this simple duplication of the ioctl make
>>> sense on its own?  AFAIU rawiso's iso packet buffers look different from
>>> fw-cdevs's. It seems to me as if rawiso always put the cycle into a user
>>> buffer for each iso packet received...
>>>
>>> raw1394.h::struct raw1394_iso_packet_info {
>>>       __u32 offset;
>>>       __u16 len;
>>>       __u16 cycle;   /* recv only */
>>>       __u8  channel; /* recv only */
>>>       __u8  tag;
>>>       __u8  sy;
>>> };
>>>
>>> raw1394.c::raw1394_iso_recv_packets()
>>>
>>>       /* copy the packet_infos out */
>>>       for (i = 0; i < upackets.n_packets; i++) {
>>>               if (__copy_to_user(&upackets.infos[i],
>>>                                  &fi->iso_handle->infos[packet],
>>>                                  sizeof(struct raw1394_iso_packet_info)))
>>>                       return -EFAULT;
>>>
>>>               packet = (packet + 1) % fi->iso_handle->buf_packets;
>>>       }
>>>
>>> ...while the Juju ABI returns the cycle only for those packets whose
>>> fw_cdev_iso_packet.control had the FW_CDEV_ISO_INTERRUPT flag set.
>>> The cycle is then written out in the fw_cdev_event_iso_interrupt event
>>> which happens when this particular packet was received.  Right?
>>>
>>> Pieter, do applications like yours need the cycle counter only for a few
>>> predetermined packets or for each and every packet?
>> We need it for every packet for two reasons:
>> 1) it's the only way to determine how many packets were dropped when
>> packet drops are flagged in the callback
> 
> Your application should know what the timestamp should be for each iso
> receive callback and if you see a larger value than expected you can
> use that to calculate how many cycles were lost.
I'm not convinced here. It's rather easy to come up with a scenario 
where more than 16 packets are lost, hence the timestamp wraps around 
and you have the impression that no packets are lost. Losing 16 packets 
is a serious issue in streaming audio, so we definitely have to be able 
to detect this.

The point is that currently we use the cycle value for every callback 
since that's how the libraw API is defined. So if our current code is 
supposed to work with the new kernel modules through the adapted libraw 
it obviously has to provide the cycle parameter for every callback. 
Therefore I suppose the discussion is about a new API that is being 
designed.

> 
>> 2) we convert the 16-bit SYT timestamp of a packet to a full 32-bit
>> cycle counter value. This because the range of the 16-bit SYT is too
>> small (only 16 packets) for systems that have large buffering.
> 
> If you get the timestamp for the first packet in a receive batch, you
> can still do this, right?

If we can calculate the cycle a packet is received on one way or 
another, we are ok. So whether this is done by receiving a cycle value 
for each packet, or having the cycle for the first packet in a batch and 
then using offset calculations it is ok. The only precondition for this 
is that a batch should be continuous, i.e. there should not be any 
missing packets in a batch. Only between batches.

We will probably only be able to comment on this thoroughly once we 
start implementing the juju based streaming system. I don't see this 
happening in the next 6 months though.

Greets,

Pieter

