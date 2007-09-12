Return-Path: <linux-kernel-owner+w=401wt.eu-S1765466AbXILHtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765466AbXILHtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763725AbXILHnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:53 -0400
Received: from ozlabs.org ([203.10.76.45]:46539 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762371AbXILHnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:52 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <0bf2b252a7732efc87b91be2dc355c94a71806c3.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 14/15] Respect RLIMIT_CORE in spu coredump code
Date: Wed, 12 Sep 2007 17:43:51 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the spu coredump code doesn't respect the ulimit, it should.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index c3b5cd5..b8ab2c6 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -53,8 +53,12 @@ static ssize_t do_coredump_read(int num, struct spu_context *ctx, void *buffer,
  */
 static int spufs_dump_write(struct file *file, const void *addr, int nr, loff_t *foffset)
 {
+	unsigned long limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 	ssize_t written;
 
+	if (*foffset + nr > limit)
+		return -EIO;
+
 	written = file->f_op->write(file, addr, nr, &file->f_pos);
 	*foffset += written;
 
-- 
1.5.1.3.g7a33b

