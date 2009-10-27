Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbZJ0V1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbZJ0V1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932349AbZJ0V13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:27:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:35430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbZJ0V13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:27:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,635,1249282800"; 
   d="scan'208";a="564016071"
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256668438.26028.414.camel@gandalf.stny.rr.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
	 <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
	 <1256668438.26028.414.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 27 Oct 2009 14:26:04 -0800
Message-Id: <1256682364.2691.33.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 11:33 -0700, Steven Rostedt wrote:
> On Tue, 2009-10-27 at 11:20 -0800, Suresh Siddha wrote:
> 
> > Steven, Is it possible for dynamic ftrace to use the kernel identity
> > mapping instead of the kernel text mapping for converting the tracing
> > calls to nops etc.
> 
> Not sure what you mean by "kernel identity" mapping.

64bit has the kernel text pages mapped at two locations. kernel identity
mapping  (__PAGE_OFFSET) and kernel image/text mapping
(__START_KERNEL_map).

DEBUG_RODATA patch was trying to preserve large page mapping (for perf
reasons) for kernel text. We can use the identity mapping for modifying
the kernel text.

This patch seems to fix.

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5a1b975..7e1799b 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -215,6 +215,11 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 }
 
 
+static inline int
+within(unsigned long addr, unsigned long start, unsigned long end)
+{
+	return addr >= start && addr < end;
+}
 
 
 static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
@@ -248,6 +253,14 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
 		return -EINVAL;
 
+	/*
+	 * On x86_64, we use the kernel identity mapping instead of the
+	 * kernel text mapping to modify the kernel text. This is a nop
+	 * for 32bit kernels.
+	 */
+	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
+		ip = (unsigned long)__va(__pa(ip));
+
 	/* replace the text with the new text */
 	if (do_ftrace_mod_code(ip, new_code))
 		return -EPERM;


