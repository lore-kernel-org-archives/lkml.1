Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbYDVRSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbYDVRSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbYDVRSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:18:40 -0400
Received: from sandeen.net ([209.173.210.139]:31337 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbYDVRSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:18:39 -0400
Message-ID: <480E1DED.9040104@sandeen.net>
Date: Tue, 22 Apr 2008 12:18:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Eric Sandeen <sandeen@redhat.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix  max-stack calculators to skip canary
References: <480D5F27.1030101@redhat.com> <20080422084404.GA2388@elte.hu> <480E15DC.5040301@sandeen.net>
In-Reply-To: <480E15DC.5040301@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the canary on the end of the stack, anything which
looks for 0 to mean unused when calculating max stack
excursions must skip over this non-zero magic number.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.25/kernel/exit.c
===================================================================
--- linux-2.6.25.orig/kernel/exit.c	2008-04-20 22:34:16.000000000 -0500
+++ linux-2.6.25/kernel/exit.c	2008-04-22 11:38:05.769412824 -0500
@@ -826,6 +826,8 @@ static void check_stack_usage(void)
 	unsigned long *n = end_of_stack(current);
 	unsigned long free;
 
+	n++;	/* skip over canary at end */
+
 	while (*n == 0)
 		n++;
 	free = (unsigned long)n - (unsigned long)end_of_stack(current);
Index: linux-2.6.25/kernel/sched.c
===================================================================
--- linux-2.6.25.orig/kernel/sched.c	2008-04-20 22:34:19.000000000 -0500
+++ linux-2.6.25/kernel/sched.c	2008-04-22 11:48:06.975407495 -0500
@@ -5190,6 +5190,8 @@ void sched_show_task(struct task_struct 
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	{
 		unsigned long *n = end_of_stack(p);
+
+		n++;	/* skip over canary at end */
 		while (!*n)
 			n++;
 		free = (unsigned long)n - (unsigned long)end_of_stack(p);

