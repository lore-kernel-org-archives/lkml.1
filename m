Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZKEKH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZKEKH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZKEKH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:07:58 -0500
Received: from s2.homepagix.de ([91.199.241.131]:51837 "EHLO fry.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZKEKH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:07:57 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2009 05:07:57 EST
From: Max Kellermann <mk@cm4all.com>
Subject: [PATCH] tcp: set SPLICE_F_NONBLOCK after first buffer has been spliced
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, max@duempel.org
Date: Thu, 05 Nov 2009 10:59:50 +0100
Message-ID: <20091105095947.32131.99768.stgit@rabbit.intern.cm-ag>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When splicing a large amount of bytes from a TCP socket to a pipe
(more than PIPE_BUFFERS), splice() can block, even though the pipe was
empty.  The correct behavior would be to copy as much as possible, and
return without blocking.  Block only if nothing can be transferred.
When the destination pipe is (initially) writable, splice() should do
the same with or without SPLICE_F_NONBLOCK.

The cause is the loop in tcp_splice_read(): it calls
__tcp_splice_read() (and thus skb_splice_bits() and splice_to_pipe())
again and again, until the requested number of bytes has been
transferred, or an error occurs.  In the first iteration, up to 64 kB
is copied, and the second iteration will block, because
splice_to_pipe() is called again and sees the pipe is already full.

This patch adds SPLICE_F_NONBLOCK to the splice flags after the first
iteration has finished successfully.  This prevents the second
splice_to_pipe() call from blocking.  The resulting EAGAIN error is
handled gracefully, and tcp_splice_read() returns the number of bytes
successfully moved.
---

 net/ipv4/tcp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9114524..0f8b01f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -628,6 +628,11 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
 		    signal_pending(current))
 			break;
+
+		/* the following splice_to_pipe() calls should not
+		   block, because we have already successfully
+		   transferred at least one buffer */
+		tss.flags |= SPLICE_F_NONBLOCK;
 	}
 
 	release_sock(sk);

