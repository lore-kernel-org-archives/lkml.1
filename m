Return-Path: <linux-kernel-owner+w=401wt.eu-S932266Ab0AFPZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0AFPZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244Ab0AFPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:25:42 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40238 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab0AFPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:25:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Ralph Campbell <infinipath@qlogic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH] infiniband: use helpers for rlimits
Date: Wed,  6 Jan 2010 16:24:38 +0100
Message-Id: <1262791479-26594-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
References: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Roland Dreier <rolandd@cisco.com>
Cc: Ralph Campbell <infinipath@qlogic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 6f7c096..4f906f0 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -136,7 +136,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	down_write(&current->mm->mmap_sem);
 
 	locked     = npages + current->mm->locked_vm;
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
 	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/ipath/ipath_user_pages.c b/drivers/infiniband/hw/ipath/ipath_user_pages.c
index 82878e3..eb7d59a 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -59,8 +59,7 @@ static int __get_user_pages(unsigned long start_page, size_t num_pages,
 	size_t got;
 	int ret;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >>
-		PAGE_SHIFT;
+	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
 	if (num_pages > lock_limit) {
 		ret = -ENOMEM;
