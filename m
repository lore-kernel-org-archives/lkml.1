Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbYFNATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbYFNATn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761501AbYFNAN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:51858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761475AbYFNAN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:57 -0400
Date: Fri, 13 Jun 2008 17:11:21 -0700
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
       alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@suug.ch>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 22/47] netlink: Fix nla_parse_nested_compat() to call
	nla_parse() directly
Message-ID: <20080614001121.GV24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netlink-fix-nla_parse_nested_compat-to-call-nla_parse-directly.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Graf <tgraf@suug.ch>

[ upstream commit: b9a2f2e450b0f770bb4347ae8d48eb2dea701e24 ]

The purpose of nla_parse_nested_compat() is to parse attributes which
contain a struct followed by a stream of nested attributes.  So far,
it called nla_parse_nested() to parse the stream of nested attributes
which was wrong, as nla_parse_nested() expects a container attribute
as data which holds the attribute stream.  It needs to call
nla_parse() directly while pointing at the next possible alignment
point after the struct in the beginning of the attribute.

With this patch, I can no longer reproduce the reported leftover
warnings.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/net/netlink.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -772,12 +772,13 @@ static inline int __nla_parse_nested_com
 					    const struct nla_policy *policy,
 					    int len)
 {
-	if (nla_len(nla) < len)
+	int nested_len = nla_len(nla) - NLA_ALIGN(len);
+
+	if (nested_len < 0)
 		return -1;
-	if (nla_len(nla) >= NLA_ALIGN(len) + sizeof(struct nlattr))
-		return nla_parse_nested(tb, maxtype,
-					nla_data(nla) + NLA_ALIGN(len),
-					policy);
+	if (nested_len >= nla_attr_size(0))
+		return nla_parse(tb, maxtype, nla_data(nla) + NLA_ALIGN(len),
+				 nested_len, policy);
 	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
 	return 0;
 }

-- 
