Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYIANNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYIANNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYIANNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:13:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:34768 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYIANNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=p3iKLNuaMKdgW+6hEFA5VA6XVny48u7xFQ+9/OSwpSEO3GMPqplUljEip5ZhR3wHSe
         XYlKDPGQSrFrLnbneSBoglCn/V+wKoCzHK+ZIPCumv3eOFZ8CBPhJ5GbiZ0T9nLjXj+N
         1wmn+70bBr6UG5PoTW3LUMYgKcAG5y4pBYOOo=
Message-ID: <48BBEA82.4020903@panasas.com>
Date: Mon, 01 Sep 2008 16:13:38 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] virtio: Fix none-const BUILD_BUG_ON usage
References: <48BBE77D.7070007@panasas.com>
In-Reply-To: <48BBE77D.7070007@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BUILD_BUG_ON can not be used cross inline parametrization boundary.
I've put the BUILD_BUG_ON(_ZERO) in a macro outside of the inline
definition. (So it is in the caller scope).

NOTE to Rusty:
  If I remove the "__builtin_constant_p ?" part then code compiles
  just fine, because all call sights of virtio_has_feature() use
  constants for fbit. But it seems like it was not intended to be
  forced.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/virtio_config.h |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bf8ec28..d9402d8 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -92,17 +92,19 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
  * @vdev: the device
  * @fbit: the feature bit
  */
-static inline bool virtio_has_feature(const struct virtio_device *vdev,
+static inline bool __virtio_has_feature(const struct virtio_device *vdev,
 				      unsigned int fbit)
 {
-	/* Did you forget to fix assumptions on max features? */
-	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 32);
-
 	virtio_check_driver_offered_feature(vdev, fbit);
 	return test_bit(fbit, vdev->features);
 }
 
+/* Did you forget to fix assumptions on max features? */
+#define virtio_has_feature(vdev, fbit) \
+	((__builtin_constant_p(fbit) ? BUILD_BUG_ON_ZERO(fbit >= 32) : 0) + \
+	__virtio_has_feature(vdev, fbit))
+	
+
 /**
  * virtio_config_val - look for a feature and get a virtio config entry.
  * @vdev: the virtio device
-- 
1.5.6.rc1.5.gadf6


