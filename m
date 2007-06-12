Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXFLPTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXFLPTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXFLPTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:19:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52719 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbXFLPTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:19:20 -0400
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: [PATCH 3/3] i386: During VM oom condition,
	kill all threads in process group
To: linuxppc-dev@ozlabs.org, anton@samba.org, linux-kernel@vger.kernel.org
Cc: will_schmidt@vnet.ibm.com
Date: Tue, 12 Jun 2007 10:19:13 -0500
Message-ID: <20070612151912.2869.43167.stgit@farscape.rchland.ibm.com>
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
allow for the application to restart, or otherwise handled, and makes it very
obvious that something has gone wrong.

This change allows the entire process group to be taken down, rather than
just the one thread.

tested lightly on i386.

Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
---

 arch/i386/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
index b8c4e25..a47e712 100644
--- a/arch/i386/mm/fault.c
+++ b/arch/i386/mm/fault.c
@@ -568,7 +568,7 @@ out_of_memory:
 	}
 	printk("VM: killing process %s\n", tsk->comm);
 	if (error_code & 4)
-		do_exit(SIGKILL);
+		do_group_exit(SIGKILL);
 	goto no_context;
 
 do_sigbus:


