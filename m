Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXIZL2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXIZL2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXIZL2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:28:44 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:39449 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXIZL2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:28:43 -0400
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 07:28:43 EDT
Message-ID: <46FA3CD4.90407@packetship.com>
Date: Wed, 26 Sep 2007 12:04:52 +0100
From: Paul Clark <paul@packetship.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Semantics of SO_REUSEADDR and P2P TCP NAT traversal
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Pythagoras-IP: [217.155.80.54]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I'm working on implementing a TCP NAT traversal scheme for a P2P
application, similar to that described in:

   http://www.brynosaurus.com/pub/net/p2pnat/

and also in

   http://tools.ietf.org/html/draft-ietf-behave-p2p-state-03 [3.4]

The idea in using TCP is to provide a P2P file transfer architecture
which retains the benefits of TCP's windowing and congestion control and
hence is more efficient and network-friendly than the current UDP-based
ones.

NAT 'hole punching' for TCP essentially depends on the two peers
more-or-less simultaneously opening mirrored connections to each other,
and hoping that the intervening NATs' 'conntrack'-equivalents will allow
the SYN exchange.  If the connections are _really_ simultaneous, so that
the SYNs cross on the wire, this might also trigger a simultaneous-open
transition on the peers.

To make this work, the peers have to both be initiating from the same
port they are listening on, so that their SYNs match.  This would
apparently break the "4-tuples uniquely identify a socket" rule at each
end, but this is transient - only one of the two sockets at each end
will end up connected.

Ford et al. say in the above paper that the main issue with implementing
this through the BSD sockets API is the ability to have both a
listen()ing socket and an outgoing connection bound to the same local
port, but that SO_REUSEADDR (and SO_REUSEPORT, where defined) comes to
our rescue.  However my initial implementation of this fails with
EADDRINUSE (simplified psuedo-code):

==
   fd_listen = socket(PF_INET, SOCK_STREAM, 0)
   setsockopt(fd_listen, SOL_SOCKET, SO_REUSEADDR, 1)
   bind(fd_listen, sockaddr_in(127.0.0.1, 11111))
   listen(fd_listen)

   fd_out = socket(PF_INET, SOCK_STREAM, 0)
   setsockopt(fd_out, SOL_SOCKET, SO_REUSEADDR, 1)
   bind(fd_out, socketaddr_in(127.0.0.1, 11111))     => EADDRINUSE
==

Just to note, it also fails in the same way with INADDR_ANY or a real
interface IP in either bind().

However, if I bind() the outgoing socket first, it is OK:

==
   fd_out = socket(PF_INET, SOCK_STREAM, 0)
   setsockopt(fd_out, SOL_SOCKET, SO_REUSEADDR, 1)
   bind(fd_out, socketaddr_in(127.0.0.1, 11111))

   fd_listen = socket(PF_INET, SOCK_STREAM, 0)
   setsockopt(fd_listen, SOL_SOCKET, SO_REUSEADDR, 1)
   bind(fd_listen, sockaddr_in(127.0.0.1, 11111))          // OK
   listen(fd_listen)                                       // OK
==

Looking at the kernel code in net/ipv4/inet_connection_sock.c,
inet_csk_bind_conflict() and inet_csk_get_port(), this is to be expected
- the duplicate bind() only conflicts if there is _already_ a TCP_LISTEN
socket bound.  I guess the intention was to prevent hijacking of
existing listen() sockets, as was discussed when this subject last came
up, in a very similar context:

   http://uwsg.iu.edu/hypermail/linux/kernel/0102.0/0214.html

However, the order-dependent behaviour, breaks rule (2) expressed in
include/ipv4/inet_hashtables.c, assuming you read it as an invariant,
rather than a precondition:

*  2) If all sockets have sk->sk_reuse set, and none of them are in
*     TCP_LISTEN state, the port may be shared.

If you look a Bryan Ford's NAT test code at

   http://midcom-p2p.sourceforge.net/natcheck.c

you'll see that he also bind()s all his sockets before listen()ing,
which I guess is why it works.  It is possible to use the
bind-outgoing-before-listening variety in simple tests like these, but
for a real application one would ideally want the listen() socket nailed
up permanently and be able to create new outgoing sockets to the
rendevous server or peers at will.  I guess it might be possible to
create a pool of bound outgoing sockets and then the listen(), and tear
down and restart everything when the pool runs out, but that seems
pretty messy.

So, at the end of all this, I have two questions:

(1) Given there is a valid use of this for TCP hole punching, should not
the rule be - as suggested by Paul D. Smith in the post above - that you
cannot have two listen()s on the same port, rather than (as now) one
listen() and any other bind()?  Apparently this is the semantics of
Solaris, FreeBSD and Windows, but I have not verified this...  I noted
AC's objection around NFS at the time, but that seems to apply only to
UDP, and these rules are specific to TCP state - UDP could remain
stricter, if required.

(2) The current order-dependent behaviour seems inconsistent with the
implied invariant rule that a listen() is exclusive on that port.  We
could make use of the present behaviour, but it feels like a bit of a
hack, and of course the worry is that the inconsistency might be 'fixed'
at some point in the future.  Do people consider this a bug, or a
feature that is likely to be preserved?  (I hope at least if anyone
thinks about fixing this, they may discover there someone using it!)

CC's helpful, but I will read list replies.

Many thanks

Paul
-- 
Paul Clark
Packet Ship Technologies Limited
www.packetship.com










