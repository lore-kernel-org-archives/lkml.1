Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYJ3VNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYJ3VNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYJ3VNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:13:40 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42416 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbYJ3VNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:13:40 -0400
Subject: [PATCH] x86: fix missing cpu_index initialisation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:13:37 -0500
Message-Id: <1225401217.19324.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f49bbb826d8ec87609a63fb014af6aacb16aac38 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 29 Oct 2008 15:13:09 -0500
Subject: [VOYAGER] x86: fix missing cpu_index initialisation

Ever since

commit 92cb7612aee39642d109b8d935ad265e602c0563
Author: Mike Travis <travis@sgi.com>
Date:   Fri Oct 19 20:35:04 2007 +0200

    x86: convert cpuinfo_x86 array to a per_cpu array

We've had an extra field in cpuinfo_x86 which is cpu_index.
Unfortunately, voyager has never initialised this, although the only
noticeable impact seems to be that /proc/cpuinfo shows all zeros for
the processor ids.

Anyway, fix this by initialising the boot CPU properly and setting the
index when the secondaries update.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---

Depends on [VOYAGER] x86: add ability to test for boot CPU

 arch/x86/kernel/cpu/common.c        |    2 ++
 arch/x86/mach-voyager/voyager_smp.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 93e9393..da8f15a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -549,6 +549,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 		this_cpu->c_early_init(c);
 
 	validate_pat_support(c);
+
+	c->cpu_index = boot_cpu_id;
 }
 
 void __init early_cpu_init(void)
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 63ed72b..761d491 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -415,6 +415,7 @@ void __init smp_store_cpu_info(int id)
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
+	c->cpu_index = id;
 
 	identify_secondary_cpu(c);
 }
-- 
1.5.6.5



