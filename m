Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbXLAAhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbXLAAhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758537AbXLAAhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:37:25 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45900 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155AbXLAAhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:37:23 -0500
Date: Fri, 30 Nov 2007 16:37:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au, ego@in.ibm.com, netdev@vger.kernel.org,
       bridge@lists.osdl.org, devel@openvz.org,
       shemminger@linux-foundation.org, xemul@openvz.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org
Subject: [PATCH] Remove rcu_assign_pointer() penalty for NULL pointers
Message-ID: <20071201003721.GA22726@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The rcu_assign_pointer() primitive currently unconditionally executes
a memory barrier, even when a NULL pointer is being assigned.  This
has lead some to avoid using rcu_assign_pointer() for NULL pointers,
which loses the self-documenting advantages of rcu_assign_pointer()
This patch uses __builtin_const_p() to omit needless memory barriers
for NULL-pointer assignments at compile time with no runtime penalty,
as discussed in the following thread:

	http://www.mail-archive.com/netdev@vger.kernel.org/msg54852.html

Tested on x86_64 and ppc64, also compiled the four cases (NULL/non-NULL
and const/non-const) with gcc version 4.1.2, and hand-checked the
assembly output.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcupdate.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -urpNa -X dontdiff linux-2.6.24-rc1-ego/include/linux/rcupdate.h linux-2.6.24-rc1-egoxu/include/linux/rcupdate.h
--- linux-2.6.24-rc1-ego/include/linux/rcupdate.h	2007-11-06 15:30:02.000000000 -0800
+++ linux-2.6.24-rc1-egoxu/include/linux/rcupdate.h	2007-11-30 09:06:11.000000000 -0800
@@ -191,10 +191,13 @@ static inline void rcu_preempt_boost(voi
  * code.
  */
 
-#define rcu_assign_pointer(p, v)	({ \
-						smp_wmb(); \
-						(p) = (v); \
-					})
+#define rcu_assign_pointer(p, v) \
+	({ \
+		if (!__builtin_constant_p(v) || \
+		    ((v) != NULL)) \
+			smp_wmb(); \
+		(p) = (v); \
+	})
 
 /**
  * synchronize_sched - block until all CPUs have exited any non-preemptive
