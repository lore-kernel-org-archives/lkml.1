Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbXESKdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbXESKdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 06:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXESKdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 06:33:09 -0400
Received: from as3.cineca.com ([130.186.84.211]:49754 "EHLO as3.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756391AbXESKdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 06:33:08 -0400
Message-ID: <464ED258.2010903@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] limit print_fatal_signal() rate (was: [RFC] log out-of-virtual-memory
 events)
References: <E1Hp5PV-0001Bn-00@calista.eckenfels.net>
In-Reply-To: <E1Hp5PV-0001Bn-00@calista.eckenfels.net>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Sat, 19 May 2007 12:33:04 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels wrote:
> In article <464DCEAB.3090905@users.sourceforge.net> you wrote:
>>        printk("%s/%d: potentially unexpected fatal signal %d.\n",
>>                current->comm, current->pid, signr);
> 
> can we have both KERN_WARNING please?
> 
> Gruss
> Bernd

Depends on print_fatal_signals patch.

---

Limit the rate of print_fatal_signal() to avoid potential denial-of-service
attacks.

Signed-off-by: Andrea Righi <a.righi@cineca.it>

diff -urpN linux-2.6.22-rc1-mm1/kernel/signal.c linux-2.6.22-rc1-mm1-vm-log-enomem/kernel/signal.c
--- linux-2.6.22-rc1-mm1/kernel/signal.c	2007-05-19 11:25:24.000000000 +0200
+++ linux-2.6.22-rc1-mm1-vm-log-enomem/kernel/signal.c	2007-05-19 11:30:00.000000000 +0200
@@ -790,7 +790,10 @@ static void print_vmas(void)
 
 static void print_fatal_signal(struct pt_regs *regs, int signr)
 {
-	printk("%s/%d: potentially unexpected fatal signal %d.\n",
+	if (unlikely(!printk_ratelimit()))
+		return;
+
+	printk(KERN_WARNING "%s/%d: potentially unexpected fatal signal %d.\n",
 		current->comm, current->pid, signr);
 
 #ifdef __i386__
