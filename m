Return-Path: <linux-kernel-owner+w=401wt.eu-S934287AbXCWDTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbXCWDTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 23:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934284AbXCWDTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 23:19:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51409 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506AbXCWDTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 23:19:34 -0400
Date: Fri, 23 Mar 2007 12:17:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Cc: "tony.luck@intel.com" <tony.luck@intel.com>, dmosberger@gmail.com,
       surinder.kumar@oracle.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][ia64][1/2] bugfix stack layout upside-down
Message-Id: <20070323121746.4925a639.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 expects following vm layout
==
[register-stack]
[memory-stack]
==
But, when ulimit -s is used  and stack-base-address-randomization works,
vm layout is sometimes following.
==
[memory-stack]
[register-stack]
==

If this happens,  register-stack cannot be expanded.

This patch fixes this bug by adjusting register-stack.

Signed-Off-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Index: linux-2.6.21-rc4/arch/ia64/mm/init.c
===================================================================
--- linux-2.6.21-rc4.orig/arch/ia64/mm/init.c
+++ linux-2.6.21-rc4/arch/ia64/mm/init.c
@@ -155,7 +155,7 @@ ia64_set_rbs_bot (void)
 
 	if (stack_size > MAX_USER_STACK_SIZE)
 		stack_size = MAX_USER_STACK_SIZE;
-	current->thread.rbs_bot = STACK_TOP - stack_size;
+	current->thread.rbs_bot = PAGE_ALIGN(current->mm->start_stack - stack_size);
 }
 
 /*

