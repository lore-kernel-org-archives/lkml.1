Return-Path: <linux-kernel-owner+w=401wt.eu-S935421AbXEUTsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935421AbXEUTsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934066AbXEUT3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52624 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934054AbXEUT3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:03 -0400
Message-Id: <20070521191748.518020000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, Vlad Yasevich <vladislav.yasevich@hp.com>
Subject: [patch 52/69] SCTP: Prevent OOPS if hmac modules didnt load
Content-Disposition: inline; filename=sctp-prevent-oops-if-hmac-modules-didn-t-load.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

SCTP was checking for NULL when trying to detect hmac
allocation failure where it should have been using IS_ERR.
Also, print a rate limited warning to the log telling the
user what happend.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/sctp/socket.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.21.1.orig/net/sctp/socket.c
+++ linux-2.6.21.1/net/sctp/socket.c
@@ -4985,7 +4985,12 @@ int sctp_inet_listen(struct socket *sock
 	/* Allocate HMAC for generating cookie. */
 	if (sctp_hmac_alg) {
 		tfm = crypto_alloc_hash(sctp_hmac_alg, 0, CRYPTO_ALG_ASYNC);
-		if (!tfm) {
+		if (IS_ERR(tfm)) {
+			if (net_ratelimit()) {
+				printk(KERN_INFO
+				       "SCTP: failed to load transform for %s: %ld\n",
+					sctp_hmac_alg, PTR_ERR(tfm));
+			}
 			err = -ENOSYS;
 			goto out;
 		}

-- 
