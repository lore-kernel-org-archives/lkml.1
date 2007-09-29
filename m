Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbXI2JCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbXI2JCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbXI2JCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:02:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50476 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098AbXI2JCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:02:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 29 Sep 2007 11:01:51 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: adopt read cycle timer ABI from raw1394
To: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Pieter Palmers <pieterp@joow.be>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.9b780b2f580f1733@s5r6.in-berlin.de>
Message-ID: <tkrat.4aa1f1b5ce7df936@s5r6.in-berlin.de>
References: <tkrat.9b780b2f580f1733@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This duplicates the read cycle timer feature of raw1394 (added in Linux
> 2.6.21) in firewire-core's userspace ABI.

Kristian and Pieter, does this simple duplication of the ioctl make
sense on its own?  AFAIU rawiso's iso packet buffers look different from
fw-cdevs's. It seems to me as if rawiso always put the cycle into a user
buffer for each iso packet received...

raw1394.h::struct raw1394_iso_packet_info {
	__u32 offset;
	__u16 len;
	__u16 cycle;   /* recv only */
	__u8  channel; /* recv only */
	__u8  tag;
	__u8  sy;
};

raw1394.c::raw1394_iso_recv_packets()

	/* copy the packet_infos out */
	for (i = 0; i < upackets.n_packets; i++) {
		if (__copy_to_user(&upackets.infos[i],
				   &fi->iso_handle->infos[packet],
				   sizeof(struct raw1394_iso_packet_info)))
			return -EFAULT;

		packet = (packet + 1) % fi->iso_handle->buf_packets;
	}

...while the Juju ABI returns the cycle only for those packets whose
fw_cdev_iso_packet.control had the FW_CDEV_ISO_INTERRUPT flag set.
The cycle is then written out in the fw_cdev_event_iso_interrupt event
which happens when this particular packet was received.  Right?

Pieter, do applications like yours need the cycle counter only for a few
predetermined packets or for each and every packet?
-- 
Stefan Richter
-=====-=-=== =--= ===-=
http://arcgraph.de/sr/

