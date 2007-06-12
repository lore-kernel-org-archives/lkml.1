Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbXFLPTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbXFLPTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbXFLPT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:19:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46815 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbXFLPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:19:25 -0400
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [PATCH 2/3] x86_64: During VM oom condition,
	kill all threads in process group
To: linuxppc-dev@ozlabs.org, anton@samba.org, linux-kernel@vger.kernel.org
Cc: will_schmidt@vnet.ibm.com
Date: Tue, 12 Jun 2007 10:19:07 -0500
Message-ID: <20070612151907.2869.47551.stgit@farscape.rchland.ibm.com>
In-Reply-To: <20070612151901.2869.59390.stgit@farscape.rchland.ibm.com>
References: <20070612151901.2869.59390.stgit@farscape.rchland.ibm.com>
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

Signed-off-by: Will <will_schmidt@vnet.ibm.com>
---

 arch/x86_64/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 6ada723..328d504 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -563,7 +563,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & 4)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:


