Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbZENXAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbZENXAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbZENWnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:43:05 -0400
Received: from kroah.org ([198.145.64.141]:52764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbZENWml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:28 2009
Message-Id: <20090514223528.516280955@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:25 -0700
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
       alan@lxorguk.ukuu.org.uk, Hannes Hering <hering2@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 50/51] ehea: fix invalid pointer access
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=ehea-fix-invalid-pointer-access.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hannes Hering <hering2@de.ibm.com>

commit 0b2febf38a33d7c40fb7bb4a58c113a1fa33c412 upstream.

This patch fixes an invalid pointer access in case the receive queue
holds no pointer to the next skb when the queue is empty.

Signed-off-by: Hannes Hering <hering2@de.ibm.com>
Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ehea/ehea_main.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -529,14 +529,17 @@ static inline struct sk_buff *get_skb_by
 	x &= (arr_len - 1);
 
 	pref = skb_array[x];
-	prefetchw(pref);
-	prefetchw(pref + EHEA_CACHE_LINE);
+	if (pref) {
+		prefetchw(pref);
+		prefetchw(pref + EHEA_CACHE_LINE);
+
+		pref = (skb_array[x]->data);
+		prefetch(pref);
+		prefetch(pref + EHEA_CACHE_LINE);
+		prefetch(pref + EHEA_CACHE_LINE * 2);
+		prefetch(pref + EHEA_CACHE_LINE * 3);
+	}
 
-	pref = (skb_array[x]->data);
-	prefetch(pref);
-	prefetch(pref + EHEA_CACHE_LINE);
-	prefetch(pref + EHEA_CACHE_LINE * 2);
-	prefetch(pref + EHEA_CACHE_LINE * 3);
 	skb = skb_array[skb_index];
 	skb_array[skb_index] = NULL;
 	return skb;
@@ -553,12 +556,14 @@ static inline struct sk_buff *get_skb_by
 	x &= (arr_len - 1);
 
 	pref = skb_array[x];
-	prefetchw(pref);
-	prefetchw(pref + EHEA_CACHE_LINE);
-
-	pref = (skb_array[x]->data);
-	prefetchw(pref);
-	prefetchw(pref + EHEA_CACHE_LINE);
+	if (pref) {
+		prefetchw(pref);
+		prefetchw(pref + EHEA_CACHE_LINE);
+
+		pref = (skb_array[x]->data);
+		prefetchw(pref);
+		prefetchw(pref + EHEA_CACHE_LINE);
+	}
 
 	skb = skb_array[wqe_index];
 	skb_array[wqe_index] = NULL;


