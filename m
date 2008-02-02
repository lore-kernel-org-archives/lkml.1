Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbYBBA2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbYBBA2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763270AbYBBAYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:24:36 -0500
Received: from mail.suse.de ([195.135.220.2]:54587 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762039AbYBBAYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:24:35 -0500
Date: Fri, 1 Feb 2008 16:20:24 -0800
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
Subject: [patch 11/27] IPSEC: Avoid undefined shift operation when testing
	algorithm ID
Message-ID: <20080202002024.GL8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipsec-avoid-undefined-shift-operation-when-testing-algorithm-id.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[IPSEC]: Avoid undefined shift operation when testing algorithm ID

[ Upstream commit: f398035f2dec0a6150833b0bc105057953594edb ]

The aalgos/ealgos fields are only 32 bits wide.  However, af_key tries
to test them with the expression 1 << id where id can be as large as
253.  This produces different behaviour on different architectures.

The following patch explicitly checks whether ID is greater than 31
and fails the check if that's the case.

We cannot easily extend the mask to be longer than 32 bits due to
exposure to user-space.  Besides, this whole interface is obsolete
anyway in favour of the xfrm_user interface which doesn't use this
bit mask in templates (well not within the kernel anyway).

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/key/af_key.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2777,12 +2777,22 @@ static struct sadb_msg *pfkey_get_base_m
 
 static inline int aalg_tmpl_set(struct xfrm_tmpl *t, struct xfrm_algo_desc *d)
 {
-	return t->aalgos & (1 << d->desc.sadb_alg_id);
+	unsigned int id = d->desc.sadb_alg_id;
+
+	if (id >= sizeof(t->aalgos) * 8)
+		return 0;
+
+	return (t->aalgos >> id) & 1;
 }
 
 static inline int ealg_tmpl_set(struct xfrm_tmpl *t, struct xfrm_algo_desc *d)
 {
-	return t->ealgos & (1 << d->desc.sadb_alg_id);
+	unsigned int id = d->desc.sadb_alg_id;
+
+	if (id >= sizeof(t->ealgos) * 8)
+		return 0;
+
+	return (t->ealgos >> id) & 1;
 }
 
 static int count_ah_combs(struct xfrm_tmpl *t)

-- 
