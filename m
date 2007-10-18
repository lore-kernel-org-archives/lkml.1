Return-Path: <linux-kernel-owner+w=401wt.eu-S1765835AbXJRRl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765835AbXJRRl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbXJRRl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:41:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40481 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758299AbXJRRl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:41:27 -0400
Date: Thu, 18 Oct 2007 19:41:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: wait_for_completion_interruptible() changes
Message-ID: <20071018174124.GA30159@one.firstfloor.org>
References: <Pine.LNX.4.62.0710181850370.22736@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0710181850370.22736@pademelon.sonytel.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I suspect this is caused by the recent completion refactoring?
 
Yes. Here's a patch to fix it.

Fix return value of wait_for_completion_interruptible()

The recent w_f_c() changes broke the return value of 
wait_for_completion_interruptible(). Previously it returned 0 on success,
now -1. Fix that.

Problem found by Geert Uytterhoeven

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/kernel/sched.c
===================================================================
--- linux/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3751,7 +3751,10 @@ EXPORT_SYMBOL(wait_for_completion_timeou
 
 int __sched wait_for_completion_interruptible(struct completion *x)
 {
-	return wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
+	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
+	if (t == -ERESTARTSYS) 
+		return t;
+	return 0;
 }
 EXPORT_SYMBOL(wait_for_completion_interruptible);
 
