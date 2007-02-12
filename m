Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXBLFuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXBLFuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXBLFuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:50:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005AbXBLFuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:50:17 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 12 Feb 2007 16:49:41 +1100
Message-Id: <1070212054941.26775@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 4] knfsd: Fix return value for writes to some files in 'nfsd' filesystem.
References: <20070212164133.26352.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Most files in the 'nfsd' filesystem are transactional.
When you write, a reply is generated that can be read back
only on the same 'file'.
If the reply has zero length, the 'write' will incorrectly 
return a value of '0' instead of the length that was
written.  This causes 'rpc.nfsd' to give an annoying warning.

This patch fixes the test.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfsctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/fs/nfsd/nfsctl.c ./fs/nfsd/nfsctl.c
--- .prev/fs/nfsd/nfsctl.c	2007-02-12 16:39:20.000000000 +1100
+++ ./fs/nfsd/nfsctl.c	2007-02-12 16:39:33.000000000 +1100
@@ -123,7 +123,7 @@ static ssize_t nfsctl_transaction_write(
 		return PTR_ERR(data);
 
 	rv =  write_op[ino](file, data, size);
-	if (rv>0) {
+	if (rv >= 0) {
 		simple_transaction_set(file, rv);
 		rv = size;
 	}
