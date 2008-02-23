Return-Path: <linux-kernel-owner+w=401wt.eu-S936064AbYBWAjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936064AbYBWAjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761156AbYBWAe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:26 -0500
Received: from ns1.suse.de ([195.135.220.2]:44742 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYBWAeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:22 -0500
Date: Fri, 22 Feb 2008 16:30:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 13/38] PKT_SCHED: ematch: oops from uninitialized variable
	(resend)
Message-ID: <20080223003023.GN7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pkt_sched-ematch-oops-from-uninitialized-variable.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: 268bcca1e7b0d244afd07ea89cda672e61b0fc4a

Setting up a meta match causes a kernel OOPS because of uninitialized
elements in tree.

[   37.322381] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   37.322381] IP: [<ffffffff883fc717>] :em_meta:em_meta_destroy+0x17/0x80

[   37.322381] Call Trace:
[   37.322381]  [<ffffffff803ec83d>] tcf_em_tree_destroy+0x2d/0xa0
[   37.322381]  [<ffffffff803ecc8c>] tcf_em_tree_validate+0x2dc/0x4a0
[   37.322381]  [<ffffffff803f06d2>] nla_parse+0x92/0xe0
[   37.322381]  [<ffffffff883f9672>] :cls_basic:basic_change+0x202/0x3c0
[   37.322381]  [<ffffffff802a3917>] kmem_cache_alloc+0x67/0xa0
[   37.322381]  [<ffffffff803ea221>] tc_ctl_tfilter+0x3b1/0x580
[   37.322381]  [<ffffffff803dffd0>] rtnetlink_rcv_msg+0x0/0x260
[   37.322381]  [<ffffffff803ee944>] netlink_rcv_skb+0x74/0xa0
[   37.322381]  [<ffffffff803dffc8>] rtnetlink_rcv+0x18/0x20
[   37.322381]  [<ffffffff803ee6c3>] netlink_unicast+0x263/0x290
[   37.322381]  [<ffffffff803cf276>] __alloc_skb+0x96/0x160
[   37.322381]  [<ffffffff803ef014>] netlink_sendmsg+0x274/0x340
[   37.322381]  [<ffffffff803c7c3b>] sock_sendmsg+0x12b/0x140
[   37.322381]  [<ffffffff8024de90>] autoremove_wake_function+0x0/0x30
[   37.322381]  [<ffffffff8024de90>] autoremove_wake_function+0x0/0x30
[   37.322381]  [<ffffffff803c7c3b>] sock_sendmsg+0x12b/0x140
[   37.322381]  [<ffffffff80288611>] zone_statistics+0xb1/0xc0
[   37.322381]  [<ffffffff803c7e5e>] sys_sendmsg+0x20e/0x360
[   37.322381]  [<ffffffff803c7411>] sockfd_lookup_light+0x41/0x80
[   37.322381]  [<ffffffff8028d04b>] handle_mm_fault+0x3eb/0x7f0
[   37.322381]  [<ffffffff8020c2fb>] system_call_after_swapgs+0x7b/0x80

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/ematch.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -305,10 +305,9 @@ int tcf_em_tree_validate(struct tcf_prot
 	struct tcf_ematch_tree_hdr *tree_hdr;
 	struct tcf_ematch *em;
 
-	if (!rta) {
-		memset(tree, 0, sizeof(*tree));
+	memset(tree, 0, sizeof(*tree));
+	if (!rta)
 		return 0;
-	}
 
 	if (rtattr_parse_nested(tb, TCA_EMATCH_TREE_MAX, rta) < 0)
 		goto errout;

-- 
