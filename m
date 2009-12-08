Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZLHOEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZLHOEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZLHOEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:04:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:54548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbZLHOEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:04:14 -0500
Date: Tue, 8 Dec 2009 14:03:32 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, akpm@linuxfoundation.org,
       hpa@zytor.com, mingo@redhat.com, andi@firstfloor.org,
       peterz@infradead.org, npiggin@suse.de, ak@linux.intel.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, akpm@linuxfoundation.org,
       dvhltc@us.ibm.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       peterz@infradead.org, npiggin@suse.de, ak@linux.intel.com,
       tglx@linutronix.de
In-Reply-To: <20091208121942.GA21298@basil.fritz.box>
References: <20091208121942.GA21298@basil.fritz.box>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Take mmap_sem for get_user_pages in fault_in_user_writeable
Message-ID: <tip-722d0172377a5697919b9f7e5beb95165b1dec4e@git.kernel.org>
Git-Commit-ID: 722d0172377a5697919b9f7e5beb95165b1dec4e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  722d0172377a5697919b9f7e5beb95165b1dec4e
Gitweb:     http://git.kernel.org/tip/722d0172377a5697919b9f7e5beb95165b1dec4e
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Tue, 8 Dec 2009 13:19:42 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 Dec 2009 14:59:36 +0100

futex: Take mmap_sem for get_user_pages in fault_in_user_writeable

get_user_pages() must be called with mmap_sem held.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@kernel.org
Cc: Andrew Morton <akpm@linuxfoundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091208121942.GA21298@basil.fritz.box>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/futex.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fb65e82..d73ef1f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -304,8 +304,14 @@ void put_futex_key(int fshared, union futex_key *key)
  */
 static int fault_in_user_writeable(u32 __user *uaddr)
 {
-	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
-				 1, 1, 0, NULL, NULL);
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(current, mm, (unsigned long)uaddr,
+			     1, 1, 0, NULL, NULL);
+	up_read(&mm->mmap_sem);
+
 	return ret < 0 ? ret : 0;
 }
 
