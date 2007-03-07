Return-Path: <linux-kernel-owner+w=401wt.eu-S1422809AbXCGRtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422809AbXCGRtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422806AbXCGRsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:48:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422797AbXCGRO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:57 -0500
Message-Id: <20070307171318.920039106@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 037/101] : Prevent pseudo garbage in SYNs advertized window
Content-Disposition: inline; filename=prevent-pseudo-garbage-in-syn-s-advertized-window.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

TCP may advertize up to 16-bits window in SYN packets (no window
scaling allowed). At the same time, TCP may have rcv_wnd
(32-bits) that does not fit to 16-bits without window scaling
resulting in pseudo garbage into advertized window from the
low-order bits of rcv_wnd. This can happen at least when
mss <= (1<<wscale) (see tcp_select_initial_window). This patch
fixes the handling of SYN advertized windows (compile tested
only).

In worst case (which is unlikely to occur though), the receiver
advertized window could be just couple of bytes. I'm not sure
that such situation would be handled very well at all by the
receiver!? Fortunately, the situation normalizes after the
first non-SYN ACK is received because it has the correct,
scaled window.

Alternatively, tcp_select_initial_window could be changed to
prevent too large rcv_wnd in the first place.

[ tcp_make_synack() has the same bug, and I've added a fix for
  that to this patch -DaveM ]

Signed-off-by: Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/net/ipv4/tcp_output.c
+++ linux-2.6.20.1/net/ipv4/tcp_output.c
@@ -481,7 +481,7 @@ static int tcp_transmit_skb(struct sock 
 		/* RFC1323: The window in SYN & SYN/ACK segments
 		 * is never scaled.
 		 */
-		th->window	= htons(tp->rcv_wnd);
+		th->window	= htons(min(tp->rcv_wnd, 65535U));
 	} else {
 		th->window	= htons(tcp_select_window(sk));
 	}
@@ -2160,7 +2160,7 @@ struct sk_buff * tcp_make_synack(struct 
 	}
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
-	th->window = htons(req->rcv_wnd);
+	th->window = htons(min(req->rcv_wnd, 65535U));
 
 	TCP_SKB_CB(skb)->when = tcp_time_stamp;
 	tcp_syn_build_options((__be32 *)(th + 1), dst_metric(dst, RTAX_ADVMSS), ireq->tstamp_ok,

--
