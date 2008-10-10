Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYJJDJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYJJDJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 23:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYJJDI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 23:08:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYJJDI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 23:08:56 -0400
Message-ID: <48EEC6AD.4010606@cn.fujitsu.com>
Date: Fri, 10 Oct 2008 11:06:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
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

now this result equals that free_old_closure() do not change rcu_pending bit, bug.

see also: http://en.wikipedia.org/wiki/Bit_field

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/marker.c b/kernel/marker.c
index 7d1faec..4777218 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -62,7 +62,7 @@ struct marker_entry {
 	int refcount;	/* Number of times armed. 0 if disarmed. */
 	struct rcu_head rcu;
 	void *oldptr;
-	unsigned char rcu_pending:1;
+	unsigned char rcu_pending;
 	unsigned char ptype:1;
 	char name[0];	/* Contains name'\0'format'\0' */
 };



