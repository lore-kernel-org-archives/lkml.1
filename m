Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXCSVka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXCSVka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030587AbXCSVkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:40:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:55537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944AbXCSVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:39:55 -0400
Date: Mon, 19 Mar 2007 14:38:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 06/31] NETFILTER: nfnetlink_log: fix reference counting
Message-ID: <20070319213800.GH9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netfilter-nfnetlink_log-fix-reference-counting.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Miroslaw <mirq-linux@rere.qmqm.pl>

[NETFILTER]: nfnetlink_log: fix reference counting

Fix reference counting (memory leak) problem in __nfulnl_send() and callers
related to packet queueing.

Signed-off-by: Michal Miroslaw <mirq-linux@rere.qmqm.pl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nfnetlink_log.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -218,10 +218,8 @@ _instance_destroy2(struct nfulnl_instanc
 	spin_lock_bh(&inst->lock);
 	if (inst->skb) {
 		/* timer "holds" one reference (we have one more) */
-		if (timer_pending(&inst->timer)) {
-			del_timer(&inst->timer);
+		if (del_timer(&inst->timer))
 			instance_put(inst);
-		}
 		if (inst->qlen)
 			__nfulnl_send(inst);
 		if (inst->skb) {
@@ -695,10 +693,8 @@ nfulnl_log_packet(unsigned int pf,
 		UDEBUG("flushing old skb\n");
 
 		/* timer "holds" one reference (we have another one) */
-		if (timer_pending(&inst->timer)) {
-			del_timer(&inst->timer);
+		if (del_timer(&inst->timer))
 			instance_put(inst);
-		}
 		__nfulnl_send(inst);
 
 		if (!(inst->skb = nfulnl_alloc_skb(nlbufsiz, size))) {

-- 
