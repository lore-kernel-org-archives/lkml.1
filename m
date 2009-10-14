Return-Path: <linux-kernel-owner+w=401wt.eu-S1761945AbZJNQHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761945AbZJNQHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761898AbZJNQHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:07:17 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:39754 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761847AbZJNQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:07:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] compat_ioctl: do not hold BKL in handlers
Date: Wed, 14 Oct 2009 18:00:36 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Greg KH <greg@kroah.com>
References: <20091010153314.827301943@linutronix.de> <200910141759.35162.arnd@arndb.de>
In-Reply-To: <200910141759.35162.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910141800.36889.arnd@arndb.de>
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 40904c6..320786e 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2663,9 +2663,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 
  found_handler:
 	if (t->handler) {
-		lock_kernel();
 		error = t->handler(fd, cmd, arg, filp);
-		unlock_kernel();
 		goto out_fput;
 	}
 
-- 
1.6.3.3

