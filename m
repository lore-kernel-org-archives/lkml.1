Return-Path: <linux-kernel-owner+w=401wt.eu-S1422892AbXCGRbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422892AbXCGRbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422876AbXCGRRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422858AbXCGRRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:00 -0500
Message-Id: <20070307171522.336289321@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:46 -0800
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
       =?ISO-8859-15?q?Micha=C5=82=20Miros=C5=82aw?= 
	<mirq-linux@rere.qmqm.pl>
Subject: [patch 071/101] Fix reference counting (memory leak) problem in __nfulnl_send() and callers related to packet queueing.
Content-Disposition: inline; filename=nfnetlink_log_refcounting_fix.patch.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nfnetlink_log.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/net/netfilter/nfnetlink_log.c
+++ linux-2.6.20.1/net/netfilter/nfnetlink_log.c
@@ -217,6 +217,11 @@ _instance_destroy2(struct nfulnl_instanc
 
 	spin_lock_bh(&inst->lock);
 	if (inst->skb) {
+		/* timer "holds" one reference (we have one more) */
+		if (timer_pending(&inst->timer)) {
+			del_timer(&inst->timer);
+			instance_put(inst);
+		}
 		if (inst->qlen)
 			__nfulnl_send(inst);
 		if (inst->skb) {
@@ -363,9 +368,6 @@ __nfulnl_send(struct nfulnl_instance *in
 {
 	int status;
 
-	if (timer_pending(&inst->timer))
-		del_timer(&inst->timer);
-
 	if (!inst->skb)
 		return 0;
 
@@ -392,6 +394,8 @@ static void nfulnl_timer(unsigned long d
 	UDEBUG("timer function called, flushing buffer\n");
 
 	spin_lock_bh(&inst->lock);
+	if (timer_pending(&inst->timer))	/* is it always true or false here? */
+		del_timer(&inst->timer);
 	__nfulnl_send(inst);
 	instance_put(inst);
 	spin_unlock_bh(&inst->lock);
@@ -689,6 +693,11 @@ nfulnl_log_packet(unsigned int pf,
 		 * enough room in the skb left. flush to userspace. */
 		UDEBUG("flushing old skb\n");
 
+		/* timer "holds" one reference (we have another one) */
+		if (timer_pending(&inst->timer)) {
+			del_timer(&inst->timer);
+			instance_put(inst);
+		}
 		__nfulnl_send(inst);
 
 		if (!(inst->skb = nfulnl_alloc_skb(nlbufsiz, size))) {

--
