Return-Path: <linux-kernel-owner+w=401wt.eu-S936592AbZLQEg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936592AbZLQEg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbZLQEgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:36:17 -0500
Received: from kroah.org ([198.145.64.141]:55542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935352AbZLQEEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:22 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:50 2009
Message-Id: <20091217035650.540334382@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@linux.intel.com>,
       Andrew Morton <akpm@linuxfoundation.org>, Nick Piggin <npiggin@suse.de>,
       Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [059/151] futex: Take mmap_sem for get_user_pages in fault_in_user_writeable
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit 722d0172377a5697919b9f7e5beb95165b1dec4e upstream.

get_user_pages() must be called with mmap_sem held.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linuxfoundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091208121942.GA21298@basil.fritz.box>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -304,8 +304,14 @@ void put_futex_key(int fshared, union fu
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
 


