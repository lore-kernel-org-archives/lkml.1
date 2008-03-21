Return-Path: <linux-kernel-owner+w=401wt.eu-S1764877AbYCUXBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764877AbYCUXBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763756AbYCUWu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:50:57 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59317 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762733AbYCUWux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:50:53 -0400
Message-Id: <20080321224340.376230371@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 14/76] IPCOMP: Disable BH on output when using shared tfm
Content-Disposition: inline; filename=ipcomp-disable-bh-on-output-when-using-shared-tfm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

Upstream commit: 21e43188f272c7fd9efc84b8244c0b1dfccaa105

Because we use shared tfm objects in order to conserve memory,
(each tfm requires 128K of vmalloc memory), BH needs to be turned
off on output as that can occur in process context.

Previously this was done implicitly by the xfrm output code.
That was lost when it became lockless.  So we need to add the
BH disabling to IPComp directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv4/ipcomp.c  |    5 ++++-
 net/ipv6/ipcomp6.c |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -108,8 +108,11 @@ static int ipcomp_compress(struct xfrm_s
 	const int cpu = get_cpu();
 	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
 	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
-	int err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
+	int err;
 
+	local_bh_disable();
+	err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
+	local_bh_enable();
 	if (err)
 		goto out;
 
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -146,7 +146,9 @@ static int ipcomp6_output(struct xfrm_st
 	scratch = *per_cpu_ptr(ipcomp6_scratches, cpu);
 	tfm = *per_cpu_ptr(ipcd->tfms, cpu);
 
+	local_bh_disable();
 	err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
+	local_bh_enable();
 	if (err || (dlen + sizeof(*ipch)) >= plen) {
 		put_cpu();
 		goto out_ok;

-- 
