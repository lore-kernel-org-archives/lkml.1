Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZJBLmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZJBLmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZJBLmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:42:17 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64997 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZJBLmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:42:16 -0400
From: Aaro Koskinen <aaro.koskinen@nokia.com>
To: mingo@elte.hu, akpm@linux-foundation.org, arjan@linux.intel.com,
       ak@linux.intel.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] panic: call bust_spinlocks(0) before dying
Date: Fri,  2 Oct 2009 14:41:20 +0300
Message-Id: <1254483680-25578-1-git-send-email-aaro.koskinen@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 02 Oct 2009 11:41:25.0766 (UTC) FILETIME=[45E90260:01CA4355]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ffd71da4e3f323b7673b061e6f7e0d0c12dc2b49 moved bust_spinlocks(0)
to the end of the function, which in practice is never reached. As a
result console_unblank() is not called, and on some systems the user
may not see the panic message.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
---
 kernel/panic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index bcdef26..96b45d0 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -90,6 +90,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
+	bust_spinlocks(0);
+
 	if (!panic_blink)
 		panic_blink = no_blink;
 
@@ -136,7 +138,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 		mdelay(1);
 		i++;
 	}
-	bust_spinlocks(0);
 }
 
 EXPORT_SYMBOL(panic);
-- 
1.5.4.3

