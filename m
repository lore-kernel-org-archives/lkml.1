Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbZAWBUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbZAWBUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760218AbZAWBO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:59 -0500
Received: from kroah.org ([198.145.64.141]:50531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760161AbZAWBOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:55 -0500
Date: Thu, 22 Jan 2009 17:12:06 -0800
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
       alan@lxorguk.ukuu.org.uk, Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/46] pkt_sched: sch_htb: Fix deadlock in hrtimers
	triggered by HTB
Message-ID: <20090123011206.GS19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pkt_sched-sch_htb-fix-deadlock-in-hrtimers-triggered-by-htb.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit: none

  This is a quick fix for -stable purposes.  Upstream fixes these
  problems via a large set of invasive hrtimer changes.  ]

Most probably there is a (still unproven) race in hrtimers (before
2.6.29 kernels), which causes a corruption of hrtimers rbtree. This
patch doesn't fix it, but should let HTB avoid triggering the bug.

Reported-by: Denys Fedoryschenko <denys@visp.net.lb>
Reported-by: Badalian Vyacheslav <slavon@bigtelecom.ru>
Reported-by: Chris Caputo <ccaputo@alt.net>
Tested-by: Badalian Vyacheslav <slavon@bigtelecom.ru>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_htb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -924,6 +924,7 @@ static struct sk_buff *htb_dequeue(struc
 		}
 	}
 	sch->qstats.overlimits++;
+	qdisc_watchdog_cancel(&q->watchdog);
 	qdisc_watchdog_schedule(&q->watchdog, next_event);
 fin:
 	return skb;

