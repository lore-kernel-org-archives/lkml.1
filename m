Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZFJDh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZFJDh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbZFJDeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:34:10 -0400
Received: from kroah.org ([198.145.64.141]:56772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbZFJDeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:34:08 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:43 2009
Message-Id: <20090610002343.394722213@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:44 -0700
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
       alan@lxorguk.ukuu.org.uk, Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 16/60] tcp: fix >2 iw selection
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=tcp-fix-2-iw-selection.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>

[ Upstream commit 86bcebafc5e7f5163ccf828792fe694b112ed6fa ]

A long-standing feature in tcp_init_metrics() is such that
any of its goto reset prevents call to tcp_init_cwnd().

Signed-off-by: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -931,6 +931,8 @@ static void tcp_init_metrics(struct sock
 	tcp_bound_rto(sk);
 	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
 		goto reset;
+
+cwnd:
 	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
 	tp->snd_cwnd_stamp = tcp_time_stamp;
 	return;
@@ -945,6 +947,7 @@ reset:
 		tp->mdev = tp->mdev_max = tp->rttvar = TCP_TIMEOUT_INIT;
 		inet_csk(sk)->icsk_rto = TCP_TIMEOUT_INIT;
 	}
+	goto cwnd;
 }
 
 static void tcp_update_reordering(struct sock *sk, const int metric,


