Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYINREB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYINREB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 13:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYINRDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 13:03:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:50650 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYINRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 13:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=kJZRj+LfDh1Y1bcYImD97IP8VFyvLFigTBukHjAQwnaoyhU+bQ4Bv8nVY9hdvzg9Qp
         DPM4pdJZbLUt0QcPuZST61GoVxA5aHth3gVXS14EELgqnkTkOsiK12cfGoEyokazgBre
         YCmAi8XN/1HrfCKE/qTPIBKulBNgw2TySqUiM=
Date: Sun, 14 Sep 2008 19:03:53 +0200
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] x86: add memory clobber in switch_to()
Message-ID: <20080914170353.GA15729@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are more places which have segment register reloads without
adding memory clobbers. Should we fix them up? Here's one of them:

>From 5f135687f7730fbdd979b6fb408fd3ca08a0a678 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 14 Sep 2008 18:53:22 +0200
Subject: [PATCH] x86: add memory clobber in switch_to()

Segment registers are reloaded, so we should add a memory clobber. The
generated assembly code is identical in my tests, but this doesn't mean
it is necessarily true for all configurations/compilers.

x86_64 already has the memory clobber.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/asm-x86/system.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 983ce37..fed6482 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -64,7 +64,10 @@ do {									\
 		       							\
 		       /* regparm parameters for __switch_to(): */	\
 		       [prev]     "a" (prev),				\
-		       [next]     "d" (next));				\
+		       [next]     "d" (next)				\
+									\
+		     : /* reloaded segment registers */			\
+			"memory");					\
 } while (0)
 
 /*
-- 
1.5.5.1

