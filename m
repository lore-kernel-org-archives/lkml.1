Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZKEPkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZKEPkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZKEPkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:40:13 -0500
Received: from smtp6.netcologne.de ([194.8.194.26]:58511 "EHLO
	smtp6.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbZKEPkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:40:12 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2009 10:40:12 EST
From: Max Kellermann <max@duempel.org>
Subject: [PATCH] pipe: don't block after data has been written
To: linux-kernel@vger.kernel.org
Cc: eric.dumazet@gmail.com, mk@cm4all.com
Date: Thu, 05 Nov 2009 16:31:47 +0100
Message-ID: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the select() / poll() documentation, a write operation on
a file descriptor which is "ready for writing" must not block.  Linux
violates this rule: if you pass a very large buffer to write(), the
system call will not return until everything is written, or an error
occurs.

This patch adds a simple check: if at least one byte has already been
written, break from the loop, instead of calling pipe_wait().

Signed-off-by: Max Kellermann <max@duempel.org>
---

 fs/pipe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index ae17d02..9d84f0b 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -582,7 +582,7 @@ redo2:
 		}
 		if (bufs < PIPE_BUFFERS)
 			continue;
-		if (filp->f_flags & O_NONBLOCK) {
+		if (filp->f_flags & O_NONBLOCK || ret > 0) {
 			if (!ret)
 				ret = -EAGAIN;
 			break;

