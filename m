Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbXFERtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbXFERtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbXFERsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:48:53 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34434 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbXFERsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:48:52 -0400
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [PATCH 2/3] [PATCH powerpc] during VM oom condition,
	kill all threads in process group
To: linux-kernel@vger.kernel.org
Cc: anton@samba.org, liuxppc-dev@ozlabs.org, will_schmidt@vnet.ibm.com
Date: Tue, 05 Jun 2007 12:48:38 -0500
Message-ID: <20070605174838.21740.55720.stgit@farscape.rchland.ibm.com>
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

Tested on POWER5.

Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
---

 arch/powerpc/mm/fault.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 03aeb3a..9afe871 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -392,8 +392,10 @@ out_of_memory:
 		goto survive;
 	}
 	printk("VM: killing process %s\n", current->comm);
-	if (user_mode(regs))
+	if (user_mode(regs)) {
+		zap_other_threads(current);
 		do_exit(SIGKILL);
+	}
 	return SIGKILL;
 
 do_sigbus:


