Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbZKPMT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbZKPMT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZKPMTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:19:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZKPMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:39 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 03/42] x86: Fix user return notifier put_cpu_var() invocation
Date: Mon, 16 Nov 2009 14:19:04 +0200
Message-Id: <1258373983-8693-4-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

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
-- 
1.6.5.2

