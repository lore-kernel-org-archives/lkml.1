Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXFERs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXFERs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbXFERss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:48:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34356 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbXFERsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:48:47 -0400
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [PATCH 1/3] [PATCH i386] during VM oom condition,
	kill all threads in process group
To: linux-kernel@vger.kernel.org
Cc: anton@samba.org, liuxppc-dev@ozlabs.org, will_schmidt@vnet.ibm.com
Date: Tue, 05 Jun 2007 12:48:32 -0500
Message-ID: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When we get into a state where VM has ran out of memory, and it's time to
thwack a process, we should take out the entire process group, rather than 
just one thread.

Tested on i386

Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
---

 arch/i386/mm/fault.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index b8c4e25..82aec0e 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -567,8 +567,10 @@ out_of_memory:
 		goto survive;
 	}
 	printk("VM: killing process %s\n", tsk->comm);
-	if (error_code & 4)
+	if (error_code & 4) {
+		zap_other_threads(tsk);
 		do_exit(SIGKILL);
+	}
 	goto no_context;
 
 do_sigbus:


