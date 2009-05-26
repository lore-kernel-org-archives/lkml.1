Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZEZX4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZEZX4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbZEZXyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38595 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbZEZXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:42 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/31] x86: MCE: Log corrected errors when panicing
Date: Wed, 27 May 2009 01:54:09 +0200
Message-Id: <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: bugfix

Normally the machine check handler ignores corrected errors and leaves
them to machine_check_poll(). But when panicing mcp won't run, so
log all errors.

Note: this can still miss some cases until the "early no way out"
patch later is applied too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d2d7a68..d379e3f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -398,9 +398,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 		/*
 		 * Non uncorrected errors are handled by machine_check_poll
-		 * Leave them alone.
+		 * Leave them alone, unless this panics.
 		 */
-		if ((m.status & MCI_STATUS_UC) == 0)
+		if ((m.status & MCI_STATUS_UC) == 0 && !no_way_out)
 			continue;
 
 		/*
-- 
1.6.0.2

