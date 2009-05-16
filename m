Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZEPJwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZEPJwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbZEPJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:51:29 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:54994 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZEPJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:51:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KqAhAEaDlDHjFve3f1L+7k5ilqntPa8oQqqHJASt8Y1LP+kZDIdTwMUUWhT899hK7Q
         2S7WiBux6nL7D5MSPkB0Sk8+xJhknyW5jRh7g5+a6z5EmS+rz437AqwX/znOz77ex/Cr
         XVQNEGY0cYn97lDiYN+h1NZIeGOwpTud+9TD8=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 4/4] kmemcheck: fix __send_signal() false positive
Date: Sat, 16 May 2009 11:51:20 +0200
Message-Id: <1242467480-14378-4-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
In-Reply-To: <1242467480-14378-3-git-send-email-vegard.nossum@gmail.com>
References: <1242467480-14378-1-git-send-email-vegard.nossum@gmail.com>
 <1242467480-14378-2-git-send-email-vegard.nossum@gmail.com>
 <1242467480-14378-3-git-send-email-vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide the false positive using the __GFP_NOTRACK_FALSE_POSITIVE flag.
Also made the rlimit override code a bit clearer by introducing a new
variable.

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/signal.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index d803473..57c7440 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -829,6 +829,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 {
 	struct sigpending *pending;
 	struct sigqueue *q;
+	int override_rlimit;
 
 	trace_sched_signal_send(sig, t);
 
@@ -860,9 +861,13 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	   make sure at least one signal gets delivered and don't
 	   pass on the info struct.  */
 
-	q = __sigqueue_alloc(t, GFP_ATOMIC, (sig < SIGRTMIN &&
-					     (is_si_special(info) ||
-					      info->si_code >= 0)));
+	if (sig < SIGRTMIN)
+		override_rlimit = (is_si_special(info) || info->si_code >= 0);
+	else
+		override_rlimit = 0;
+
+	q = __sigqueue_alloc(t, GFP_ATOMIC | __GFP_NOTRACK_FALSE_POSITIVE,
+		override_rlimit);
 	if (q) {
 		list_add_tail(&q->list, &pending->list);
 		switch ((unsigned long) info) {
-- 
1.6.0.6

