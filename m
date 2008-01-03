Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbYACBBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbYACBBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYACBA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:00:57 -0500
Received: from mga10.intel.com ([192.55.52.92]:41390 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754638AbYACBA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:00:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,237,1196668800"; 
   d="scan'208";a="268515900"
Message-ID: <477C332D.20809@linux.intel.com>
Date: Thu, 03 Jan 2008 01:58:21 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/3] Add the end-of-trace marker and the module list to WARN_ON()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Add the end-of-trace marker and the module list to WARN_ON()
From: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>

Unlike oopses, WARN_ON() currently does't print the loaded modules list.
This makes it harder to take action on certain bug reports. For example,
recently there were a set of WARN_ON()s reported in the mac80211 stack,
which were just signalling a driver bug. It takes then anther round trip
to the bug reporter (if he responds at all) to find out which driver
is at fault.

Another issue is that, unlike oopses, WARN_ON() doesn't currently printk
the helpful "cut here" line, nor the "end of trace" marker.
Now that WARN_ON() is out of line, the size increase due to this is
minimal and it's worth adding.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
  kernel/panic.c |    5 +++++
  1 file changed, 5 insertions(+)

Index: linux-2.6.24-rc6/kernel/panic.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/panic.c
+++ linux-2.6.24-rc6/kernel/panic.c
@@ -297,9 +297,14 @@ int do_warn_on(const unsigned long condi
  			const int line, const char *function)
  {
  	if (unlikely(condition)) {
+		printk(KERN_WARNING "------------[ cut here ]------------\n");
  		printk(KERN_WARNING "WARNING: at %s:%d %s()\n",
  			__FILE__, __LINE__, __FUNCTION__);
+		print_modules();
  		dump_stack();
+		init_oops_id();
+		printk(KERN_WARNING "---[ end trace %016llx ]---\n",
+			(unsigned long long)oops_id);
  	}
  	return !!condition;
  }
