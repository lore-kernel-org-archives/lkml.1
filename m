Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZCGWZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZCGWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZCGWZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:25:15 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35205 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458AbZCGWZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:25:14 -0500
Date: Sat, 7 Mar 2009 14:25:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: manfred@colorfullife.com, Nadia.Derbey@bull.net, miltonm@austin.ibm.com,
       mingo@elte.hu, akpm@linux-foundation.org, peterz@infradead.org,
       lnxninja@linux.vnet.ibm.com, efault@gmx.de, riel@redhat.com
Subject: [PATCH] make idr_remove_all() do removal -before- free_layer()
Message-ID: <20090307222511.GA10727@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes a problem in the IDR system, where an
idr_remove_all() hands a data element to call_rcu() (via free_layer())
before making that data element inaccessible to new readers.  This is
very bad, and results in readers still having a reference to this data
element at the end of the grace period.  Tests on large machines that
concurrently map and unmap user-space memory within the same multithreaded
process result in crashes within about five minutes.  Applying this
patch increases the kernel's longevity to the three-to-eight-hour range.

There appear to be other similar problems in idr_get_empty_slot() and
sub_remove(), but I fixed the easy one in idr_remove_all() first.  It is
therefore no surprise that failures still occur.

(Yes, and I did look at the relevant patch last year without spotting
this one.  Goes to show the value of testing as well as code review,
I guess...)

Nadia, Manfred, any thoughts?

Located-by: Milton Miller II <miltonm@austin.ibm.com>
Tested-by: Milton Miller II <miltonm@austin.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/lib/idr.c b/lib/idr.c
index c11c576..dab4bca 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -449,6 +449,7 @@ void idr_remove_all(struct idr *idp)
 
 	n = idp->layers * IDR_BITS;
 	p = idp->top;
+	rcu_assign_pointer(idp->top, NULL);
 	max = 1 << n;
 
 	id = 0;
@@ -467,7 +468,6 @@ void idr_remove_all(struct idr *idp)
 			p = *--paa;
 		}
 	}
-	rcu_assign_pointer(idp->top, NULL);
 	idp->layers = 0;
 }
 EXPORT_SYMBOL(idr_remove_all);

----- End forwarded message -----
