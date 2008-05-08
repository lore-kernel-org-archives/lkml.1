Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbYEHRvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbYEHRvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765218AbYEHRoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:44:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:33605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbYEHRoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:44:05 -0400
Date: Thu, 8 May 2008 10:42:34 -0700
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
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 16/16] CRYPTO: eseqiv: Fix off-by-one encryption
Message-ID: <20080508174234.GQ855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="crypto-eseqiv-fix-off-by-one-encryption.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[CRYPTO] eseqiv: Fix off-by-one encryption

[ Upstream commit: 46f8153cc59384eb09a426d044668d4801f818ce ]

After attaching the IV to the head during encryption, eseqiv does not
increase the encryption length by that amount.  As such the last block
of the actual plain text will be left unencrypted.

Fortunately the only user of this code hifn currently crashes so this
shouldn't affect anyone :)

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/eseqiv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -136,7 +136,8 @@ static int eseqiv_givencrypt(struct skci
 	}
 
 	ablkcipher_request_set_crypt(subreq, reqctx->src, dst,
-				     req->creq.nbytes, req->creq.info);
+				     req->creq.nbytes + ivsize,
+				     req->creq.info);
 
 	memcpy(req->creq.info, ctx->salt, ivsize);
 

-- 
