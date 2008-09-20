Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbYITVtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbYITVtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 17:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYITVtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 17:49:11 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:59869 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751576AbYITVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 17:49:10 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Sep 2008 17:49:10 EDT
Date: Sat, 20 Sep 2008 16:42:29 -0500
From: lkml@pengaru.com
To: linux-kernel@vger.kernel.org
Subject: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20080920214229.GP2761@fc6222126.aspadmin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello lkml,

I have a need for select/poll/epoll_wait to block on sockets which have
unread data sitting in the receive buffer with a quantity less than
specified via setsockopt() w/SO_RCVLOWAT, not less than one like the
current implementation.

Upon looking at the code in net/ipv4/tcp.c it doesn't look like this
would be difficult to support.  Something along the lines of changing
the function tcp_poll() of version 2.6.26.5 from doing this:

 394                 if ((tp->rcv_nxt != tp->copied_seq) &&
 395                     (tp->urg_seq != tp->copied_seq ||
 396                      tp->rcv_nxt != tp->copied_seq + 1 ||
 397                      sock_flag(sk, SOCK_URGINLINE) || !tp->urg_data))
 398                         mask |= POLLIN | POLLRDNORM;

to this:

 394                 if ((tp->rcv_nxt != tp->copied_seq) &&
 395                     (tp->urg_seq != tp->copied_seq ||
 396                      tp->rcv_nxt > tp->copied_seq + sk->sk_rcvlowat ||
 397                      sock_flag(sk, SOCK_URGINLINE) || !tp->urg_data))
 398                         mask |= POLLIN | POLLRDNORM;


I imagine it's similarly simple for the other socket types.  Am I
missing something?  Is there a technical reason why Linux only blocks in
read/recv but not the poll with respect to the SO_RCVLOWAT setting?


For those interested the application is basically doing:

1: Wait for input on active sockets with epoll_wait()
2: Recv() data off the eventful sockets with MSG_PEEK flag, parse contents
   looking for specific keyword and value from buffer.
3: If buffer is too short call setsockopt() with SO_RCVLOWAT parameter set
   greater than what recv() with MSG_PEEK returned.

Repeat @ 1 until finding what's needed or shutdown/error/timeout.

Once the value is parsed it's used as an address to locate (with a db
lookup) a path which would be a unix domain socket for passing the
socket descriptor through.  The unrelated process at the other end needs
to accept the descriptor and use it as if no other program mucked with it
hence the MSG_PEEK magic.

As-is I must basically tie up threads in blocked recv() calls after
increasing SO_RCVLOWAT if the first recv() peek falls short.  This
solution obviously doesn't scale well.

Thanks,
Vito Caputo
