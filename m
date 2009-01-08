Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbZAHReX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbZAHReX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbZAHRd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:33:56 -0500
Received: from 1wt.eu ([62.212.114.60]:1264 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759951AbZAHRdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:33:55 -0500
Date: Thu, 8 Jan 2009 18:30:28 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Miller <davem@davemloft.net>, Jarek Poplawski <jarkao2@gmail.com>,
       Ben Mansell <ben@zeus.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090108173028.GA22531@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

here's the other patch I was talking about, for better behaviour of
non-blocking splice(). Ben Mansell also confirms similar improvements
in his tests, where non-blocking splice() initially showed half of
read()/write() performance. Ben, would you mind adding a Tested-By
line ?

Also, please note that this is unrelated to the corruption bug I reported
and does not fix it.

Regards,
Willy

>From fafe76713523c8e9767805cfdc7b73323d7bf180 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Thu, 8 Jan 2009 17:10:13 +0100
Subject: [PATCH] tcp: splice as many packets as possible at once

Currently, in non-blocking mode, tcp_splice_read() returns after
splicing one segment regardless of the len argument. This results
in low performance and very high overhead due to syscall rate when
splicing from interfaces which do not support LRO.

The fix simply consists in not breaking out of the loop after the
first read. That way, we can read up to the size requested by the
caller and still return when there is no data left.

Performance has significantly improved with this fix, with the
number of calls to splice() divided by about 20, and CPU usage
dropped from 100% to 75%.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 35bcddf..80261b4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -615,7 +615,7 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 		lock_sock(sk);
 
 		if (sk->sk_err || sk->sk_state == TCP_CLOSE ||
-		    (sk->sk_shutdown & RCV_SHUTDOWN) || !timeo ||
+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
 		    signal_pending(current))
 			break;
 	}
-- 
1.6.0.3

