Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZLBKpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZLBKpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 05:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZLBKpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 05:45:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:44985 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZLBKpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 05:45:12 -0500
Date: Wed, 2 Dec 2009 10:44:53 GMT
From: tip-bot for Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, avi@redhat.com, mingo@elte.hu
In-Reply-To: <1259578491-4589-1-git-send-email-avi@redhat.com>
References: <1259578491-4589-1-git-send-email-avi@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] core: Clean up user return notifers use of per_cpu
Message-ID: <tip-1786bf009f18f722afbb62143c8541e7e60a4e92@git.kernel.org>
Git-Commit-ID: 1786bf009f18f722afbb62143c8541e7e60a4e92
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1786bf009f18f722afbb62143c8541e7e60a4e92
Gitweb:     http://git.kernel.org/tip/1786bf009f18f722afbb62143c8541e7e60a4e92
Author:     Avi Kivity <avi@redhat.com>
AuthorDate: Mon, 30 Nov 2009 12:54:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Dec 2009 10:22:59 +0100

core: Clean up user return notifers use of per_cpu

Instead of using per_cpu(..., raw_smp_processor_id()), use
__get_cpu_var(...).

Signed-off-by: Avi Kivity <avi@redhat.com>
LKML-Reference: <1259578491-4589-1-git-send-email-avi@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/user-return-notifier.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
index 03e2d6f..eb27fd3 100644
--- a/kernel/user-return-notifier.c
+++ b/kernel/user-return-notifier.c
@@ -6,8 +6,6 @@
 
 static DEFINE_PER_CPU(struct hlist_head, return_notifier_list);
 
-#define URN_LIST_HEAD per_cpu(return_notifier_list, raw_smp_processor_id())
-
 /*
  * Request a notification when the current cpu returns to userspace.  Must be
  * called in atomic context.  The notifier will also be called in atomic
@@ -16,7 +14,7 @@ static DEFINE_PER_CPU(struct hlist_head, return_notifier_list);
 void user_return_notifier_register(struct user_return_notifier *urn)
 {
 	set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
-	hlist_add_head(&urn->link, &URN_LIST_HEAD);
+	hlist_add_head(&urn->link, &__get_cpu_var(return_notifier_list));
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_register);
 
@@ -27,7 +25,7 @@ EXPORT_SYMBOL_GPL(user_return_notifier_register);
 void user_return_notifier_unregister(struct user_return_notifier *urn)
 {
 	hlist_del(&urn->link);
-	if (hlist_empty(&URN_LIST_HEAD))
+	if (hlist_empty(&__get_cpu_var(return_notifier_list)))
 		clear_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_unregister);
