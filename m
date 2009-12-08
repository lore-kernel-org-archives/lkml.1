Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbZLHLbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbZLHLbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZLHLbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:31:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:36032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZLHLbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:31:42 -0500
Date: Tue, 8 Dec 2009 11:31:02 GMT
From: tip-bot for Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, jbeulich@novell.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, seto.hidetoshi@jp.fujitsu.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B1DB831.2030801@jp.fujitsu.com>
References: <4B1DB831.2030801@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mce: Set up timer unconditionally
Message-ID: <tip-bc09effabf0c5c6c7021e5ef9af15a23579b32a8@git.kernel.org>
Git-Commit-ID: bc09effabf0c5c6c7021e5ef9af15a23579b32a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc09effabf0c5c6c7021e5ef9af15a23579b32a8
Gitweb:     http://git.kernel.org/tip/bc09effabf0c5c6c7021e5ef9af15a23579b32a8
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Tue, 8 Dec 2009 11:21:37 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 8 Dec 2009 05:34:39 +0100

x86/mce: Set up timer unconditionally

mce_timer must be passed to setup_timer() in all cases, no
matter whether it is going to be actually used. Otherwise, when
the CPU gets brought down, its call to del_timer_sync() will
never return, as the timer won't have a base associated, and
hence lock_timer_base() will loop infinitely.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: <stable@kernel.org>
LKML-Reference: <4B1DB831.2030801@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d7ebf25..a96e5cd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1388,13 +1388,14 @@ static void __mcheck_cpu_init_timer(void)
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 	int *n = &__get_cpu_var(mce_next_interval);
 
+	setup_timer(t, mce_start_timer, smp_processor_id());
+
 	if (mce_ignore_ce)
 		return;
 
 	*n = check_interval * HZ;
 	if (!*n)
 		return;
-	setup_timer(t, mce_start_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
 	add_timer_on(t, smp_processor_id());
 }
