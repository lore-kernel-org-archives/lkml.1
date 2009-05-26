Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZEZXzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZEZXzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbZEZXym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38582 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZEZXyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:41 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/31] x86: MCE: Fix EIPV behaviour with !PCC
Date: Wed, 27 May 2009 01:54:05 +0200
Message-Id: <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

Impact: Spec compliance

When tolerant == 0, system should go panic instead of send SIGBUS even
for a MCE with EPIV && !PCC on user space.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3f158d7..e1271ac 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -485,7 +485,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * force_sig() takes an awful lot of locks and has a slight
 		 * risk of deadlocking.
 		 */
-		if (user_space) {
+		if (user_space && tolerant > 0) {
 			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
 			mce_panic("Uncorrected machine check",
-- 
1.6.0.2

