Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZDYO1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZDYO1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 10:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZDYO1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 10:27:41 -0400
Received: from kuber.nabble.com ([216.139.236.158]:35184 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZDYO1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 10:27:41 -0400
Message-ID: <23232689.post@talk.nabble.com>
Date: Sat, 25 Apr 2009 07:27:40 -0700 (PDT)
From: nbj <niraj.b.jain@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Query regarding IPv6 stack modification
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: niraj.b.jain@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am facing a strange problem when adding a module in the ipv6 stack. (This
is a part of my project on IPv4 to IPv6 Gateway)
Here is the description:

Whenever the IPv6 machine intends to communicate with an IPv4 machine, an
extension header is being added(which contains the IPv4 address) and the
destination address in the packet is replaced by the address of the gateway.
This is done by modifying the address in the sk_buff structure.
On receiving a packet from this gateway, I check for the presence of the
extension header. If present, the IPv4 address is extracted from it and the
source address (that of the gateway) replaced by the mapped address of the
v4 machine.   

Changes have been made in the following functions for the purpose:  

ip6_xmit & ip6_push_pending_frames: These functions are called in the
transmit path of the packet. These functions are used by TCP and UDP/ICMP
respectively to serve similar purpose.
--I am adding my own extension header (called SHIM header) in the packet at
this point. This is done by making changes in the "ipv6_txoptions" structure
to add another field for my custom extension header. I am adding the IP
address of the IPv4 host in the extension header (this will be used by the
translator).
--After adding this extension header, I am replacing the destination address
in sk_buff with the translator's address.

ip6_input_finish:- This function is called in the receive path of the
packet. It calls the protocol handler for all the extension headers and the
higher layer protocol.
--I have written a handler for our custom header (SHIM) which gets called
here whenever the packet contains one. This handler replaces the source
address (which would be that of the translator) with the mapped address of
the IPv4 host as extracted from the SHIM header.

Using the above, I have tested TCP, UDP and ICMP applications. For UDP and
ICMP (ping) applications, everything works as expected. i.e., the
applications uses mapped addresses for the IPv4 hosts and the actual
communication happens with the translator's address.
For TCP however it failed in the following scenario:
I have apache server running on the IPv6 host and IPv4 host trying to access
a web page (using mozilla). Initially the IPv4 host is able to access data
from the web server. But when a FIN-ACK is sent from the TCP server and a
FIN-ACK is obtained from the client, the IPv6 machine hangs. 
(I also tried testing this using some simple client-server socket program.
In that case, everything works fine)

-- 
View this message in context: http://www.nabble.com/Query-regarding-IPv6-stack-modification-tp23232689p23232689.html
Sent from the linux-kernel mailing list archive at Nabble.com.

