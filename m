Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXGTTNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXGTTNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbXGTTN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:13:27 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:1177 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbXGTTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:13:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAN+loEarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,563,1175497200"; 
   d="scan'208"; a="185808708:sNHT24800283"
To: Pekka J Enberg <penberg@cs.helsinki.fi>, torvalds@linux-foundation.org
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: [PATCH] Fix ZERO_OR_NULL_PTR(ZERO_SIZE_PTR)
X-Message-Flag: Warning: May contain useful information
References: <200707191201.35777.ak@suse.de>
	<84144f020707190708p1c4d63cnbb0397a602c3527d@mail.gmail.com>
	<adamyxsfmnc.fsf@cisco.com>
	<Pine.LNX.4.64.0707201009580.1209@sbz-30.cs.Helsinki.FI>
	<Pine.LNX.4.64.0707201017450.1209@sbz-30.cs.Helsinki.FI>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 12:13:20 -0700
In-Reply-To: <Pine.LNX.4.64.0707201017450.1209@sbz-30.cs.Helsinki.FI> (Pekka J. Enberg's message of "Fri, 20 Jul 2007 10:18:49 +0300 (EEST)")
Message-ID: <adamyxqc2i7.fsf_-_@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jul 2007 19:13:20.0653 (UTC) FILETIME=[091BABD0:01C7CB02]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The comparison with ZERO_SIZE_PTR in ZERO_OR_NULL_PTR() needs to be <=
(not just <) so that ZERO_OR_NULL_PTR(ZERO_SIZE_PTR) is 1.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
I finally had time to reproduce Michael's crash and debug it.  Linus's
patch is part of the story -- it doesn't help unless ZERO_OR_NULL_PTR()
is true.  With this change the crash goes away, and it seems pretty
obviously correct to me (unless I'm seriously confused).

 include/linux/slab.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 7d0ecc1..d859354 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -40,7 +40,7 @@
  */
 #define ZERO_SIZE_PTR ((void *)16)
 
-#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) < \
+#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
 				(unsigned long)ZERO_SIZE_PTR)
 
 /*
