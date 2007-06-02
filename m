Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbXFBVhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbXFBVhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 17:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbXFBVhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 17:37:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43287 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053AbXFBVha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 17:37:30 -0400
Date: Sat, 2 Jun 2007 23:38:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix section mismatch warning in initel_cacheinfo
Message-ID: <20070602213831.GA14124@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3818): Section mismatch: reference to .exit.text:cache_remove_dev (between 'cacheinfo_cpu_callback' and 'cache_sysfs_init')

It points out that a function marked __cpuexit is calling
a function marked __cpuinit => oops.
The call happens only in an error-condition which may explain
why we have not seen it before.
The offending function was not used anywhere else - so
marked it __cpuexit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

Note: This warning triggers only with a local copy of modpost
      but that version will soon be pushed out.

	Sam

diff --git a/arch/i386/kernel/cpu/intel_cacheinfo.c b/arch/i386/kernel/cpu/intel_cacheinfo.c
index e5be819..0617bb3 100644
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ b/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -710,7 +710,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	return retval;
 }
 
-static void __cpuexit cache_remove_dev(struct sys_device * sys_dev)
+static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
