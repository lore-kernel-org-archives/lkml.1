Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbYEHNUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbYEHNUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYEHNUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:20:45 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:27678 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYEHNUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:20:42 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH/RFC] stop_machine: make stop_machine_run more virtualization friendly
Date: Thu, 8 May 2008 15:20:38 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805081520.38310.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On kvm I have seen some rare hangs in stop_machine when I used more guest
cpus than hosts cpus. e.g. 32 guest cpus on 1 host cpu triggered the
hang quite often. I could also reproduce the problem on a 4 way z/VM host with 
a 64 way guest.

It turned out that the guest was consuming all available cpus mostly for
spinning on scheduler locks like rq->lock. This is expected as the threads are 
calling yield all the time. 
The problem is now, that the host scheduling decisings together with the guest 
scheduling decisions and spinlocks not being fair managed to create an 
interesting scenario similar to a live lock. (Sometimes the hang resolved 
itself after some minutes)

Changing stop_machine to yield the cpu to the hypervisor when yielding inside 
the guest fixed the problem for me. While I am not completely happy with this 
patch, I think it causes no harm and it really improves the situation for me.

I used cpu_relax for yielding to the hypervisor, does that work on all 
architectures?

p.s.: If you want to reproduce the problem, cpu hotplug and kprobes use 
stop_machine_run and both triggered the problem after some retries. 


Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>

---
 kernel/stop_machine.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: kvm/kernel/stop_machine.c
===================================================================
--- kvm.orig/kernel/stop_machine.c
+++ kvm/kernel/stop_machine.c
@@ -62,8 +62,7 @@ static int stopmachine(void *cpu)
 		 * help our sisters onto their CPUs. */
 		if (!prepared && !irqs_disabled)
 			yield();
-		else
-			cpu_relax();
+		cpu_relax();
 	}
 
 	/* Ack: we are exiting. */
@@ -106,8 +105,10 @@ static int stop_machine(void)
 	}
 
 	/* Wait for them all to come to life. */
-	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads)
+	while (atomic_read(&stopmachine_thread_ack) != stopmachine_num_threads) {
 		yield();
+		cpu_relax();
+	}
 
 	/* If some failed, kill them all. */
 	if (ret < 0) {

