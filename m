Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbYIBPyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbYIBPyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYIBPx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:53:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:37920 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYIBPx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=vrSO+Z4IsM7GLPdlYb0Ggt0lvHX9TUlSgHUQuZ5Xnk8dU3cWutUpstywKzT0p+cfTC
         DbDQOYJaOtx6vZaq5wwzN/e/+9VaJZqFYaAVOIOH+rMkNUPbUvxYwt+z8zFcK0xihKfU
         XHRRhRN7i5GQ2jehHuZZCLcxxPVsE+NYRHBMM=
Message-ID: <48BD6190.7070006@panasas.com>
Date: Tue, 02 Sep 2008 18:53:52 +0300
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
Subject: [PATCH 3/5 ver2] virtio: Fix non-const BUILD_BUG_ON usage
References: <48BBE77D.7070007@panasas.com> <48BBEA82.4020903@panasas.com>
In-Reply-To: <48BBEA82.4020903@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In virtio_has_feature() BUILD_BUG_ON can not be used cross inline
parametrization boundary. I've put the BUILD_BUG_ON(_ZERO) in a
macro outside of the inline definition. (So it is in the caller scope).

However It is no longer legal to pass BUILD_BUG_ON a non-const
expression so users like virtio_config_buf() should caller
__virtio_has_feature() which does the actual code minus the
check.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/virtio_config.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bf8ec28..7accb1d 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -92,17 +92,18 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
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
+	(BUILD_BUG_ON_ZERO(fbit >= 32) + __virtio_has_feature(vdev, fbit))
+	
+
 /**
  * virtio_config_val - look for a feature and get a virtio config entry.
  * @vdev: the virtio device
@@ -120,7 +121,7 @@ static inline int virtio_config_buf(struct virtio_device *vdev,
 				    unsigned int offset,
 				    void *buf, unsigned len)
 {
-	if (!virtio_has_feature(vdev, fbit))
+	if (!__virtio_has_feature(vdev, fbit))
 		return -ENOENT;
 
 	vdev->config->get(vdev, offset, buf, len);
-- 
1.5.6.rc1.5.gadf6


