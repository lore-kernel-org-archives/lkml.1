Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYJ3CqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYJ3CqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 22:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYJ3CqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 22:46:09 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:59874 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYJ3CqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 22:46:08 -0400
X-Greylist: delayed 2637 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2008 22:46:08 EDT
Date: Wed, 29 Oct 2008 19:02:03 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       tim@scalemp.com, shai@scalex86.org
Subject: [patch] x86: Fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081030020203.GA12423@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix mmap to /dev/mem when CONFIG_X86_PAT is off and CONFIG_STRICT_DEVMEM is
off

mmap to /dev/mem on kernel memory has been failing since the
introduction of PAT (CONFIG_STRICT_DEVMEM=n case).   Seems like
the check to avoid cache aliasing with PAT is kicking in even
when PAT is disabled. The bug seems to have crept in 2.6.26.

This patch makes sure that mmap to regular kernel memory
succeeds if CONFIG_STRICT_DEVMEM=n and
PAT is disabled.  The checks to avoid cache aliasing
still happens if PAT is enabled.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Tested-by: Tim Sirianni <tim@scalemp.com>

Index: git.tip/arch/x86/mm/pat.c
===================================================================
--- git.tip.orig/arch/x86/mm/pat.c	2008-10-21 14:02:57.000000000 -0700
+++ git.tip/arch/x86/mm/pat.c	2008-10-29 13:19:47.000000000 -0800
@@ -481,6 +481,7 @@
 	return 1;
 }
 #else
+/* This check is needed to avoid cache aliasing when PAT is enabled */
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
@@ -508,7 +509,8 @@
 	unsigned long flags = -1;
 	int retval;
 
-	if (!range_is_allowed(pfn, size))
+	/* Ensure cache aliasing does not occur if and only if PAT is on */
+	if (pat_enabled && !range_is_allowed(pfn, size))
 		return 0;
 
 	if (file->f_flags & O_SYNC) {
