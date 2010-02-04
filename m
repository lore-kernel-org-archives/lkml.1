Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab0BDRaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:30:11 -0500
Received: from kroah.org ([198.145.64.141]:34815 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295Ab0BDRWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:07 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:13 2010
Message-Id: <20100204171513.218726173@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Octavian Purdila <opurdila@ixiacom.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [44/74] tcp: update the netstamp_needed counter when cloning sockets
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Octavian Purdila <opurdila@ixiacom.com>

[ Upstream commit 704da560c0a0120d8869187f511491a00951a1d3 ]

This fixes a netstamp_needed accounting issue when the listen socket
has SO_TIMESTAMP set:

    s = socket(AF_INET, SOCK_STREAM, 0);
    setsockopt(s, SOL_SOCKET, SO_TIMESTAMP, 1); -> netstamp_needed = 1
    bind(s, ...);
    listen(s, ...);
    s2 = accept(s, ...); -> netstamp_needed = 1
    close(s2); -> netstamp_needed = 0
    close(s); -> netstamp_needed = -1

Signed-off-by: Octavian Purdila <opurdila@ixiacom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/sock.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1181,6 +1181,10 @@ struct sock *sk_clone(const struct sock 
 
 		if (newsk->sk_prot->sockets_allocated)
 			percpu_counter_inc(newsk->sk_prot->sockets_allocated);
+
+		if (sock_flag(newsk, SOCK_TIMESTAMP) ||
+		    sock_flag(newsk, SOCK_TIMESTAMPING_RX_SOFTWARE))
+			net_enable_timestamp();
 	}
 out:
 	return newsk;


