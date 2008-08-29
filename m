Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYH2OCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYH2OCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYH2OCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:02:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54604 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYH2OCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:02:40 -0400
Date: Fri, 29 Aug 2008 08:02:24 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
Subject: USBIP protocol
Message-ID: <20080829140224.GC1968@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm in the middle of implementing a userspace client for usbip and I
strongly feel that the protocol needs to be changed before it is merged.

 - I'm unconvinced that TCP is the correct protocol to be running this over.
   I understand the reluctance to use UDP, but the protocol is fundamentally
   packet-based.  If TCP is used, the delimitation of packets within the
   stream needs to be much more robust.  I've managed to wedge the VHCI driver
   a number of times in ways that just wouldn't be possible if we were using
   a packet protocol instead of a stream protocol.
 - Endianness.  This is a mess.  The usbip protocol is big-endian, but the
   encapsulated usb protocol is little-endian.  This doesn't matter to the
   people who are just tunnelling usb from one computer to another, but for
   someone implementing a usbip client, it's very confusing.
 - The protocol needs an officially assigned port number.  Port 3240 is 
   already assigned to Tony Matthews <tmatthews&triomotion.com> February
   2002 (see http://www.iana.org/assignments/port-numbers)
 - There are actually two completely different protocols in use.  First,
   the usbipd daemon listens on port 3240, and handles device discovery.
   When usbip successfully attaches to usbipd, both sides of the connection
   pass the socket fd into the kernel and the protocol changes.
 - The protocol sends a 48-byte packet header for every command (and every
   response).  It's cunningly hidden as a union.
   
I think the protocol would be immeasurably improved by going through the
IETF RFC process and getting feedback from networking experts.  Failing
that, I have some suggestions about how to improve it.  I was hoping to
get my client finished before I started mucking with the protocol though.

(I have some other comments on the implementation, but they're a separate
issue).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
