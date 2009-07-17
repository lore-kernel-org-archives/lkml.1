Return-Path: <linux-kernel-owner+w=401wt.eu-S933781AbZGQAGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbZGQAGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933690AbZGQAGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:06:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39148 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933746AbZGQAGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:06:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Julia Lawall <julia@diku.dk>,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 20/21] arch/blackfin: Add kmalloc NULL tests
Date: Thu, 16 Jul 2009 20:05:45 -0400
Message-Id: <1247789146-18786-21-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc is not NULL before passing it to other
functions.

In the first two cases, the new code returns -ENOMEM, which seems
compatible with what is done for similar functions for other architectures.

In the last two cases, the new code fails silently, ie just returns,
because the function has void return type.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/smp.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index e6e3429..349ee3f 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -211,6 +211,8 @@ int smp_call_function(void (*func)(void *info), void *info, int wait)
 		return 0;
 
 	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
 	INIT_LIST_HEAD(&msg->list);
 	msg->call_struct.func = func;
 	msg->call_struct.info = info;
@@ -252,6 +254,8 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 	cpu_set(cpu, callmap);
 
 	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
 	INIT_LIST_HEAD(&msg->list);
 	msg->call_struct.func = func;
 	msg->call_struct.info = info;
@@ -287,6 +291,8 @@ void smp_send_reschedule(int cpu)
 		return;
 
 	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return;
 	memset(msg, 0, sizeof(msg));
 	INIT_LIST_HEAD(&msg->list);
 	msg->type = BFIN_IPI_RESCHEDULE;
@@ -314,6 +320,8 @@ void smp_send_stop(void)
 		return;
 
 	msg = kmalloc(sizeof(*msg), GFP_ATOMIC);
+	if (!msg)
+		return;
 	memset(msg, 0, sizeof(msg));
 	INIT_LIST_HEAD(&msg->list);
 	msg->type = BFIN_IPI_CPU_STOP;
-- 
1.6.3.3

