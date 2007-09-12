Return-Path: <linux-kernel-owner+w=401wt.eu-S1764495AbXILHqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764495AbXILHqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbXILHnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:46 -0400
Received: from ozlabs.org ([203.10.76.45]:46415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833AbXILHnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:45 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <628a383203480c3ce59125feccc32168de919014.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 07/15] Don't return -ENOSYS as extra notes size if spufs is not loaded
Date: Wed, 12 Sep 2007 17:43:44 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Because the SPU coredump code might be built as part of a module (spufs),
we have a stub which is called by the coredump code, this routine then calls
into spufs if it's loaded.

Unfortunately the stub returns -ENOSYS if spufs is not loaded, which is
interpreted by the coredump code as an extra note size of -38 bytes. This
leads to a corrupt core dump.

If spufs is not loaded there will be no SPU ELF notes to write, and so the
extra notes size will be == 0.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spu_coredump.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spu_coredump.c b/arch/powerpc/platforms/cell/spu_coredump.c
index 4fd37ff..656a8c5 100644
--- a/arch/powerpc/platforms/cell/spu_coredump.c
+++ b/arch/powerpc/platforms/cell/spu_coredump.c
@@ -31,15 +31,19 @@ static DEFINE_MUTEX(spu_coredump_mutex);
 
 int arch_notes_size(void)
 {
-	long ret;
+	int ret;
 
-	ret = -ENOSYS;
 	mutex_lock(&spu_coredump_mutex);
+
 	if (spu_coredump_calls && try_module_get(spu_coredump_calls->owner)) {
 		ret = spu_coredump_calls->arch_notes_size();
 		module_put(spu_coredump_calls->owner);
+	} else {
+		ret = 0;
 	}
+
 	mutex_unlock(&spu_coredump_mutex);
+
 	return ret;
 }
 
-- 
1.5.1.3.g7a33b

