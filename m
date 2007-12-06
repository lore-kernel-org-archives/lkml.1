Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXLFTui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXLFTui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXLFTuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:50:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:40189 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbXLFTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NHwc61XR5JND7vhKcBiH1NUUgc6QdvqnkZb9p6p5rY8HuxvY5A1sxxpdgH31jJ3VGWNtFL8J4aS1AZq30fccbWmEBhrGAygkFy5na6dFeeQCbN7L2DWEDg+R4LWr/R/BOgMkdP9CF+gGgfLu2GAgqyBbjnsd0xorcO5F90c6hkw=
Message-ID: <ea50169d0712061150h6c732fben99821e4b6222a4b6@mail.gmail.com>
Date: Thu, 6 Dec 2007 14:50:14 -0500
From: "Ken Simon" <ninkendo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: klibc ipconfig misbehavior in a network with DHCP snooping
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(H. Peter Anvin was CC'd in the original message, but the lkml mailer
rejected it because of an html subpart... sorry)

Bear with me, because I'm no DHCP expert, nor any sort of kernel/networking
expert in any sense. (This is actually my first post to the lkml or to any
kernel developer.)

I found a problem with klibc's "ipconfig" program, or at least, behavior
that breaks DHCP on my thin clients (LTSP 5.0). It has to do with setting
the giaddr field on dhcp_send in dhcp_proto.c, line 164.

[snip]
static int dhcp_send(struct netdev *dev, struct iovec *vec)
{
 struct bootp_hdr bootp;

 memset(&bootp, 0, sizeof(struct bootp_hdr));

 bootp.op = BOOTP_REQUEST;
 bootp.htype = dev->hwtype;
 bootp.hlen = dev->hwlen;
 bootp.xid = dev->bootp.xid;
 bootp.ciaddr = dev->ip_addr;
 bootp.giaddr = dev-> bootp.gateway; //<-- HERE
 bootp.secs = htons(time(NULL) - dev->open_time);
 memcpy(bootp.chaddr, dev->hwaddr, 16);
...
[/snip]

I'm not sure why the giaddr field should be set on a DHCP request, but it
causes a Cisco relay agent with DHCP snooping turned on to drop the
request. I know ipconfig has options to both manually set a gateway and
configure the interface via dhcp, but IMO it shouldn't be sending it as part
of the DHCPREQUEST packet.

When I went to Cisco about the issue, this is exactly what they explained:

[QUOTE]
This looks like the thin client is not following the standards for DHCP
relay information specified in RFC3046. This RFC states the following:

A DHCP relay agent may receive a client DHCP packet forwarded from a
 BOOTP/DHCP relay agent closer to the client. Such a packet will have
 giaddr as non-zero, and may or may not already have a DHCP Relay
 Agent option in it.

 ***Relay agents configured to add a Relay Agent option which receive a
 client DHCP packet with a nonzero giaddr SHALL discard the packet if
 the giaddr spoofs a giaddr address implemented by the local agent
 itself.***

 Otherwise, the relay agent SHALL forward any received DHCP packet
 with a valid non-zero giaddr WITHOUT adding any relay agent options.
 Per RFC 2131 <
;http://www.faqs.org/rfcs /rfc2131.html>, it shall also NOT modify the
giaddr value.

The part that I highlighted specifies that a relay agent should discard
the packet if the giaddr address is spoofs a giaddr address implemented
by the relay agent. This appears to be the case due to the fact that
the DHCP request packet has a giaddr address of the relay agent
specified in the DHCP offer.
[/QUOTE]

Now, when I changed the noted line above to:

bootp.giaddr = INADDR_ANY;

then recompile, and rebuild my initrd, the relay agent forwards the DHCP
request just fine.

Can anyone comment on why giaddr needs to be set on a DHCP request? Is this
a simple bug, or is there something deeper going on here?

-- 
Ken
