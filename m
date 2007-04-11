Return-Path: <linux-kernel-owner+w=401wt.eu-S1161348AbXDKXA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161348AbXDKXA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161372AbXDKWzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:55:12 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55690 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369AbXDKWzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:04 -0400
Date: Wed, 11 Apr 2007 15:52:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/31] Fix TCP slow_start_after_idle sysctl
Message-ID: <20070411225226.GU24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tcp-slow_start_after_idle-sysctl.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Miller <davem@davemloft.net>

[TCP]: slow_start_after_idle should influence cwnd validation too

For the cases that slow_start_after_idle are meant to deal
with, it is almost a certainty that the congestion window
tests will think the connection is application limited and
we'll thus decrease the cwnd there too.  This defeats the
whole point of setting slow_start_after_idle to zero.

So test it there too.

We do not cancel out the entire tcp_cwnd_validate() function
so that if the sysctl is changed we still have the validation
state maintained.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -943,7 +943,8 @@ static void tcp_cwnd_validate(struct soc
 		if (tp->packets_out > tp->snd_cwnd_used)
 			tp->snd_cwnd_used = tp->packets_out;
 
-		if ((s32)(tcp_time_stamp - tp->snd_cwnd_stamp) >= inet_csk(sk)->icsk_rto)
+		if (sysctl_tcp_slow_start_after_idle &&
+		    (s32)(tcp_time_stamp - tp->snd_cwnd_stamp) >= inet_csk(sk)->icsk_rto)
 			tcp_cwnd_application_limited(sk);
 	}
 }

-- 
