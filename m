Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbZDWHld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbZDWHld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbZDWHaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:19 -0400
Received: from sous-sol.org ([216.99.217.87]:50388 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756394AbZDWHaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:18 -0400
Message-Id: <20090423072542.417763086@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [patch 046/100] crypto: shash - Fix unaligned calculation with short length
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=crypto-shash-fix-unaligned-calculation-with-short-length.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Yehuda Sadeh <yehuda@hq.newdream.net>

upstream commit: f4f689933c63e0fbfba62f2a80efb2b424b139ae

When the total length is shorter than the calculated number of unaligned bytes, the call to shash->update breaks. For example, calling crc32c on unaligned buffer with length of 1 can result in a system crash.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 crypto/shash.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -82,6 +82,9 @@ static int shash_update_unaligned(struct
 	u8 buf[shash_align_buffer_size(unaligned_len, alignmask)]
 		__attribute__ ((aligned));
 
+	if (unaligned_len > len)
+		unaligned_len = len;
+
 	memcpy(buf, data, unaligned_len);
 
 	return shash->update(desc, buf, unaligned_len) ?:

