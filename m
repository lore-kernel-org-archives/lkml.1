Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0BDRVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:21:39 -0500
Received: from kroah.org ([198.145.64.141]:34608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968Ab0BDRVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:34 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:52 2010
Message-Id: <20100204171452.218912543@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Felix Beck <felix.beck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [10/74] [S390] zcrypt: Do not remove coprocessor for error 8/72
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Beck <felix.beck@de.ibm.com>

commit 19b123ebacacdce5e75045bfe82122b01c821a5b upstream.

In a case where the number of the input data is bigger than the
modulus of the key, the coprocessor adapters will report an 8/72
error. This case is not caught yet, thus the adapter will be taken
offline. To prevent this, we return an -EINVAL instead.

Signed-off-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/crypto/zcrypt_pcicc.c  |    2 ++
 drivers/s390/crypto/zcrypt_pcixcc.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/s390/crypto/zcrypt_pcicc.c
+++ b/drivers/s390/crypto/zcrypt_pcicc.c
@@ -373,6 +373,8 @@ static int convert_type86(struct zcrypt_
 			zdev->max_mod_size = PCICC_MAX_MOD_SIZE_OLD;
 			return -EAGAIN;
 		}
+		if (service_rc == 8 && service_rs == 72)
+			return -EINVAL;
 		zdev->online = 0;
 		return -EAGAIN;	/* repeat the request on a different device. */
 	}
--- a/drivers/s390/crypto/zcrypt_pcixcc.c
+++ b/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -462,6 +462,8 @@ static int convert_type86_ica(struct zcr
 		}
 		if (service_rc == 12 && service_rs == 769)
 			return -EINVAL;
+		if (service_rc == 8 && service_rs == 72)
+			return -EINVAL;
 		zdev->online = 0;
 		return -EAGAIN;	/* repeat the request on a different device. */
 	}


