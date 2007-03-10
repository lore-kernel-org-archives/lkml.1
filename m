Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbXCJGYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbXCJGYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXCJGTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:19:35 -0500
Received: from ns.suse.de ([195.135.220.2]:41020 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbXCJGTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:19:21 -0500
Date: Fri, 9 Mar 2007 22:17:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, netfilter-devel@lists.netfilter.org,
       Patrick McHardy <kaber@trash.net>, davem@davemloft.net
Subject: [patch 09/20] nf_conntrack: fix incorrect classification of IPv6 fragments as ESTABLISHED
Message-ID: <20070310061741.GJ31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nf_conntrack-fix-incorrect-classification-of-ipv6-fragments-as-established.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: nf_conntrack: fix incorrect classification of IPv6 fragments as ESTABLISHED

The individual fragments of a packet reassembled by conntrack have the
conntrack reference from the reassembled packet attached, but nfctinfo
is not copied. This leaves it initialized to 0, which unfortunately is
the value of IP_CT_ESTABLISHED.

The result is that all IPv6 fragments are tracked as ESTABLISHED,
allowing them to bypass a usual ruleset which accepts ESTABLISHED
packets early.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -257,6 +257,7 @@ static unsigned int ipv6_conntrack_in(un
 		}
 		nf_conntrack_get(reasm->nfct);
 		(*pskb)->nfct = reasm->nfct;
+		(*pskb)->nfctinfo = reasm->nfctinfo;
 		return NF_ACCEPT;
 	}
 

-- 
