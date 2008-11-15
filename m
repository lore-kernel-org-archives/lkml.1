Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYKONd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYKONd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 08:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYKONdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 08:33:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbYKONdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 08:33:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11989] Suspend failure on NForce4-based boards due to chanes in stop_machine
Date: Sat, 15 Nov 2008 14:37:45 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera> <20081111105214.GA15645@elte.hu> <200811112256.58467.rusty@rustcorp.com.au>
In-Reply-To: <200811112256.58467.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811151437.46270.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of November 2008, Rusty Russell wrote:
> On Tuesday 11 November 2008 21:22:14 Ingo Molnar wrote:
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > So, it evidently fails while re-enabling the non-boot CPU and not
> > > during disabling it as I thought before.
> 
> (Resend, due to HTML version previously)
> 
> But what is calling stop_machine in that path?
> 
> There *is* a race, but I don't think it could cause this (we should make a
> copy of active.fnret inside the lock before returning it).

Still, that seems to be the case.

> Two patches: one fixes that race, the next adds debugging spew.
> 
> stop_machine: fix race with return value

With this patch applied (reproduced below for clarity) the problem is not
reproducible any more.

Care to push it upstream ASAP?

Thanks,
Rafael

---
stop_machine: fix race with return value

We should not access active.fnret outside the lock; in theory the next
stop_machine could overwrite it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/stop_machine.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -r d7c9a15da615 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Mon Nov 10 09:47:45 2008 +1100
+++ b/kernel/stop_machine.c	Tue Nov 11 23:19:47 2008 +1030
@@ -112,7 +112,7 @@
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
 	struct work_struct *sm_work;
-	int i;
+	int i, ret;
 
 	/* Set up initial state. */
 	mutex_lock(&lock);
@@ -137,8 +137,9 @@
 	/* This will release the thread on our CPU. */
 	put_cpu();
 	flush_workqueue(stop_machine_wq);
+	ret = active.fnret;
 	mutex_unlock(&lock);
-	return active.fnret;
+	return ret;
 }
 
 int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)

