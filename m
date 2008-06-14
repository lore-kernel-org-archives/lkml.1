Return-Path: <linux-kernel-owner+w=401wt.eu-S1762823AbYFNAVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762823AbYFNAVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbYFNAOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:34426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761652AbYFNAON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:13 -0400
Date: Fri, 13 Jun 2008 17:11:31 -0700
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
Subject: [patch 26/47] tcp: Allow send-limited cwnd to grow up to max_burst
	when gso disabled
Message-ID: <20080614001131.GZ24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-allow-send-limited-cwnd-to-grow-up-to-max_burst-when-gso-disabled.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: John Heffner <johnwheffner@gmail.com>

[ upstream commit: ce447eb91409225f8a488f6b7b2a1bdf7b2d884f ]

This changes the logic in tcp_is_cwnd_limited() so that cwnd may grow
up to tcp_max_burst() even when sk_can_gso() is false, or when
sysctl_tcp_tso_win_divisor != 0.

Signed-off-by: John Heffner <johnwheffner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp_cong.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -285,14 +285,11 @@ int tcp_is_cwnd_limited(const struct soc
 	if (in_flight >= tp->snd_cwnd)
 		return 1;
 
-	if (!sk_can_gso(sk))
-		return 0;
-
 	left = tp->snd_cwnd - in_flight;
-	if (sysctl_tcp_tso_win_divisor)
-		return left * sysctl_tcp_tso_win_divisor < tp->snd_cwnd;
-	else
-		return left <= tcp_max_burst(tp);
+	if (sk_can_gso(sk) &&
+	    left * sysctl_tcp_tso_win_divisor < tp->snd_cwnd)
+		return 1;
+	return left <= tcp_max_burst(tp);
 }
 EXPORT_SYMBOL_GPL(tcp_is_cwnd_limited);
 

-- 
