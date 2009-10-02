Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZJBBcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZJBBcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZJBBcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:50 -0400
Received: from kroah.org ([198.145.64.141]:32987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbZJBBcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:10 2009
Message-Id: <20091002012409.864013829@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yang Xiaowei <xiaowei.yang@intel.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [027/136] xen: use stronger barrier after unlocking lock
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=xen-use-stronger-barrier-after-unlocking-lock.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Yang Xiaowei <xiaowei.yang@intel.com>

commit 2496afbf1e50c70f80992656bcb730c8583ddac3 upstream.

We need to have a stronger barrier between releasing the lock and
checking for any waiting spinners.  A compiler barrier is not sufficient
because the CPU's ordering rules do not prevent the read xl->spinners
from happening before the unlock assignment, as they are different
memory locations.

We need to have an explicit barrier to enforce the write-read ordering
to different memory locations.

Because of it, I can't bring up > 4 HVM guests on one SMP machine.

[ Code and commit comments expanded -J ]

[ Impact: avoid deadlock when using Xen PV spinlocks ]

Signed-off-by: Yang Xiaowei <xiaowei.yang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/spinlock.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -326,8 +326,13 @@ static void xen_spin_unlock(struct raw_s
 	smp_wmb();		/* make sure no writes get moved after unlock */
 	xl->lock = 0;		/* release lock */
 
-	/* make sure unlock happens before kick */
-	barrier();
+	/*
+	 * Make sure unlock happens before checking for waiting
+	 * spinners.  We need a strong barrier to enforce the
+	 * write-read ordering to different memory locations, as the
+	 * CPU makes no implied guarantees about their ordering.
+	 */
+	mb();
 
 	if (unlikely(xl->spinners))
 		xen_spin_unlock_slow(xl);


