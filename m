Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbXJAKE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbXJAKE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXJAKEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:04:50 -0400
Received: from rusty.kulnet.kuleuven.ac.be ([134.58.240.42]:49215 "EHLO
	rusty.kulnet.kuleuven.ac.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200AbXJAKEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:04:49 -0400
X-Greylist: delayed 1651 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2007 06:04:49 EDT
Message-ID: <4700BE87.2040107@joow.be>
Date: Mon, 01 Oct 2007 11:31:51 +0200
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: adopt read cycle timer ABI from raw1394
References: <tkrat.9b780b2f580f1733@s5r6.in-berlin.de> <tkrat.4aa1f1b5ce7df936@s5r6.in-berlin.de>
In-Reply-To: <tkrat.4aa1f1b5ce7df936@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
>> This duplicates the read cycle timer feature of raw1394 (added in Linux
>> 2.6.21) in firewire-core's userspace ABI.
> 
> Kristian and Pieter, does this simple duplication of the ioctl make
> sense on its own?  AFAIU rawiso's iso packet buffers look different from
> fw-cdevs's. It seems to me as if rawiso always put the cycle into a user
> buffer for each iso packet received...
> 
> raw1394.h::struct raw1394_iso_packet_info {
> 	__u32 offset;
> 	__u16 len;
> 	__u16 cycle;   /* recv only */
> 	__u8  channel; /* recv only */
> 	__u8  tag;
> 	__u8  sy;
> };
> 
> raw1394.c::raw1394_iso_recv_packets()
> 
> 	/* copy the packet_infos out */
> 	for (i = 0; i < upackets.n_packets; i++) {
> 		if (__copy_to_user(&upackets.infos[i],
> 				   &fi->iso_handle->infos[packet],
> 				   sizeof(struct raw1394_iso_packet_info)))
> 			return -EFAULT;
> 
> 		packet = (packet + 1) % fi->iso_handle->buf_packets;
> 	}
> 
> ...while the Juju ABI returns the cycle only for those packets whose
> fw_cdev_iso_packet.control had the FW_CDEV_ISO_INTERRUPT flag set.
> The cycle is then written out in the fw_cdev_event_iso_interrupt event
> which happens when this particular packet was received.  Right?
> 
> Pieter, do applications like yours need the cycle counter only for a few
> predetermined packets or for each and every packet?

We need it for every packet for two reasons:
1) it's the only way to determine how many packets were dropped when 
packet drops are flagged in the callback
2) we convert the 16-bit SYT timestamp of a packet to a full 32-bit 
cycle counter value. This because the range of the 16-bit SYT is too 
small (only 16 packets) for systems that have large buffering.

In short: yes we use it for every packet.

Pieter
