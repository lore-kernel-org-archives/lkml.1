Return-Path: <linux-kernel-owner+w=401wt.eu-S1764288AbXGWQGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764288AbXGWQGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762943AbXGWQEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:36 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:53124 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762900AbXGWQEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:35 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:35:53 +0530
Message-Id: <20070723160553.22137.26523.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 5/8] i386: bitops: Contain warnings fallout from the death of volatiles
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[5/8] i386: bitops: Contain warnings fallout from the death of volatiles

The wrappers below included from all over tree re-used "volatile" just
because the bitops used them. With them killed, almost every file ends
up crying about:

warning: passing argument 2 of 'set_bit' discards qualifiers from
pointer target type

Silence these bogus warnings by killing volatile casts a second time.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---

[ Cscope tells us there are other such wrappers that didn't show up
  in my test .config -- I'll update them shortly.

  Also, I should probably merge this patch with the previous one.
  Otherwise git-bisecters who hit the window between these two
  patches will be flooded with bogus warnings and would probably
  want to kill me :-) ]

 include/linux/cpumask.h  |    4 ++--
 include/linux/nodemask.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 23f5514..49f6ed4 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -89,13 +89,13 @@ typedef struct { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 extern cpumask_t _unused_cpumask_arg_;
 
 #define cpu_set(cpu, dst) __cpu_set((cpu), &(dst))
-static inline void __cpu_set(int cpu, volatile cpumask_t *dstp)
+static inline void __cpu_set(int cpu, cpumask_t *dstp)
 {
 	set_bit(cpu, dstp->bits);
 }
 
 #define cpu_clear(cpu, dst) __cpu_clear((cpu), &(dst))
-static inline void __cpu_clear(int cpu, volatile cpumask_t *dstp)
+static inline void __cpu_clear(int cpu, cpumask_t *dstp)
 {
 	clear_bit(cpu, dstp->bits);
 }
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 52c54a5..81ba056 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -89,13 +89,13 @@ typedef struct { DECLARE_BITMAP(bits, MAX_NUMNODES); } nodemask_t;
 extern nodemask_t _unused_nodemask_arg_;
 
 #define node_set(node, dst) __node_set((node), &(dst))
-static inline void __node_set(int node, volatile nodemask_t *dstp)
+static inline void __node_set(int node, nodemask_t *dstp)
 {
 	set_bit(node, dstp->bits);
 }
 
 #define node_clear(node, dst) __node_clear((node), &(dst))
-static inline void __node_clear(int node, volatile nodemask_t *dstp)
+static inline void __node_clear(int node, nodemask_t *dstp)
 {
 	clear_bit(node, dstp->bits);
 }
