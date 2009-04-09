Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbZDIRgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbZDIRgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbZDIRgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:36:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:6360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbZDIRgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:36:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,161,1239001200"; 
   d="scan'208";a="129795049"
Date: Thu, 9 Apr 2009 10:36:40 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: tip: Build failure with !CONFIG_TRACE - undefined reference to `trace_clock_global' 
Message-ID: <20090409173640.GA8211@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With tip (commit - 58e70a841b20d5d80aebdd8274ab60c0c933470f) I get a build
error when CONFIG_TRACE is not set. 

arch/x86/kernel/built-in.o: In function `ds_switch_to':
(.text+0x86ee): undefined reference to `trace_clock_global'
arch/x86/kernel/built-in.o: In function `ds_switch_to':
(.text+0x8743): undefined reference to `trace_clock_global'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

Looks like it is coming from the change
commit 15879d042164650b93d83281ad5f87ad323bfbfe
Author: Markus Metzger <markus.t.metzger@intel.com>
Date:   Fri Apr 3 16:43:38 2009 +0200

    x86, bts: use trace_clock_global() for timestamps


Below is a dumb patch that gets rid of the build error. Not sure whether
this is the right fix.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 48bfe13..62b4b55 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -1377,7 +1377,9 @@ static inline void ds_take_timestamp(struct ds_context *context,
 
 	memset(&ts, 0, sizeof(ts));
 	ts.qualifier		= qualifier;
+#ifdef CONFIG_TRACING
 	ts.variant.event.clock	= trace_clock_global();
+#endif
 	ts.variant.event.pid	= task->pid;
 
 	bts_write(tracer, &ts);
