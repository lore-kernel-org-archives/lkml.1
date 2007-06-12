Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXFLPUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXFLPUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbXFLPT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:19:27 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55094 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132AbXFLPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:19:25 -0400
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [PATCH 1/3] powerpc: during VM oom condition,
	kill all threads in process group
To: linuxppc-dev@ozlabs.org, anton@samba.org, linux-kernel@vger.kernel.org
Cc: will_schmidt@vnet.ibm.com
Date: Tue, 12 Jun 2007 10:19:01 -0500
Message-ID: <20070612151901.2869.59390.stgit@farscape.rchland.ibm.com>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


During a VM oom condition, kill all threads in the process group.

We have had complaints where a threaded application is left in a bad state
after one of it's threads is killed when we hit a VM: out_of_memory
condition.

Killing just one of the process threads can leave the application in a
bad state, whereas killing the entire process group would
allow for the application to restart, or otherwise handled, and makes it
very obvious that something has gone wrong.

This change allows the entire process group to be taken down, rather than
just the one thread.

lightly tested on powerpc

Signed-off-by: Will <will_schmidt@vnet.ibm.com>
---

 arch/powerpc/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 03aeb3a..de1dcee 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -393,7 +393,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", current->comm);
 	if (user_mode(regs))
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	return SIGKILL;
 
 do_sigbus:


