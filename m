Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbYDQBSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbYDQBSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759856AbYDQBIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:05 -0400
Received: from sous-sol.org ([216.99.217.87]:58901 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759808AbYDQBID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:03 -0400
Message-Id: <20080417010339.904016618@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       David S Miller <davem@davemloft.net>
Subject: AX25 ax25_out: check skb for NULL in ax25_kick()
Content-Disposition: inline; filename=ax25-ax25_out-check-skb-for-null-in-ax25_kick.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jarek Poplawski <jarkao2@gmail.com>

Upstream commit: f47b7257c7368698eabff6fd7b340071932af640

According to some OOPS reports ax25_kick tries to clone NULL skbs
sometimes. It looks like a race with ax25_clear_queues(). Probably
there is no need to add more than a simple check for this yet.
Another report suggested there are probably also cases where ax25
->paclen == 0 can happen in ax25_output(); this wasn't confirmed
during testing but let's leave this debugging check for some time.

Reported-and-tested-by: Jann Traschewski <jann@gmx.de>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ax25/ax25_out.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -117,6 +117,12 @@ void ax25_output(ax25_cb *ax25, int pacl
 	unsigned char *p;
 	int frontlen, len, fragno, ka9qfrag, first = 1;
 
+	if (paclen < 16) {
+		WARN_ON_ONCE(1);
+		kfree_skb(skb);
+		return;
+	}
+
 	if ((skb->len - 1) > paclen) {
 		if (*skb->data == AX25_P_TEXT) {
 			skb_pull(skb, 1); /* skip PID */
@@ -251,8 +257,6 @@ void ax25_kick(ax25_cb *ax25)
 	if (start == end)
 		return;
 
-	ax25->vs = start;
-
 	/*
 	 * Transmit data until either we're out of data to send or
 	 * the window is full. Send a poll on the final I frame if
@@ -261,8 +265,13 @@ void ax25_kick(ax25_cb *ax25)
 
 	/*
 	 * Dequeue the frame and copy it.
+	 * Check for race with ax25_clear_queues().
 	 */
 	skb  = skb_dequeue(&ax25->write_queue);
+	if (!skb)
+		return;
+
+	ax25->vs = start;
 
 	do {
 		if ((skbn = skb_clone(skb, GFP_ATOMIC)) == NULL) {

-- 
