Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYJJGqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYJJGqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 02:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYJJGqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 02:46:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52576 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYJJGqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 02:46:21 -0400
Message-ID: <48EEF9AD.9040401@cn.fujitsu.com>
Date: Fri, 10 Oct 2008 14:43:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] markers: bit-field is not thread-safe nor smp-safe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bit-field is not thread-safe nor smp-safe.

struct marker_entry.rcu_pending is not protected by any lock
in rcu-callback free_old_closure().
so we must turn it into a safe type.

detail:

I suppose rcu_pending and ptype are store in struct marker_entry.tmp1

free_old_closure() side:           change ptype side:

                                |  load struct marker_entry.tmp1
--------------------------------|--------------------------------
                                |  change ptype bit in tmp1
load struct marker_entry.tmp1   |
change rcu_pending bit in tmp1  |
store tmp1                      |
--------------------------------|--------------------------------
                                |  store tmp1

now this result equals that free_old_closure() do not change rcu_pending
bit, bug! This bug will cause redundant rcu_barrier_sched() called.
not too harmful.

----- corresponding:

free_old_closure() side:           change ptype side:

load struct marker_entry.tmp1   |
--------------------------------|--------------------------------
                                |  load struct marker_entry.tmp1
change rcu_pending bit in tmp1  |
                                |  change ptype bit in tmp1
                                |  store tmp1
--------------------------------|--------------------------------
store tmp1                      |

now this result equals that change ptype side do not change ptype
bit, bug! this bug cause marker_probe_cb() access to invalid memory.
oops!

see also: http://en.wikipedia.org/wiki/Bit_field

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/marker.c b/kernel/marker.c
index 7d1faec..95c62da 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -62,7 +62,7 @@ struct marker_entry {
 	int refcount;	/* Number of times armed. 0 if disarmed. */
 	struct rcu_head rcu;
 	void *oldptr;
-	unsigned char rcu_pending:1;
+	int rcu_pending;
 	unsigned char ptype:1;
 	char name[0];	/* Contains name'\0'format'\0' */
 };



