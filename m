Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbXC3VU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbXC3VU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXC3VKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:10:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbXC3VKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:10:08 -0400
Date: Fri, 30 Mar 2007 14:04:27 -0700
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
Subject: [patch 10/37] NET: Fix packet classidier NULL pointer OOPS
Message-ID: <20070330210427.GL29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-packet-classidier-null-pointer-oops.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NET_SCHED]: cls_basic: fix NULL pointer dereference

cls_basic doesn't allocate tp->root before it is linked into the
active classifier list, resulting in a NULL pointer dereference
when packets hit the classifier before its ->change function is
called.

Reported by Chris Madden <chris@reflexsecurity.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/cls_basic.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -82,6 +82,13 @@ static void basic_put(struct tcf_proto *
 
 static int basic_init(struct tcf_proto *tp)
 {
+	struct basic_head *head;
+
+	head = kzalloc(sizeof(*head), GFP_KERNEL);
+	if (head == NULL)
+		return -ENOBUFS;
+	INIT_LIST_HEAD(&head->flist);
+	tp->root = head;
 	return 0;
 }
 
@@ -177,15 +184,6 @@ static int basic_change(struct tcf_proto
 	}
 
 	err = -ENOBUFS;
-	if (head == NULL) {
-		head = kzalloc(sizeof(*head), GFP_KERNEL);
-		if (head == NULL)
-			goto errout;
-
-		INIT_LIST_HEAD(&head->flist);
-		tp->root = head;
-	}
-
 	f = kzalloc(sizeof(*f), GFP_KERNEL);
 	if (f == NULL)
 		goto errout;

-- 
