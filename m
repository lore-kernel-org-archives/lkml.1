Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZJBMen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZJBMen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZJBMem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:34:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:35246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420AbZJBMel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:34:41 -0400
Date: Fri, 2 Oct 2009 12:34:04 GMT
From: tip-bot for Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, aaro.koskinen@nokia.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, aaro.koskinen@nokia.com,
       mingo@elte.hu
In-Reply-To: <1254483680-25578-1-git-send-email-aaro.koskinen@nokia.com>
References: <1254483680-25578-1-git-send-email-aaro.koskinen@nokia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] panic: Fix panic message visibility by calling bust_spinlocks(0) before dying
Message-ID: <tip-1f6dff52344945f665524f547a27f3cc0388cb90@git.kernel.org>
Git-Commit-ID: 1f6dff52344945f665524f547a27f3cc0388cb90
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 12:34:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f6dff52344945f665524f547a27f3cc0388cb90
Gitweb:     http://git.kernel.org/tip/1f6dff52344945f665524f547a27f3cc0388cb90
Author:     Aaro Koskinen <aaro.koskinen@nokia.com>
AuthorDate: Fri, 2 Oct 2009 14:41:20 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Oct 2009 14:23:12 +0200

panic: Fix panic message visibility by calling bust_spinlocks(0) before dying

Commit ffd71da4e3f ("panic: decrease oops_in_progress only after
having done the panic") moved bust_spinlocks(0) to the end of the
function, which in practice is never reached.

As a result console_unblank() is not called, and on some systems
the user may not see the panic message.

Move it back up to before the unblanking.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1254483680-25578-1-git-send-email-aaro.koskinen@nokia.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/panic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 512ab73..bc4dcb6 100644
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
