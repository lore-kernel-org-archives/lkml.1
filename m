Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYLCUNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYLCUNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbYLCTyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:35 -0500
Received: from kroah.org ([198.145.64.141]:60303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754346AbYLCTyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:31 -0500
Date: Wed, 3 Dec 2008 11:52:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Kou Ishizaki <kou.ishizaki@toshiba.co.jp>,
       Jeremy Kerr <jk@ozlabs.org>, Andre Detsch <adetsch@br.ibm.com>
Subject: [patch 058/104] powerpc/spufs: add a missing mutex_unlock
Message-ID: <20081203195252.GG8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-spufs-add-a-missing-mutex_unlock.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>

commit 6747c2ee8abf749e63fee8cd01a9ee293e6a4247 upstream.

A mutex_unlock(&gang->aff_mutex) in spufs_create_context() is missing
in case spufs_context_open() fails.  As a result, spu_create syscall
and spu_get_idle() may block.

This patch adds the mutex_unlock.

Signed-off-by: Kou Ishizaki <kou.ishizaki@toshiba.co.jp>
Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Acked-by: Andre Detsch <adetsch@br.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/cell/spufs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -496,6 +496,8 @@ spufs_create_context(struct inode *inode
 	ret = spufs_context_open(dget(dentry), mntget(mnt));
 	if (ret < 0) {
 		WARN_ON(spufs_rmdir(inode, dentry));
+		if (affinity)
+			mutex_unlock(&gang->aff_mutex);
 		mutex_unlock(&inode->i_mutex);
 		spu_forget(SPUFS_I(dentry->d_inode)->i_ctx);
 		goto out;

