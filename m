Return-Path: <linux-kernel-owner+w=401wt.eu-S1765228AbYAYIQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765228AbYAYIQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbYAYIAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:41 -0500
Received: from mx1.suse.de ([195.135.220.2]:59433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764065AbYAYH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jacob Shin <jacob.shin@amd.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 127/196] Kobject: change arch/x86/kernel/cpu/mcheck/mce_amd_64.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:36 -0800
Message-Id: <1201246425-5058-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 2d65311..ef15f35 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -432,10 +432,9 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 	else
 		per_cpu(threshold_banks, cpu)[bank]->blocks = b;
 
-	kobject_set_name(&b->kobj, "misc%i", block);
-	b->kobj.parent = per_cpu(threshold_banks, cpu)[bank]->kobj;
-	b->kobj.ktype = &threshold_ktype;
-	err = kobject_register(&b->kobj);
+	err = kobject_init_and_add(&b->kobj, &threshold_ktype,
+				   per_cpu(threshold_banks, cpu)[bank]->kobj,
+				   "misc%i", block);
 	if (err)
 		goto out_free;
 recurse:
@@ -451,6 +450,8 @@ recurse:
 	if (err)
 		goto out_free;
 
+	kobject_uevent(&b->kobj, KOBJ_ADD);
+
 	return err;
 
 out_free:
-- 
1.5.3.8

