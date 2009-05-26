Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbZEZX6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbZEZX6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbZEZXyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38604 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZEZXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:47 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 13/31] x86: MCE: Drop BKL in mce_open
Date: Wed, 27 May 2009 01:54:15 +0200
Message-Id: <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: cleanup

BKL is not needed for anything in mce_open because it has
an own spinlock. Remove it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 93c3b93..f617c9b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -14,7 +14,6 @@
 #include <linux/ratelimit.h>
 #include <linux/kallsyms.h>
 #include <linux/rcupdate.h>
-#include <linux/smp_lock.h>
 #include <linux/kobject.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
@@ -853,12 +852,10 @@ static int		open_exclu;		/* already open exclusive? */
 
 static int mce_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	spin_lock(&mce_state_lock);
 
 	if (open_exclu || (open_count && (file->f_flags & O_EXCL))) {
 		spin_unlock(&mce_state_lock);
-		unlock_kernel();
 
 		return -EBUSY;
 	}
@@ -868,7 +865,6 @@ static int mce_open(struct inode *inode, struct file *file)
 	open_count++;
 
 	spin_unlock(&mce_state_lock);
-	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
-- 
1.6.0.2

