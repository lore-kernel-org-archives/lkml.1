Return-Path: <linux-kernel-owner+w=401wt.eu-S932277AbYCUWws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbYCUWws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762773AbYCUWrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:47:13 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58950 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762606AbYCUWrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:47:10 -0400
Message-Id: <20080321224350.867706168@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:13 -0700
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
       Joy Latten <latten@austin.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 23/76] CRYPTO xcbc: Fix crash with IPsec
Content-Disposition: inline; filename=crypto-xcbc-fix-crash-with-ipsec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Joy Latten <latten@austin.ibm.com>

[ Upstream commit: 2f40a178e70030c4712fe63807c883f34c3645eb ]

When using aes-xcbc-mac for authentication in IPsec,
the kernel crashes. It seems this algorithm doesn't
account for the space IPsec may make in scatterlist for authtag.
Thus when crypto_xcbc_digest_update2() gets called,
nbytes may be less than sg[i].length.
Since nbytes is an unsigned number, it wraps
at the end of the loop allowing us to go back
into loop and causing crash in memcpy.

I used update function in digest.c to model this fix.
Please let me know if it looks ok.

Signed-off-by: Joy Latten <latten@austin.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 crypto/xcbc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -124,6 +124,11 @@ static int crypto_xcbc_digest_update2(st
 		unsigned int offset = sg[i].offset;
 		unsigned int slen = sg[i].length;
 
+		if (unlikely(slen > nbytes))
+			slen = nbytes;
+
+		nbytes -= slen;
+
 		while (slen > 0) {
 			unsigned int len = min(slen, ((unsigned int)(PAGE_SIZE)) - offset);
 			char *p = crypto_kmap(pg, 0) + offset;
@@ -177,7 +182,6 @@ static int crypto_xcbc_digest_update2(st
 			offset = 0;
 			pg++;
 		}
-		nbytes-=sg[i].length;
 		i++;
 	} while (nbytes>0);
 

-- 
