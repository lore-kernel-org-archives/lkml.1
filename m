Return-Path: <linux-kernel-owner+w=401wt.eu-S1765008AbXFERtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765008AbXFERtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbXFERsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:48:53 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37251 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbXFERsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:48:52 -0400
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [PATCH 3/3] [PATCH x86_64] during VM oom condition,
	kill all threads in process group
To: linux-kernel@vger.kernel.org
Cc: anton@samba.org, liuxppc-dev@ozlabs.org, will_schmidt@vnet.ibm.com
Date: Tue, 05 Jun 2007 12:48:44 -0500
Message-ID: <20070605174843.21740.14223.stgit@farscape.rchland.ibm.com>
In-Reply-To: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
References: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When we get into a state where VM has ran out of memory, and it's time to
thwack a process, we should take out the entire process group, rather than 
just one thread.

Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
---

 arch/x86_64/mm/fault.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 6ada723..2a3060e 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -562,8 +562,10 @@ out_of_memory:
 		goto again;
 	}
 	printk("VM: killing process %s\n", tsk->comm);
-	if (error_code & 4)
+	if (error_code & 4) {
+		zap_other_threads(tsk);
 		do_exit(SIGKILL);
+	}
 	goto no_context;
 
 do_sigbus:


