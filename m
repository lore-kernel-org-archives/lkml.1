Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYKDXmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYKDXmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbYKDXiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:23 -0500
Received: from mail.suse.de ([195.135.220.2]:47360 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259AbYKDXiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:22 -0500
Date: Tue, 4 Nov 2008 15:31:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Florian Westphal <fw@strlen.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/57] syncookies: fix inclusion of tcp options in syn-ack
Message-ID: <20081104233126.GO659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-syncookies-fix-inclusion-of-tcp-options-in-syn-ack.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Florian Westphal <fw@strlen.de>

[ Upstream commit 8b5f12d04b2e93842f3dda01f029842047bf3f81 ]

David Miller noticed that commit
33ad798c924b4a1afad3593f2796d465040aadd5 '(tcp: options clean up')
did not move the req->cookie_ts check.
This essentially disabled commit 4dfc2817025965a2fc78a18c50f540736a6b5c24
'[Syncookies]: Add support for TCP options via timestamps.'.

This restores the original logic.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_output.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2266,6 +2266,11 @@ struct sk_buff *tcp_make_synack(struct s
 	}
 
 	memset(&opts, 0, sizeof(opts));
+#ifdef CONFIG_SYN_COOKIES
+	if (unlikely(req->cookie_ts))
+		TCP_SKB_CB(skb)->when = cookie_init_timestamp(req);
+	else
+#endif
 	TCP_SKB_CB(skb)->when = tcp_time_stamp;
 	tcp_header_size = tcp_synack_options(sk, req,
 					     dst_metric(dst, RTAX_ADVMSS),
@@ -2292,11 +2297,6 @@ struct sk_buff *tcp_make_synack(struct s
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rcv_wnd, 65535U));
-#ifdef CONFIG_SYN_COOKIES
-	if (unlikely(req->cookie_ts))
-		TCP_SKB_CB(skb)->when = cookie_init_timestamp(req);
-	else
-#endif
 	tcp_options_write((__be32 *)(th + 1), tp, &opts, &md5_hash_location);
 	th->doff = (tcp_header_size >> 2);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);

-- 
