Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYJ3U7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYJ3U7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYJ3U7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:59:39 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:51073 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYJ3U7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:59:38 -0400
Date: Thu, 30 Oct 2008 13:59:21 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       tim@scalemp.com, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: Fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081030205921.GA6583@localdomain>
References: <20081030020203.GA12423@localdomain> <20081030182902.GF14102@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030182902.GF14102@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 07:29:02PM +0100, Ingo Molnar wrote:
>
>I guess it might be cleaner to push this check into the 
>range_is_allowed() function?
>

OK.  Here it is.


Fix mmap to /dev/mem when CONFIG_X86_PAT is off and CONFIG_STRICT_DEVMEM is
off

mmap to /dev/mem on kernel memory has been failing since the
introduction of PAT (CONFIG_STRICT_DEVMEM=n case).   Seems like
the check to avoid cache aliasing with PAT is kicking in even
when PAT is disabled. The bug seems to have crept in 2.6.26.

This patch makes sure that the mmap to regular
kernel memory succeeds if CONFIG_STRICT_DEVMEM=n and
PAT is disabled, and the checks to avoid cache aliasing
still happens if PAT is enabled.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Tested-by: Tim Sirianni <tim@scalemp.com>

Index: git.tip/arch/x86/mm/pat.c
===================================================================
--- git.tip.orig/arch/x86/mm/pat.c	2008-10-29 13:19:51.000000000 -0800
+++ git.tip/arch/x86/mm/pat.c	2008-10-30 10:44:46.000000000 -0800
@@ -481,12 +481,16 @@
 	return 1;
 }
 #else
+/* This check is needed to avoid cache aliasing when PAT is enabled */
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
 	u64 to = from + size;
 	u64 cursor = from;
 
+	if (!pat_enabled)
+		return 1;
+
 	while (cursor < to) {
 		if (!devmem_is_allowed(pfn)) {
 			printk(KERN_INFO
