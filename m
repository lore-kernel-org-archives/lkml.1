Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbYFNARX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbYFNARX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760878AbYFNANP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:34268 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760289AbYFNANN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:13 -0400
Date: Fri, 13 Jun 2008 17:10:54 -0700
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
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 15/47] ax25: Fix NULL pointer dereference and lockup.
Message-ID: <20080614001054.GO24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ax25-fix-null-pointer-dereference-and-lockup.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit: 7dccf1f4e1696c79bff064c3770867cc53cbc71c ]

There is only one function in AX25 calling skb_append(), and it really
looks suspicious: appends skb after previously enqueued one, but in
the meantime this previous skb could be removed from the queue.

This patch Fixes it the simple way, so this is not fully compatible with
the current method, but testing hasn't shown any problems.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ax25/ax25_subr.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -64,20 +64,15 @@ void ax25_frames_acked(ax25_cb *ax25, un
 
 void ax25_requeue_frames(ax25_cb *ax25)
 {
-	struct sk_buff *skb, *skb_prev = NULL;
+	struct sk_buff *skb;
 
 	/*
 	 * Requeue all the un-ack-ed frames on the output queue to be picked
 	 * up by ax25_kick called from the timer. This arrangement handles the
 	 * possibility of an empty output queue.
 	 */
-	while ((skb = skb_dequeue(&ax25->ack_queue)) != NULL) {
-		if (skb_prev == NULL)
-			skb_queue_head(&ax25->write_queue, skb);
-		else
-			skb_append(skb_prev, skb, &ax25->write_queue);
-		skb_prev = skb;
-	}
+	while ((skb = skb_dequeue_tail(&ax25->ack_queue)) != NULL)
+		skb_queue_head(&ax25->write_queue, skb);
 }
 
 /*

-- 
