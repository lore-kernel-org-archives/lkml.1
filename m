Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbZHFNKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbZHFNKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbZHFNK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:10:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbZHFNK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:10:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/5] compat_ioctl: do not hold BKL in handlers
Date: Thu,  6 Aug 2009 15:09:30 +0200
Message-Id: <1249564170-18627-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249564170-18627-1-git-send-email-arnd@arndb.de>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+VA4Q/L42cxPvsQMmR4p6LuvjPFbjJvypIIwZ
 A5lQQ8zybFdpc9/fcvlBXTl5KCTkElp8ugqJy942p9gXB6TyVn
 xDTONXzg0bXdyZn6tq5bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have always called ioctl conversion handlers under the big
kernel lock, although that is generally not necessary. In particular
it is not needed for conversion of data structures and for calling
sys_ioctl or do_vfs_ioctl, which will get the BKL again if needed.

Handlers doing more than those two have been moved out, so we
can kill off the BKL from compat_sys_ioctl. This may significantly
improve latencies with 32 bit applications, and it avoids a common
scenario where a thread acquires the BKL twice.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5d800aa..86e6c75 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2637,9 +2637,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 
  found_handler:
 	if (t->handler) {
-		lock_kernel();
 		error = t->handler(fd, cmd, arg, filp);
-		unlock_kernel();
 		goto out_fput;
 	}
 
-- 
1.6.3.3

