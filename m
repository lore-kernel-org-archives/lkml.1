Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbZLKPhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbZLKPhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbZLKPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:37:26 -0500
Received: from mail.windriver.com ([147.11.1.11]:57540 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbZLKPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:37:20 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 8/9] kgdb: continue and warn on signal passing from gdb
Date: Fri, 11 Dec 2009 09:36:16 -0600
Message-Id: <1260545777-8089-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-8-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-4-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-5-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-6-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-7-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:35.0472 (UTC) FILETIME=[B8DDC900:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures for the segv trap, gdb wants to pass the signal
back on continue.  For kgdb this is not the default behavior, because
it can cause the kernel to crash if you arbitrarily pass back a
exception outside of kgdb.

Instead of causing instability, pass a message back to gdb about the
supported kgdb signal passing and execute a standard kgdb continue
operation.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index ca21fe9..8584eac 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1210,8 +1210,10 @@ static int gdb_cmd_exception_pass(struct kgdb_state *ks)
 		return 1;
 
 	} else {
-		error_packet(remcom_out_buffer, -EINVAL);
-		return 0;
+		kgdb_msg_write("KGDB only knows signal 9 (pass)"
+			" and 15 (pass and disconnect)\n"
+			"Executing a continue without signal passing\n", 0);
+		remcom_in_buffer[0] = 'c';
 	}
 
 	/* Indicate fall through */
-- 
1.6.4.rc1

