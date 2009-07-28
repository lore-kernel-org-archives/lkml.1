Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZG1NOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZG1NOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZG1NOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:14:38 -0400
Received: from server1.wserver.cz ([82.113.45.157]:43251 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZG1NOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:14:37 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] UIO: unbreak uio.h userspace compilation
Date: Tue, 28 Jul 2009 15:14:37 +0200
Message-Id: <1248786877-10571-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid userspace build failures such as:
.../linux/uio.h:37: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘iov_length’
.../linux/uio.h:47: error: expected declaration specifiers or ‘...’ before ‘size_t’
move one uio declaration inside a __KERNEL__ block and use __kernel_size_t
instead of size_t for iov_length (it's inlined and used in userspace already).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/uio.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index b7fe138..9b2623c 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -42,16 +42,18 @@ struct kvec {
  * segment lengths have been validated.  Because the individual lengths can
  * overflow a size_t when added together.
  */
-static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
+static inline __kernel_size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
 {
 	unsigned long seg;
-	size_t ret = 0;
+	__kernel_size_t ret = 0;
 
 	for (seg = 0; seg < nr_segs; seg++)
 		ret += iov[seg].iov_len;
 	return ret;
 }
 
+#ifdef __KERNEL__
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
+#endif
 
 #endif
-- 
1.6.3.3

