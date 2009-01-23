Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbZAWGRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbZAWGRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZAWGQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:23 -0500
Received: from kroah.org ([198.145.64.141]:36103 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752087AbZAWGQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:23 -0500
Date: Thu, 22 Jan 2009 22:13:02 -0800
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
Subject: [patch 04/40] pkt_sched: cls_u32: Fix locking in u32_change()
Message-ID: <20090123061302.GD2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pkt_sched-cls_u32-fix-locking-in-u32_change.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit: 6f57321422e0d359e83c978c2b03db77b967b7d5 ]

New nodes are inserted in u32_change() under rtnl_lock() with wmb(),
so without tcf_tree_lock() like in other classifiers (e.g. cls_fw).
This isn't enough without rmb() on the read side, but on the other
hand adding such barriers doesn't give any savings, so the lock is
added instead.

Reported-by: m0sia <m0sia@plotinka.ru>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/cls_u32.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -637,8 +637,9 @@ static int u32_change(struct tcf_proto *
 				break;
 
 		n->next = *ins;
-		wmb();
+		tcf_tree_lock(tp);
 		*ins = n;
+		tcf_tree_unlock(tp);
 
 		*arg = (unsigned long)n;
 		return 0;

