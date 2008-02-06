Return-Path: <linux-kernel-owner+w=401wt.eu-S932576AbYBFX7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbYBFX7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764191AbYBFXyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:37 -0500
Received: from ns.suse.de ([195.135.220.2]:45179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764177AbYBFXyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:35 -0500
Date: Wed, 6 Feb 2008 15:51:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/73] IPV4 raw: Strengthen check on validity of iph->ihl
Message-ID: <20080206235120.GM13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv4-raw-strengthen-check-on-validity-of-iph-ihl.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[IPV4] raw: Strengthen check on validity of iph->ihl

[ Upstream commit: f844c74fe07321953e2dd227fe35280075f18f60 ]

We currently check that iph->ihl is bounded by the real length and that
the real length is greater than the minimum IP header length.  However,
we did not check the caes where iph->ihl is less than the minimum IP
header length.

This breaks because some ip_fast_csum implementations assume that which
is quite reasonable.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/raw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -270,6 +270,7 @@ static int raw_send_hdrinc(struct sock *
 	int hh_len;
 	struct iphdr *iph;
 	struct sk_buff *skb;
+	unsigned int iphlen;
 	int err;
 
 	if (length > rt->u.dst.dev->mtu) {
@@ -303,7 +304,8 @@ static int raw_send_hdrinc(struct sock *
 		goto error_fault;
 
 	/* We don't modify invalid header */
-	if (length >= sizeof(*iph) && iph->ihl * 4U <= length) {
+	iphlen = iph->ihl * 4;
+	if (iphlen >= sizeof(*iph) && iphlen <= length) {
 		if (!iph->saddr)
 			iph->saddr = rt->rt_src;
 		iph->check   = 0;

-- 
