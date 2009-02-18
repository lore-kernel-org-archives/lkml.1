Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbZBRJgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbZBRJgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZBRJfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:35:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45323
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbZBRJfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:35:38 -0500
Date: Wed, 18 Feb 2009 01:35:23 -0800 (PST)
Message-Id: <20090218.013523.148813511.davem@davemloft.net>
To: airlied@linux.ie
CC: benh@kernel.crashing.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: drm: radeon: Fix unaligned access in r300_scratch().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drm: radeon: Fix unaligned access in r300_scratch().

In compat mode, the cmdbuf->buf 64-bit address cookie can
potentially be only 32-bit aligned.  Dereferencing this as
64-bit causes expensive unaligned traps on platforms like
sparc64.

Use get_unaligned() to fix.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/gpu/drm/radeon/r300_cmdbuf.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
index cace396..3efa633 100644
--- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -37,6 +37,8 @@
 #include "radeon_drv.h"
 #include "r300_reg.h"
 
+#include <asm/unaligned.h>
+
 #define R300_SIMULTANEOUS_CLIPRECTS		4
 
 /* Values for R300_RE_CLIPRECT_CNTL depending on the number of cliprects
@@ -917,6 +919,7 @@ static int r300_scratch(drm_radeon_private_t *dev_priv,
 {
 	u32 *ref_age_base;
 	u32 i, buf_idx, h_pending;
+	u64 ptr_addr;
 	RING_LOCALS;
 
 	if (cmdbuf->bufsz <
@@ -930,7 +933,8 @@ static int r300_scratch(drm_radeon_private_t *dev_priv,
 
 	dev_priv->scratch_ages[header.scratch.reg]++;
 
-	ref_age_base =  (u32 *)(unsigned long)*((uint64_t *)cmdbuf->buf);
+	ptr_addr = get_unaligned((u64 *)cmdbuf->buf);
+	ref_age_base = (u32 *)(unsigned long)ptr_addr;
 
 	cmdbuf->buf += sizeof(u64);
 	cmdbuf->bufsz -= sizeof(u64);
-- 
1.6.1.2.350.g88cc

