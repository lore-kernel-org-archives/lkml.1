Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZLHMTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZLHMTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZLHMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:19:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53978 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbZLHMTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:19:39 -0500
Date: Tue, 8 Dec 2009 13:19:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       tglx@linutronix.de, dvhltc@us.ibm.com
Cc: stable@kernel.org
Subject: [PATCH] futex: Take mmap_sem for get_user_pages in
	fault_in_user_writeable
Message-ID: <20091208121942.GA21298@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

futex: Take mmap_sem for get_user_pages in fault_in_user_writeable

gup() requires mmap_sem, so take it before running it. The
recent fault_in_user_writeable() didn't do that.

I didn't find a good futex test case, so untested.

Likely a stable candidate.

Cc: npiggin@suse.de
Cc: tglx@linutronix.de
Cc: dvhltc@us.ibm.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/futex.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.32-ak/kernel/futex.c
===================================================================
--- linux-2.6.32-ak.orig/kernel/futex.c
+++ linux-2.6.32-ak/kernel/futex.c
@@ -304,8 +304,13 @@ void put_futex_key(int fshared, union fu
  */
 static int fault_in_user_writeable(u32 __user *uaddr)
 {
-	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
+	int ret;
+	struct mm_struct *mm = current->mm;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(current, mm, (unsigned long)uaddr,
 				 1, 1, 0, NULL, NULL);
+	up_read(&mm->mmap_sem);
 	return ret < 0 ? ret : 0;
 }
 
