Return-Path: <linux-kernel-owner+w=401wt.eu-S1946251AbXBCCga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946251AbXBCCga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946245AbXBCCga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:30 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52674 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946240AbXBCCfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:35:48 -0500
Message-Id: <20070203023835.125598000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:11 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org,
       davem@davemloft.net
Subject: [patch 07/59] NETFILTER: nf_conntrack_ipv6: fix crash when handling fragments
Content-Disposition: inline; filename=netfilter-nf_conntrack_ipv6-fix-crash-when-handling-fragments.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

When IPv6 connection tracking splits up a defragmented packet into
its original fragments, the packets are taken from a list and are
passed to the network stack with skb->next still set. This causes
dev_hard_start_xmit to treat them as GSO fragments, resulting in
a use after free when connection tracking handles the next fragment.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.19.2.orig/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ linux-2.6.19.2/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -835,6 +835,8 @@ void nf_ct_frag6_output(unsigned int hoo
 		s->nfct_reasm = skb;
 
 		s2 = s->next;
+		s->next = NULL;
+
 		NF_HOOK_THRESH(PF_INET6, hooknum, s, in, out, okfn,
 			       NF_IP6_PRI_CONNTRACK_DEFRAG + 1);
 		s = s2;

--
