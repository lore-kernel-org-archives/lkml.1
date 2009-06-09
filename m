Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbZFIKP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbZFIKP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759096AbZFIKPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:15:32 -0400
Received: from kroah.org ([198.145.64.141]:59661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565AbZFIKPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:15:31 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:52 2009
Message-Id: <20090609094052.767046420@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:51 -0700
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
Subject: [patch 03/87] [PATCH 03/16] tcp: fix >2 iw selection
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=tcp-fix-2-iw-selection.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

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
@@ -927,6 +927,8 @@ static void tcp_init_metrics(struct sock
 	tcp_set_rto(sk);
 	if (inet_csk(sk)->icsk_rto < TCP_TIMEOUT_INIT && !tp->rx_opt.saw_tstamp)
 		goto reset;
+
+cwnd:
 	tp->snd_cwnd = tcp_init_cwnd(tp, dst);
 	tp->snd_cwnd_stamp = tcp_time_stamp;
 	return;
@@ -941,6 +943,7 @@ reset:
 		tp->mdev = tp->mdev_max = tp->rttvar = TCP_TIMEOUT_INIT;
 		inet_csk(sk)->icsk_rto = TCP_TIMEOUT_INIT;
 	}
+	goto cwnd;
 }
 
 static void tcp_update_reordering(struct sock *sk, const int metric,


