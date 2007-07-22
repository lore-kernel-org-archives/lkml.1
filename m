Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbXGVPpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbXGVPpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbXGVPo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:60825 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbXGVPoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=Oz8OfNRRHhXKG98gd37rerxD4yXfl+ymQyf01DBRkvbIeYjdpRrxkP3pB67n9bTUGr6SdUcy73juywpweYaU1Ou5Qb6OqeDO86Sd7WnkFl5s17xPiL5yrHBONqywcVDVwUqKU+OU8Rax9LHtUPYQSHjfPtVG9DgwKFOb+wkWoX4=
Message-Id: <20070722153349.369335694@gmail.com>
References: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:15 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitriy Zavin <dmitriyz@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Ashok Raj <ashok.raj@intel.com>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 3/9] cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
Content-Disposition: inline; filename=cpuhotplug-nr-calls.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

The functions in a CPU notifier chain is called with CPU_UP_PREPARE event
before making the CPU online. If one of the callback returns NOTIFY_BAD,
it stops to deliver CPU_UP_PREPARE event, and CPU online operation is canceled.
Then CPU_UP_CANCELED event is delivered to the functions in a CPU notifier
chain again.

This CPU_UP_CANCELED event is delivered to the functions which have been
called with CPU_UP_PREPARE, not delivered to the functions which haven't
been called with CPU_UP_PREPARE.

The problem that makes existing cpu hotplug error handlings complex is
that the CPU_UP_CANCELED event is delivered to the function that has
returned NOTIFY_BAD, too.

Usually we don't expect to call destructor function against the
object that has failed to initialize. It is like:

	err = register_something();
	if (err) {
		unregister_something();
		return err;
	}

So it is natural to deliver CPU_UP_CANCELED event only to the functions
that have returned NOTIFY_OK with CPU_UP_PREPARE event and not to call
the function that have returned NOTIFY_BAD. This is what this patch is doing.

Otherwise, every cpu hotplug notifiler has to track whether
notifiler event is failed or not for each cpu.
(drivers/base/topology.c is doing this with topology_dev_map)

Similary this patch makes same thing with CPU_DOWN_PREPARE and
CPU_DOWN_FAILED evnets.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 kernel/cpu.c |    2 ++
 1 file changed, 2 insertions(+)

Index: 2.6-git/kernel/cpu.c
===================================================================
--- 2.6-git.orig/kernel/cpu.c
+++ 2.6-git/kernel/cpu.c
@@ -150,6 +150,7 @@ static int _cpu_down(unsigned int cpu, i
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
+		nr_calls--;
 		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					  hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
@@ -233,6 +234,7 @@ static int __cpuinit _cpu_up(unsigned in
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
+		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
 				__FUNCTION__, cpu);
 		ret = -EINVAL;

-- 
