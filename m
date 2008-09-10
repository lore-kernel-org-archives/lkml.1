Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbYIJDDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbYIJDDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYIJDDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:03:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbYIJDDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:03:38 -0400
Message-ID: <48C73873.1010708@cn.fujitsu.com>
Date: Wed, 10 Sep 2008 11:01:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Doc/RCU: fix pseudocode in rcuref.txt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


atomic_inc_not_zero(v) return 0 if *v = 0.
use spin_lock instead of write_lock for update lock.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/Documentation/RCU/rcuref.txt b/Documentation/RCU/rcuref.txt
index 451de2a..4202ad0 100644
--- a/Documentation/RCU/rcuref.txt
+++ b/Documentation/RCU/rcuref.txt
@@ -29,9 +29,9 @@ release_referenced()			delete()
 					}
 
 If this list/array is made lock free using RCU as in changing the
-write_lock() in add() and delete() to spin_lock and changing read_lock
-in search_and_reference to rcu_read_lock(), the atomic_get in
-search_and_reference could potentially hold reference to an element which
+write_lock() in add() and delete() to spin_lock() and changing read_lock()
+in search_and_reference() to rcu_read_lock(), the atomic_inc() in
+search_and_reference() could potentially hold reference to an element which
 has already been deleted from the list/array.  Use atomic_inc_not_zero()
 in this scenario as follows:
 
@@ -40,20 +40,20 @@ add()					search_and_reference()
 {					{
     alloc_object			    rcu_read_lock();
     ...					    search_for_element
-    atomic_set(&el->rc, 1);		    if (atomic_inc_not_zero(&el->rc)) {
-    write_lock(&list_lock);		        rcu_read_unlock();
+    atomic_set(&el->rc, 1);		    if (!atomic_inc_not_zero(&el->rc)) {
+    spin_lock(&list_lock);		        rcu_read_unlock();
 					        return FAIL;
     add_element				    }
     ...					    ...
-    write_unlock(&list_lock);		    rcu_read_unlock();
+    spin_unlock(&list_lock);		    rcu_read_unlock();
 }					}
 3.					4.
 release_referenced()			delete()
 {					{
-    ...					    write_lock(&list_lock);
+    ...					    spin_lock(&list_lock);
     if (atomic_dec_and_test(&el->rc))       ...
         call_rcu(&el->head, el_free);       delete_element
-    ...                                     write_unlock(&list_lock);
+    ...                                     spin_unlock(&list_lock);
 } 					    ...
 					    if (atomic_dec_and_test(&el->rc))
 					        call_rcu(&el->head, el_free);


