Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbZCMKhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbZCMKhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbZCMKhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:37:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:36940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbZCMKhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:37:21 -0400
Date: Fri, 13 Mar 2009 10:36:35 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B91A7E.76E4.0078.0@novell.com>
References: <49B91A7E.76E4.0078.0@novell.com>
Subject: [tip:core/ipi] panic: decrease oops_in_progress only after having done the panic
Message-ID: <tip-ffd71da4e3f323b7673b061e6f7e0d0c12dc2b49@git.kernel.org>
Git-Commit-ID: ffd71da4e3f323b7673b061e6f7e0d0c12dc2b49
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 10:36:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffd71da4e3f323b7673b061e6f7e0d0c12dc2b49
Gitweb:     http://git.kernel.org/tip/ffd71da4e3f323b7673b061e6f7e0d0c12dc2b49
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 10:54:24 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 11:06:47 +0100

panic: decrease oops_in_progress only after having done the panic

Impact: eliminate secondary warnings during panic()

We can panic() in a number of difficult, atomic contexts, hence
we use bust_spinlocks(1) in panic() to increase oops_in_progress,
which prevents various debug checks we have in place.

But in practice this protection only covers the first few printk's
done by panic() - it does not cover the later attempt to stop all
other CPUs and kexec(). If a secondary warning triggers in one of
those facilities that can make the panic message scroll off.

So do bust_spinlocks(0) only much later in panic(). (which code
is only reached if panic policy is relaxed that it can return
after a warning message)

Reported-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B91A7E.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/panic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 32fe4ef..57fb005 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -77,7 +77,6 @@ NORET_TYPE void panic(const char * fmt, ...)
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	dump_stack();
 #endif
-	bust_spinlocks(0);
 
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
@@ -136,6 +135,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 		mdelay(1);
 		i++;
 	}
+	bust_spinlocks(0);
 }
 
 EXPORT_SYMBOL(panic);
