Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYBRQIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYBRQIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:08:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYBRQHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:07:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:30064 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYBRQHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:07:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g1/K5UTXTmGjuOxaz7H/jnjkDVSardJfMyzMq+4ICAqAmlZXEdMy9XDCYTKn+TYo4tC7c1S+ZvCE4QSL7XqfGtvHZZjzN5mwrrrEy3nlwaQZJ5qk7CBe4wIpCCbzyfykdPTFOanaxdLS44wb43Kx/9fpDH2Goq3yvVNN2r/7BsQ=
Subject: [PATCH] ata: replace macro with static inline in libata.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 08:07:53 -0800
Message-Id: <1203350873.5757.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid ~70 sparse warnings like:
drivers/ata/pata_ali.c:176:14: warning: symbol '__x' shadows an earlier one
drivers/ata/pata_ali.c:176:14: originally declared here

Due to nesting min_t macro inside max_t macro which both use a __x
identifier internally.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, here is a patch that drastically reduces the number of sparse
warnings in libata.  Alan Cox has suggested a clamp_t macro be added
to kernel.h instead to avoid this issue.  I don't believe Jeff Garzik
has given an opinion yet (other than not applying it when originally
sent this was 5/11 of the libata sparse warnings)

 include/linux/libata.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index bc5a8d0..b5590fb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -764,7 +764,14 @@ struct ata_timing {
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
 
-#define FIT(v, vmin, vmax)	max_t(short, min_t(short, v, vmax), vmin)
+static inline short FIT(short v, short vmin, short vmax)
+{
+	if (v >= vmax)
+		return vmax;
+	if (v <= vmin)
+		return vmin;
+	return v;
+}
 
 extern const unsigned long sata_deb_timing_normal[];
 extern const unsigned long sata_deb_timing_hotplug[];
-- 
1.5.4.1.1278.gc75be



