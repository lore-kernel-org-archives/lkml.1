Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbXKNPYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbXKNPYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbXKNPY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:24:28 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:46300 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbXKNPY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ez/8Yb30yne+T7vH7S1hE79PP00b5JLITjXty+80rvjyA/zKVCG7HKwufn3aDQi2svSd4+btqeOrsgunuc9XCgG6AT5gnnB3OfS+FXk9ID7j1sVkuCY7ZcScw4DAVOmDvMvToCkMlq+/9DmNuBpWTAykSy7weqpqFGehx104cVc=
Message-ID: <cac0ab7d0711140724i5019d72byb1b34156788897b9@mail.gmail.com>
Date: Wed, 14 Nov 2007 16:24:25 +0100
From: "Jonas Danielsson" <the.sator@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Strange behavior in arp probe reply, bug or feature?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was working on a project that involved having our dhcp-client
performing a check on the offered IP-address to make sure it wasn't in
use.
The standard way of doing this is sending out an arp request with the
sender ip set to 0. (RFC2131).

When I was testing out my implemented solution I noticed that my linux
machines responded a bit odd to this arp-request.
The arp-reply had the sender-ip field set to the same as the target-ip
field and the target-hwaddr field the same as the sender-hwaddr field.
All the values where the addresses of the machine replying to the request.
This is not a standard arp way of replying.

I checked the code in net/ipv4/arp.c and found this:

/* Special case: IPv4 duplicate address detection packet (RFC2131) */
       if (sip == 0) {
               if (arp->ar_op == __constant_htons(ARPOP_REQUEST) &&
                   inet_addr_type(tip) == RTN_LOCAL)
                      arp_send(ARPOP_REPLY,ETH_P_ARP

,tip,dev,tip,sha,dev->dev_addr,dev->dev_addr);
               goto out;
       }

This code will implement the strange behavior mentioned above.

I checked the arp-request against a box running Windows XP and one
running OpenBSD, none of them had this strange beahvior, but rather
replied in a way that
I expected to see, with the requesting machines mac in the target
hw-addr field and 0.0.0.0 in the target ip field.

The linux boxes I tested against ran the 2.16.18 and the 2.16.22
kernel and the code above is still used in the 2.16.23-1 kernel.

I changed the code above on one of them to have the arp_send called in
a "normal" way:

arp_send(ARPOP_REPLY,ETH_P_ARP,sip,dev,tip,sha,dev->dev_addr,sha);

After the change the replies looked like the ones I was receiving from
the OpenBSD and Windows-box.

The comment above the code mention the RFC2131, but there is no
mention, that I can see to this construction of the reply. I can only
see the specification of setting the sender ip to 0.
I can't understand the need for this strange way of constructing an
arp-reply packet. Is this a feature or a bug?

Regards
