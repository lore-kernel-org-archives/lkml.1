Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbXC3VWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbXC3VWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXC3VK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:10:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58267 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbXC3VKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:10:11 -0400
Date: Fri, 30 Mar 2007 14:04:31 -0700
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
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/37] NET_SCHED: Fix ingress qdisc locking.
Message-ID: <20070330210431.GM29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net_sched-fix-ingress-qdisc-locking.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NET_SCHED]: Fix ingress locking

Ingress queueing uses a seperate lock for serializing enqueue operations,
but fails to properly protect itself against concurrent changes to the
qdisc tree. Use queue_lock for now since the real fix it quite intrusive.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/core/dev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1750,10 +1750,10 @@ static int ing_filter(struct sk_buff *sk
 
 		skb->tc_verd = SET_TC_AT(skb->tc_verd,AT_INGRESS);
 
-		spin_lock(&dev->ingress_lock);
+		spin_lock(&dev->queue_lock);
 		if ((q = dev->qdisc_ingress) != NULL)
 			result = q->enqueue(skb, q);
-		spin_unlock(&dev->ingress_lock);
+		spin_unlock(&dev->queue_lock);
 
 	}
 

-- 
