Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbXJAQDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbXJAQDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXJAQD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:03:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:54439 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbXJAQDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fo7h9qH3702kCGRoBxzmu5kUKaFhESTjQwfa4FK+CsoEh1cXgEaGuDseXhU7AVezczB/DNzGazntT9mta9+bc86PYdHjCqwU5ifnqJFofbgF5f2ppfcv3lJ7LqLjlRAskIzkx0PqQwf/yAwDn28BTXiuLGbt4Slex3tD5rM51pA=
Message-ID: <59ad55d30710010903y76330624ka45747c0b5983cfd@mail.gmail.com>
Date: Mon, 1 Oct 2007 12:03:23 -0400
From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
To: "Pieter Palmers" <pieterp@joow.be>
Subject: Re: [PATCH] firewire: adopt read cycle timer ABI from raw1394
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4700BE87.2040107@joow.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <tkrat.9b780b2f580f1733@s5r6.in-berlin.de>
	 <tkrat.4aa1f1b5ce7df936@s5r6.in-berlin.de> <4700BE87.2040107@joow.be>
X-Google-Sender-Auth: 6fb7f3c2a53faea2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/07, Pieter Palmers <pieterp@joow.be> wrote:
> Stefan Richter wrote:
> >> This duplicates the read cycle timer feature of raw1394 (added in Linux
> >> 2.6.21) in firewire-core's userspace ABI.
> >
> > Kristian and Pieter, does this simple duplication of the ioctl make
> > sense on its own?  AFAIU rawiso's iso packet buffers look different from
> > fw-cdevs's. It seems to me as if rawiso always put the cycle into a user
> > buffer for each iso packet received...
> >
> > raw1394.h::struct raw1394_iso_packet_info {
> >       __u32 offset;
> >       __u16 len;
> >       __u16 cycle;   /* recv only */
> >       __u8  channel; /* recv only */
> >       __u8  tag;
> >       __u8  sy;
> > };
> >
> > raw1394.c::raw1394_iso_recv_packets()
> >
> >       /* copy the packet_infos out */
> >       for (i = 0; i < upackets.n_packets; i++) {
> >               if (__copy_to_user(&upackets.infos[i],
> >                                  &fi->iso_handle->infos[packet],
> >                                  sizeof(struct raw1394_iso_packet_info)))
> >                       return -EFAULT;
> >
> >               packet = (packet + 1) % fi->iso_handle->buf_packets;
> >       }
> >
> > ...while the Juju ABI returns the cycle only for those packets whose
> > fw_cdev_iso_packet.control had the FW_CDEV_ISO_INTERRUPT flag set.
> > The cycle is then written out in the fw_cdev_event_iso_interrupt event
> > which happens when this particular packet was received.  Right?
> >
> > Pieter, do applications like yours need the cycle counter only for a few
> > predetermined packets or for each and every packet?
>
> We need it for every packet for two reasons:
> 1) it's the only way to determine how many packets were dropped when
> packet drops are flagged in the callback

Your application should know what the timestamp should be for each iso
receive callback and if you see a larger value than expected you can
use that to calculate how many cycles were lost.

> 2) we convert the 16-bit SYT timestamp of a packet to a full 32-bit
> cycle counter value. This because the range of the 16-bit SYT is too
> small (only 16 packets) for systems that have large buffering.

If you get the timestamp for the first packet in a receive batch, you
can still do this, right?

cheers,
Kristian
