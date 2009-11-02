Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZKBKOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZKBKOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZKBKOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:14:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:47888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbZKBKOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:14:46 -0500
Date: Mon, 2 Nov 2009 10:13:04 GMT
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, peterz@infradead.org, tj@kernel.org,
       tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu, avi@redhat.com,
       cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, peterz@infradead.org, tj@kernel.org,
       tglx@linutronix.de, sfr@canb.auug.org.au, cl@linux-foundation.org,
       avi@redhat.com, mingo@elte.hu
In-Reply-To: <20091102161722.eea4358d.sfr@canb.auug.org.au>
References: <20091102161722.eea4358d.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] x86: Fix user return notifier put_cpu_var() invocation
Message-ID: <tip-3c912b6edaac56cb451e7571c95c15cbb6bd0c81@git.kernel.org>
Git-Commit-ID: 3c912b6edaac56cb451e7571c95c15cbb6bd0c81
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c912b6edaac56cb451e7571c95c15cbb6bd0c81
Gitweb:     http://git.kernel.org/tip/3c912b6edaac56cb451e7571c95c15cbb6bd0c81
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Mon, 2 Nov 2009 16:17:22 +1100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 2 Nov 2009 07:58:59 +0100

x86: Fix user return notifier put_cpu_var() invocation

Today's linux-next build (x86_64 allmodconfig) failed like this:

  kernel/user-return-notifier.c: In function
  'fire_user_return_notifiers': kernel/user-return-notifier.c:45:
  error: expected expression before ')' token

Introduced by commit 7c68af6e32c73992bad24107311f3433c89016e2
("core, x86: Add user return notifiers") from the tip and kvm trees
but revealed by commit e0fdb0e050eae331046385643618f12452aa7e73
("percpu: add __percpu for sparse") from the percpu tree.

Before that percpu tree commit, "put_cpu_var()" would compile
without error (even though it really needs a parameter).

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
LKML-Reference: <20091102161722.eea4358d.sfr@canb.auug.org.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/user-return-notifier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
index 530ccb8..03e2d6f 100644
--- a/kernel/user-return-notifier.c
+++ b/kernel/user-return-notifier.c
@@ -42,5 +42,5 @@ void fire_user_return_notifiers(void)
 	head = &get_cpu_var(return_notifier_list);
 	hlist_for_each_entry_safe(urn, tmp1, tmp2, head, link)
 		urn->on_user_return(urn);
-	put_cpu_var();
+	put_cpu_var(return_notifier_list);
 }
