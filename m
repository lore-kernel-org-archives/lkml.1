Return-Path: <linux-kernel-owner+w=401wt.eu-S1762905AbYFNAV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762905AbYFNAV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761780AbYFNAOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:19 -0400
Received: from mail.suse.de ([195.135.220.2]:34448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761735AbYFNAOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:17 -0400
Date: Fri, 13 Jun 2008 17:11:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, John Heffner <johnwheffner@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 27/47] tcp: Limit cwnd growth when deferring for GSO
Message-ID: <20080614001134.GA24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-limit-cwnd-growth-when-deferring-for-gso.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: John Heffner <johnwheffner@gmail.com>

[ upstream commit: 246eb2af060fc32650f07203c02bdc0456ad76c7 ]

This fixes inappropriately large cwnd growth on sender-limited flows
when GSO is enabled, limiting cwnd growth to 64k.

[ Backport to 2.6.25 by replacing sk->sk_gso_max_size with 65536 -DaveM ]

Signed-off-by: John Heffner <johnwheffner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_cong.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -287,7 +287,8 @@ int tcp_is_cwnd_limited(const struct soc
 
 	left = tp->snd_cwnd - in_flight;
 	if (sk_can_gso(sk) &&
-	    left * sysctl_tcp_tso_win_divisor < tp->snd_cwnd)
+	    left * sysctl_tcp_tso_win_divisor < tp->snd_cwnd &&
+	    left * tp->mss_cache < 65536)
 		return 1;
 	return left <= tcp_max_burst(tp);
 }

-- 
