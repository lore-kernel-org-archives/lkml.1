Return-Path: <linux-kernel-owner+w=401wt.eu-S965566AbXCGRCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566AbXCGRCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965412AbXCGRCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:02:19 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965381AbXCGRCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:02:17 -0500
Date: Wed, 7 Mar 2007 09:00:23 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Pekka Savola <pekkas@netcore.fi>
Cc: Chris Friesen <cfriesen@nortel.com>, David Miller <davem@davemloft.net>,
       jeremy@goop.org, ak@muc.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, ian.pratt@xensource.com,
       Christian.Limpach@cl.cam.ac.uk, netdev@vger.kernel.org, jeff@garzik.org
Subject: Re: [RFC] ARP notify option
Message-ID: <20070307090023.423b97d5@oldman>
In-Reply-To: <Pine.LNX.4.64.0703070838010.8567@netcore.fi>
References: <20070301164214.4a40bc59@freekitty>
	<45E7764A.7000100@goop.org>
	<20070301173030.754514ec@freekitty>
	<20070305.203536.92584097.davem@davemloft.net>
	<20070306105132.52c77491@freekitty>
	<45EDDA8F.5060106@nortel.com>
	<Pine.LNX.4.64.0703070838010.8567@netcore.fi>
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 08:42:39 +0200 (EET)
Pekka Savola <pekkas@netcore.fi> wrote:

> On Tue, 6 Mar 2007, Chris Friesen wrote:
> > Stephen Hemminger wrote:
> >>  +arp_notify - BOOLEAN
> >>  +	Define mode for notification of address and device changes.
> >>  +	0 - (default): do nothing
> >>  +	1 - Generate gratuitous arp replies when device is brought up
> >>  +	    or hardware address changes.
> >
> > Did you consider using gratuitous arp requests instead?  I remember reading 
> > about some hardware that updated its arp cache on gratuitous requests but not 
> > gratuitous replies.
> 
> You might be interested in taking a look at:
> 
> http://tools.ietf.org/id/draft-cheshire-ipv4-acd
> 
> There has been some follow-up discussion on this in the thread 
> starting at:
> 
> http://www1.ietf.org/mail-archive/web/int-area/current/msg00611.html
> 
> In particular, you may be interested in this comment about ARP 
> request and ARP reply for gratuitous ARP:
> 
> http://www1.ietf.org/mail-archive/web/int-area/current/msg00669.html

Looks like REQUESTS make more sense. (See below). I will
rework this patch.

5. Why are ARP Announcements performed using ARP Request packets
   and not ARP Reply packets?

   During IETF deliberation of IPv4 Address Conflict Detection from 2000
   to 2005, a question that kept being asked repeatedly was, "Shouldn't
   ARP Announcements be performed using gratuitous ARP Reply packets?"

   On the face of it, this seems reasonable.  A conventional ARP Reply
   is an answer to a question.  If in fact no question had been asked,
   then it would be reasonable to describe such a reply as gratuitous. 
   This description would seem to apply perfectly to an ARP
   Announcement: an answer to an implied question that in fact no one
   asked.

   However reasonable this may seem in principle, there are two reasons
   why in practice ARP Request packets are the better choice.  One is
   historical precedent, and the other is practicality.


Expires 11th January 2006             Cheshire                 [Page 14]

Internet Draft       IPv4 Address Conflict Detection      11th July 2005


   The historical precedent is that, as described above in Section 4,
   Gratuitous ARP is described in Stevens Networking [Ste94] as using
   ARP Request packets.  BSD Unix, Windows, Mac OS 9, Mac OS X, etc.
   all use ARP Request packets as described in Stevens.  At this stage,
   trying to mandate that they all switch to using ARP Reply packets
   would be futile.

   The practical reason is that ARP Request packets are more likely to
   work correctly with more existing ARP implementations, some of which
   may not implement RFC 826 correctly.  The Packet Reception rules in
   RFC 826 state that the opcode is the last thing to check in packet
   processing, so it really shouldn't matter, but there may be
   "creative" implementations that have different packet processing
   depending on the ar$op field, and there are several reasons why these
   are more likely to accept gratuitous ARP Requests than gratuitous ARP
   Replies:

   * An incorrect ARP implementation may expect that ARP Replies are
     only sent via unicast.  RFC 826 does not say this, but an incorrect
     implementation may assume it, and the "principle of least surprise"
     dictates that where there are two or more ways to solve a
     networking problem that are otherwise equally good, the one with
     the fewest unusual properties is the one likely to have the fewest
     interoperability problems with existing implementations.  An ARP
     Announcement needs to broadcast information to all hosts on the
     link.  Since ARP Request packets are always broadcast, and ARP
     Reply packets are not, receiving an ARP Request packet via
     broadcast is less surprising than receiving an ARP Reply packet via
     broadcast.

   * An incorrect ARP implementation may expect that ARP Replies are
     only received in response to ARP Requests that have been issued
     recently by that implementation.  Unexpected unsolicited Replies
     may be ignored.

   * An incorrect ARP implementation may ignore ARP Replies where
     ar$tha doesn't match its hardware address.

   * An incorrect ARP implementation may ignore ARP Replies where
     ar$tpa doesn't match its IP address.

   In summary, there are more ways that an incorrect ARP implementation
   might plausibly reject an ARP Reply (which usually occurs as a result
   of being solicited by the client) than an ARP Request (which is
   already expected to occur unsolicited).
