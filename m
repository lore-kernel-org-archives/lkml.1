Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZGVXdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZGVXdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbZGVXdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:33:42 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:31356 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZGVXdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:33:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PmjmGhiwJEUoC/sSc++yIkiZNlpTV5IeZlEYOwyE7egCm55G4QRa83pic/ZfTM2uUO
         fGa6sOdzG+59A7/cJbQdCTy8syZiZYWhdGoTtcx4PLMAn6cwTdw1hy19nvDFmsTFqArz
         Ws3AzvXPjaC8BIu9YC8D6BI2SlGWNYRi3rZQg=
Message-ID: <4A67A1D1.8040201@gmail.com>
Date: Wed, 22 Jul 2009 20:33:37 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090626)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] genirq fixes for 2.6.31
References: <alpine.LFD.2.00.0907221655130.2813@localhost.localdomain> <4A67A0A2.40503@gmail.com>
In-Reply-To: <4A67A0A2.40503@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> Thomas Gleixner wrote:
>> +/*
>>   * Interrupt handler thread
>>   */
>>  static int irq_thread(void *data)
>> @@ -458,6 +494,8 @@ static int irq_thread(void *data)
>>  
>>  	while (!irq_wait_for_interrupt(action)) {
>>  
>> +		irq_thread_check_affinity(desc, action);
>> +
>>  		atomic_inc(&desc->threads_active);
>>  
>>  		spin_lock_irq(&desc->lock);
> 
> Any chance we could do this in a way that doesn't break the build for CONFIG_SMP=n? :)
> 
> Should this call simply be wrapped in an #ifdef, or should the function be defined for !SMP?
> 

Actually, I guess the function is defined always, but it references desc->affinity unconditionally.

Perhaps something like the following (likely whitespace damaged) patch:

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f0de36f..353e335 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -451,6 +451,8 @@ static int irq_wait_for_interrupt(struct irqaction *action)
        return -1;
 }
 
+#ifdef CONFIG_SMP
+
 /*
  * Check whether we need to change the affinity of the interrupt thread.
  */
@@ -479,6 +481,15 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
        free_cpumask_var(mask);
 }
 
+#else
+
+static void
+irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
+{
+}
+
+#endif
+
 /*
  * Interrupt handler thread
  */

