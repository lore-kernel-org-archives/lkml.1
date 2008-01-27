Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbYA0Xkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbYA0Xkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYA0XkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:40:18 -0500
Received: from ns1.suse.de ([195.135.220.2]:51222 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbYA0XkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:40:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/5] x86: fix runtime error in arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Date: Sun, 27 Jan 2008 15:38:39 -0800
Message-Id: <1201477122-4541-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080127233751.GA4524@kroah.com>
References: <20080127233751.GA4524@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This problem is due to the kobject rework recently done in this file.

The mce_amd_64.c code uses some wierd forward calls to back out of the
recursive way the code creates kobjects.  Because of this, we need to
verify that we have really created a kobject before calling
kobject_uevent().

Many thanks to Yinghai Lu <yhlu.kernel@gmail.com> for reporting the
problem and testing.

Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 7535887..073afa7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -450,7 +450,8 @@ recurse:
 	if (err)
 		goto out_free;
 
-	kobject_uevent(&b->kobj, KOBJ_ADD);
+	if (b)
+		kobject_uevent(&b->kobj, KOBJ_ADD);
 
 	return err;
 
-- 
1.5.3.8

