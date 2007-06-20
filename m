Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXFTLhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXFTLhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 07:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXFTLhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 07:37:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:59089 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbXFTLhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 07:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=nyVW3gAgbLCwjfdWqqscw5AuJDJ193W5c06SBr0Dq+nBrXcOskW+tyf8BPnbqZVZaOMUwMSdO16sLMD2N4osh817d2nwL14A4gFAuOtWU1qUhem2jVRNXQMpD6ZhEXIIvinqNNqYr3ih7kD3Sbv6zxd+Wp9JF7Pw8dkDAWzTxEs=
Message-ID: <4679116E.9050507@gmail.com>
Date: Wed, 20 Jun 2007 22:37:18 +1100
From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061107)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Sergey Vlasov <vsu@altlinux.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH 2.6.21.5] ppp: fix osize too small errors when decoding
 mppe
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The mppe_decompress() function required a buffer that is 1 byte too small when
receiving a message of mru size. This fixes buffer allocation to prevent this
from occurring.

Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
---
As Sergey Vlasov pointed out, ppp_mppe-account-for-osize-too-small-errors-in.patch
may cause buffer overflows on certain data. Here is another patch that should
eliminate the "osize too small" errors. Instead of patching mppe_decompress
itself, I have patched ppp_decompress_frame so it would allocate the required
extra byte when using mppe compression.

I didn't have a chance to check this patch carefully yet, but it seem to be
working as expected. Any comments would be greatly appreciated.

--- linux-2.6.21.3/drivers/net/ppp_generic.c.orig	2007-06-20 09:14:13.000000000
+1100
+++ linux-2.6.21.3/drivers/net/ppp_generic.c	2007-06-20 09:18:06.000000000 +1100
@@ -1711,7 +1711,18 @@ ppp_decompress_frame(struct ppp *ppp, st
 		goto err;

 	if (proto == PPP_COMP) {
-		ns = dev_alloc_skb(ppp->mru + PPP_HDRLEN);
+		int obuff_size;
+
+		switch(ppp->rcomp->compress_proto) {
+		case CI_MPPE:
+			obuff_size = ppp->mru + PPP_HDRLEN + 1;
+			break;
+		default:
+			obuff_size = ppp->mru + PPP_HDRLEN;
+			break;
+		}
+
+		ns = dev_alloc_skb(obuff_size);
 		if (ns == 0) {
 			printk(KERN_ERR "ppp_decompress_frame: no memory\n");
 			goto err;
