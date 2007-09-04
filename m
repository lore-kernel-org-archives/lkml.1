Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXIDGhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXIDGhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 02:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXIDGhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 02:37:47 -0400
Received: from ozlabs.org ([203.10.76.45]:43800 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbXIDGhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 02:37:46 -0400
To: Andrew Morton <akpm@osdl.org>
Cc: <jeremy@xensource.com>, <ak@suse.de>, <rusty@rustcorp.com.au>,
       <dhowells@redhat.com>, <B.Steinbrink@gmx.de>, <randy.dunlap@oracle.com>,
       <linux-kernel@vger.kernel.org>
Message-Id: <a96a9b883c735b73866cf39997bdc8d5f9f1c451.1188887696.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] Restore call_usermodehelper_pipe() behaviour
Date: Tue,  4 Sep 2007 16:37:45 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The semantics of call_usermodehelper_pipe() used to be that it would fork
the helper, and wait for the kernel thread to be started. This was
implemented by setting sub_info.wait to 0 (implicitly), and doing a
wait_for_completion().

As part of the cleanup done in 0ab4dc92278a0f3816e486d6350c6652a72e06c8,
call_usermodehelper_pipe() was changed to pass 1 as the value for wait to
call_usermodehelper_exec().

This is equivalent to setting sub_info.wait to 1, which is a change from
the previous behaviour. Using 1 instead of 0 causes __call_usermodehelper()
to start the kernel thread running wait_for_helper(), rather than directly
calling ____call_usermodehelper().

The end result is that the calling kernel code blocks until the user mode
helper finishes. As the helper is expecting input on stdin, and now no one
is writing anything, everything locks up (observed in do_coredump).

The fix is to change the 1 to UMH_WAIT_EXEC (aka 0), indicating that we want
to wait for the kernel thread to be started, but not for the helper to finish.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 kernel/kmod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 9809cc1..c6a4f8a 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -505,7 +505,7 @@ int call_usermodehelper_pipe(char *path, char **argv, char **envp,
 	if (ret < 0)
 		goto out;
 
-	return call_usermodehelper_exec(sub_info, 1);
+	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
 
   out:
 	call_usermodehelper_freeinfo(sub_info);
-- 
1.5.1.3.g7a33b

