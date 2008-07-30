Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYG3RGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYG3RGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbYG3RGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:06:40 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:38849 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbYG3RGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:06:39 -0400
Date: Wed, 30 Jul 2008 21:09:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] wait_task_inactive: fix the !CONFIG_SMP version
Message-ID: <20080730170948.GA18679@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantics of wait_task_inactive() was changed, update the !SMP
version accordingly.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 27/include/linux/sched.h~2_WTI_DUMMY	2008-07-30 13:12:48.000000000 +0400
+++ 27/include/linux/sched.h	2008-07-30 20:28:31.000000000 +0400
@@ -1880,7 +1880,9 @@ extern unsigned long wait_task_inactive(
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
-	return 1;
+	if (match_state && unlikely(p->state != match_state))
+		return 0;
+	return p->nvcsw | LONG_MIN; /* sets MSB */
 }
 #endif
 

