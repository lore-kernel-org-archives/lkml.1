Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYJCQ1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYJCQ1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYJCQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:27:11 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:38197 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYJCQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:27:10 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
Date: Fri, 3 Oct 2008 18:25:44 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
References: <200810031041.49350.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030825190.3262@nehalem.linux-foundation.org> <200810031755.55931.borntraeger@de.ibm.com>
In-Reply-To: <200810031755.55931.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031825.44706.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seems to fix it. Comments?

kernel_init uses lock_kernel to serialize the initialization. If the driver
is compiled into the kernel, the probe function of e1000e is called under 
this lock and therefore the WARN_ON(preempt_count()) triggers. We can now 
1. remove this WARN_ON
2. check for SYSTEM_RUNNING

This patch implements 2.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 0b6095b..cca9731 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -396,7 +396,7 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
 	u32 extcnf_ctrl;
 	u32 timeout = PHY_CFG_TIMEOUT;
 
-	WARN_ON(preempt_count());
+	WARN_ON(system_state == SYSTEM_RUNNING && preempt_count());
 
 	if (!mutex_trylock(&nvm_mutex)) {
 		WARN(1, KERN_ERR "e1000e mutex contention. Owned by pid %d\n",
