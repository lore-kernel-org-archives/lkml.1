Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZGRUqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZGRUqH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 16:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZGRUqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 16:46:06 -0400
Received: from c60.cesmail.net ([216.154.195.49]:19758 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbZGRUqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 16:46:05 -0400
Subject: [PATCH] timer: avoid reading uninitialized data
To: linux-kernel@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 18 Jul 2009 16:46:02 -0400
Message-ID: <20090718204602.5191.360.stgit@mj.roinet.com>
User-Agent: StGit/0.15-rc1-9-g143a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timer->expires may be uninitialized, so check timer_pending() before
touching timer->expires to pacify kmemcheck.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 0b36b9e..a7f07d5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -714,7 +714,7 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	 * networking code - if the timer is re-modified
 	 * to be the same thing then just return:
 	 */
-	if (timer->expires == expires && timer_pending(timer))
+	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
