Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbZK3Kyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbZK3Kyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZK3Kyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:54:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbZK3Kyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:54:50 -0500
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] core: clean up user return notifers use of per_cpu
Date: Mon, 30 Nov 2009 12:54:51 +0200
Message-Id: <1259578491-4589-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using per_cpu(..., raw_smp_processor_id()), use __get_cpu_var(...).

Signed-off-by: Avi Kivity <avi@redhat.com>
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
-- 
1.6.5.2

