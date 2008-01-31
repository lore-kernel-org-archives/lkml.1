Return-Path: <linux-kernel-owner+w=401wt.eu-S935086AbYAaWPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935086AbYAaWPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934501AbYAaWKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:48 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40300 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934351AbYAaWKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:38 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] cpu: fix section mismatch related to cpu_chain
Date: Thu, 31 Jan 2008 23:10:33 +0100
Message-Id: <1201817440-5081-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: o-x86_64/kernel/built-in.o(.text+0x36de9): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36e86): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36ea9): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36f40): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36f8f): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x370aa): Section mismatch in reference from the function unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain

cpu_chain is used by unregister_cpu_notifier() that is used
by the kvm module. So we can call the unregister_cpu_notifier() long
after init completed.
Drop the __cpuinitdata annotation to avoid freeing cpu_chain.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2eff3f6..df9430f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -18,7 +18,7 @@
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
-static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
+static RAW_NOTIFIER_HEAD(cpu_chain);
 
 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
  * Should always be manipulated under cpu_add_remove_lock
-- 
1.5.4.rc3.14.g44397

