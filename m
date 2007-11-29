Return-Path: <linux-kernel-owner+w=401wt.eu-S934403AbXK2W4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbXK2W4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933741AbXK2WyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:54:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934100AbXK2Wxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:53:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 9/9] MN10300: Fix MTD JEDEC probe so that the ASB2303 bootprom
	can be detected [2.6.24-rc3-mm2]
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 22:53:01 +0000
Message-ID: <20071129225301.21536.91506.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
References: <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix MTD JEDEC probe so that the ASB2303 bootprom can be accessed.  This is
presumably required because the bootprom is normally write-protected and so
the normal flash probes don't work as they require the ability to write to the
flash to send it commands.

In the condition of the excluded if-statement, uaddr is 1.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/mtd/chips/jedec_probe.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index 5074b5e..01a0550 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1883,11 +1883,18 @@ static inline __u8 finfo_uaddr(const struct amd_flash_info *finfo, int device_ty
 
 	uaddr = finfo->uaddr[uaddr_idx];
 
+	/* the MN10300 ASB2303 board doesn't detect its bootprom if this test
+	 * is allowed to take place, presumably because the flash is
+	 * write-protected and so cannot be commanded for the purposes of
+	 * probing
+	 */
+#ifndef CONFIG_MN10300_UNIT_ASB2303
 	if (uaddr != MTD_UADDR_NOT_SUPPORTED ) {
 		/* ASSERT("The unlock addresses for non-8-bit mode
 		   are bollocks. We don't really need an array."); */
 		uaddr = finfo->uaddr[0];
 	}
+#endif
 
  uaddr_done:
 	return uaddr;

