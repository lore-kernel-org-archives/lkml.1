Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZAMBft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZAMBft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbZAMB3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:13 -0500
Received: from kroah.org ([198.145.64.141]:36084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758157AbZAMB3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:09 -0500
Date: Mon, 12 Jan 2009 17:27:27 -0800
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
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 17/21] drivers/net: starfire: Fix napi ->poll() weight
	handling
Message-ID: <20090113012727.GR4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-net-starfire-fix-napi-poll-weight-handling.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

commit 9a3de25544dadab1971847f28f33b1cd0d1770a6 upstream.

starfire napi ->poll() handler can return work == weight after calling
netif_rx_complete() (if there is no more work). It is illegal and this
patch fixes it.

Reported-by: Alexander Huemer <alexander.huemer@sbg.ac.at>
Tested-by: Alexander Huemer <alexander.huemer@sbg.ac.at>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/starfire.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -1509,6 +1509,11 @@ static int __netdev_rx(struct net_device
 		desc->status = 0;
 		np->rx_done = (np->rx_done + 1) % DONE_Q_SIZE;
 	}
+
+	if (*quota == 0) {	/* out of rx quota */
+		retcode = 1;
+		goto out;
+	}
 	writew(np->rx_done, np->base + CompletionQConsumerIdx);
 
  out:

