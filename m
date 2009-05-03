Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZECWUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZECWUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZECWUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 18:20:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbZECWUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 18:20:09 -0400
Date: Mon, 4 May 2009 00:15:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: Daniel Krueger <daniel.krueger@systec-electronic.com>,
       Ronald Sieber <Ronald.Sieber@systec-electronic.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/epl: do not use CLONE_SIGHAND with
	allow_signal()
Message-ID: <20090503221531.GA26415@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure this patch is really needed since kernel_thread() is deprecated
(and checkpatch.pl complains).

But we should not use kernel_thread(CLONE_SIGHAND) if we are going to play
with signals.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 drivers/staging/epl/EplSdoUdpu.c         |    3 ++-
 drivers/staging/epl/ShbIpc-LinuxKernel.c |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- PTRACE/drivers/staging/epl/EplSdoUdpu.c~AS_2	2009-04-06 00:03:39.000000000 +0200
+++ PTRACE/drivers/staging/epl/EplSdoUdpu.c	2009-05-04 00:03:50.000000000 +0200
@@ -334,7 +334,8 @@ tEplKernel EplSdoUdpuConfig(unsigned lon
 	}
 	// create Listen-Thread
 	SdoUdpInstance_g.m_ThreadHandle =
-	    kernel_thread(EplSdoUdpThread, &SdoUdpInstance_g, CLONE_KERNEL);
+		kernel_thread(EplSdoUdpThread, &SdoUdpInstance_g,
+				CLONE_FS | CLONE_FILES);
 	if (SdoUdpInstance_g.m_ThreadHandle == 0) {
 		Ret = kEplSdoUdpThreadError;
 		goto Exit;
--- PTRACE/drivers/staging/epl/ShbIpc-LinuxKernel.c~AS_2	2009-04-06 00:03:39.000000000 +0200
+++ PTRACE/drivers/staging/epl/ShbIpc-LinuxKernel.c	2009-05-03 23:54:04.000000000 +0200
@@ -532,8 +532,8 @@ tShbError ShbIpcStartSignalingNewData(tS
 
 	//create thread for signalling new data
 	pShbMemInst->m_tThreadNewDataId =
-	    kernel_thread(ShbIpcThreadSignalNewData, pShbInstance_p,
-			  CLONE_KERNEL);
+		kernel_thread(ShbIpcThreadSignalNewData, pShbInstance_p,
+				CLONE_FS | CLONE_FILES);
 
       Exit:
 	return ShbError;
@@ -636,8 +636,8 @@ tShbError ShbIpcStartSignalingJobReady(t
 	pShbMemHeader->m_fJobReady = FALSE;
 	//create thread for signalling new data
 	pShbMemInst->m_tThreadJobReadyId =
-	    kernel_thread(ShbIpcThreadSignalJobReady, pShbInstance_p,
-			  CLONE_KERNEL);
+		kernel_thread(ShbIpcThreadSignalJobReady, pShbInstance_p,
+				CLONE_FS | CLONE_FILES);
       Exit:
 	return ShbError;
 }

