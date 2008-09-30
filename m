Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYI3Kuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYI3Kuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYI3Kui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:50:38 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:39302 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752252AbYI3Kui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:50:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nzjuzSMUst/NB0XUSThL3Kha4x0A5Z+0vesj6SwuQAiri0jMT7E/UshvrH1acK6AV7ox3jJA/5LlC/X8+HnAQJWMxgtWV5vbjd53mrLZNcp7opH24438xhof+9n7wh76H51l2+4T8Pzf9IVZU16jdE2FnKcWoUv4bKv8YFzEtSo=  ;
X-YMail-OSG: FD.CatkVM1nI4f2nUBdSLm2TgAjdgH1NqTlCUl1oKz2E2Ruzu248ECMdhizNhCH.V4lOZqPZQJVc0_NS1nCflhQGA6hAhmWx2kJUwPVFCqJerXvx6ATopvNJfbyRPk0uxefGOC2T3FQuzz1X6MQE7Mq32Inntg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Molnar, Ingo" <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [rfc] "improve" preempt debugging
Date: Tue, 30 Sep 2008 20:50:27 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809302050.27306.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, don't know if you really like this patch or not, but it helped me out with
a problem I recently had....

Basically, when the kernel lock is held, then preempt_count underflow does not
get detected until it is released which may be a long time (and arbitrarily,
eg at different points it may be rescheduled). If the bkl is released at
schedule, the resulting output is actually fairly cryptic...

With any other lock that elevates preempt_count, it is illegal to schedule
under it (which would get found pretty quickly). bkl allows scheduling with
preempt_count elevated, which makes underflows hard to debug.

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c       2008-09-30 11:32:56.000000000 +1000
+++ linux-2.6/kernel/sched.c    2008-09-30 11:38:18.000000000 +1000
@@ -4305,7 +4305,7 @@ void __kprobes sub_preempt_count(int val
        /*
         * Underflow?
         */
-       if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
+       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
                return;
        /*
         * Is the spinlock portion underflowing?
