Return-Path: <linux-kernel-owner+w=401wt.eu-S1762375AbYHERSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375AbYHERSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761069AbYHERRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:17:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37702 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760868AbYHERRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:17:04 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080805717.971524000@firstfloor.org>
In-Reply-To: <20080805717.971524000@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/4] MCE: Reinitialize per cpu features and ancient mces on resume
Message-Id: <20080805171737.82C561B90085@one.firstfloor.org>
Date: Tue,  5 Aug 2008 19:17:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fixes a long standing bug in the machine check code. On resume the
boot CPU wouldn't get its vendor specific state like thermal handling
reinitialized. This means the boot cpu wouldn't ever get any thermal
events reported again. Also the newly added ancient CPUs have the same problem.

Call the respective initialization functions on resume.


Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -753,6 +753,8 @@ __setup("mce=", mcheck_enable);
 static int mce_resume(struct sys_device *dev)
 {
 	mce_init(NULL);
+	mce_ancient_init(&current_cpu_data);
+	mce_cpu_features(&current_cpu_data);
 	return 0;
 }
 
