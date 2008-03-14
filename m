Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYCNNGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYCNNGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYCNNFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:05:48 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21178 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbYCNNFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:05:48 -0400
Date: Fri, 14 Mar 2008 14:05:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com
Subject: Re: IO CPU affinity test results
Message-ID: <20080314130545.GO17940@kernel.dk>
References: <47DA6C1E.8010000@hp.com> <20080314123606.GL17940@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314123606.GL17940@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14 2008, Jens Axboe wrote:
> I think that is encouraging, for such a small setup. The make results
> are particularly nice. The hangs are a bother, I have no good ideas on
> why the occur. The fact that it happens on both archs indicates that
> this is perhaps a generic problem, which is good. The code to support
> this is relatively simple, so it should be possible to go over it with a
> fine toothed comb and see if anything shows up.
> 
> You didn't get any watchdog triggers on the serial console, or anything
> like that?

Here's something that may explain it - if interrupts aren't disabled
when generic_smp_call_function_single() is called, we could deadlock
on the dst->lock. I think that the IPI invoke will have interrupt
disabled, but I'm not 100% certain.

Can you see if this passes the muster?

diff --git a/kernel/smp.c b/kernel/smp.c
index 852abd3..65808df 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -24,12 +24,13 @@ void __cpuinit generic_init_call_single_data(void)
 void generic_smp_call_function_single_interrupt(void)
 {
 	struct call_single_queue *q;
+	unsigned long flags;
 	LIST_HEAD(list);
 
 	q = &__get_cpu_var(call_single_queue);
-	spin_lock(&q->lock);
+	spin_lock_irqsave(&q->lock);
 	list_replace_init(&q->list, &list);
-	spin_unlock(&q->lock);
+	spin_unlock_irqrestore(&q->lock);
 
 	while (!list_empty(&list)) {
 		struct call_single_data *data;

-- 
Jens Axboe

