Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYCQKt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYCQKt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYCQKtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:49:19 -0400
Received: from sacred.ru ([62.205.161.221]:34616 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYCQKtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:49:18 -0400
Message-ID: <47DE4C7D.5090207@openvz.org>
Date: Mon, 17 Mar 2008 13:48:29 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Bsd_acct: plain current->real_parent access is not always
 safe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 17 Mar 2008 13:48:26 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is minor, but dereferencing even current real_parent is not
safe on debug kernels, since the memory, this points to, can be
unmapped - RCU protection is required.

Besides, the tgid field is deprecated and is to be replaced with
task_tgid_xxx call (the 2nd patch), so RCU will be required anyway.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/acct.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 521dfa5..7ff5339 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -482,7 +482,9 @@ static void do_acct_process(struct file *file)
 #endif
 #if ACCT_VERSION==3
 	ac.ac_pid = current->tgid;
-	ac.ac_ppid = current->real_parent->tgid;
+	rcu_read_lock();
+	ac.ac_ppid = rcu_dereference(current->real_parent)->tgid;
+	rcu_read_unlock();
 #endif
 
 	spin_lock_irq(&current->sighand->siglock);
-- 
1.5.3.4

