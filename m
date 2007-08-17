Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbXHQJqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbXHQJqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 05:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXHQJqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 05:46:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:16291 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXHQJqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 05:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FwvT64n5lAsGXLbLF9Jjghh8lvwMynbIXHjRwkekEwQFzf3541GKbP/e/uCrtoJiZ85sXOpRpb000DolUq8bbqfaIq4QSKjMM2/yVjNnqjBE7esUqtjhjDDQTOvake6uBcVm59UKmhCAXCbm2fgu69TykeBOdWwbybV58aQRVz0=
Subject: [PATCH 2.6.22.3] ppp: fix output buffer size in
	ppp_decompress_frame
From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Reply-To: konstantin.sharlaimov@gmail.com
To: Suresh Mahalingam <msuresh_2001@yahoo.com>
Cc: David Miller <davem@davemloft.net>, paulus@samba.org,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 20:45:51 +1100
Message-Id: <1187343951.10629.9.camel@traveler>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses the issue with "osize too small" errors in mppe encryption.
The patch fixes the issue with wrong output buffer size being passed to ppp
decompression routine.

Signed-off-by: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
---
As pointed out by Suresh Mahalingam, the issue addressed by 
ppp-fix-osize-too-small-errors-when-decoding patch is not fully resolved yet.
The size of allocated output buffer is correct, however it size passed to
ppp->rcomp->decompress in ppp_generic.c if wrong. The patch fixes that.

--- linux-2.6.21.3/drivers/net/ppp_generic.c.orig	2007-08-17 20:35:03.000000000 +1100
+++ linux-2.6.21.3/drivers/net/ppp_generic.c	2007-08-17 20:35:45.000000000 +1100
@@ -1726,7 +1726,7 @@ ppp_decompress_frame(struct ppp *ppp, st
 		}
 		/* the decompressor still expects the A/C bytes in the hdr */
 		len = ppp->rcomp->decompress(ppp->rc_state, skb->data - 2,
-				skb->len + 2, ns->data, ppp->mru + PPP_HDRLEN);
+				skb->len + 2, ns->data, obuff_size);
 		if (len < 0) {
 			/* Pass the compressed frame to pppd as an
 			   error indication. */

