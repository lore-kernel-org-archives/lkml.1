Return-Path: <linux-kernel-owner+w=401wt.eu-S932764AbXKPNlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbXKPNlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 08:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbXKPNlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 08:41:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758217AbXKPNlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:41:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MN10300: Fix MTD JEDEC probe so that the ASB2303 bootprom
	can be detected
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Fri, 16 Nov 2007 13:41:05 +0000
Message-ID: <20071116134105.3823.66507.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071116134100.3823.12894.stgit@warthog.procyon.org.uk>
References: <20071116134100.3823.12894.stgit@warthog.procyon.org.uk>
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
index a67b23b..734674d 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1868,11 +1868,18 @@ static inline __u8 finfo_uaddr(const struct amd_flash_info *finfo, int device_ty
 
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

