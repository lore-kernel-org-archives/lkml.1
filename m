Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYGHNL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYGHNL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 09:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYGHNLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 09:11:51 -0400
Received: from ozlabs.org ([203.10.76.45]:37034 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYGHNLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 09:11:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Date: Tue, 8 Jul 2008 23:11:35 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Jason Baron" <jbaron@redhat.com>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au> <961aa3350807080444i4439ca33x3eee80113cd6a907@mail.gmail.com>
In-Reply-To: <961aa3350807080444i4439ca33x3eee80113cd6a907@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807082311.35793.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 21:44:40 Akinobu Mita wrote:
> I found a small possible cleanup in this patch.

Well spotted!  I think this cleanup is actually orthogonal to my patch,
so best served as a separate patch, how's this?

===
Hotplug CPU: don't check cpu_online after take_cpu_down

Akinobu points out that if take_cpu_down() succeeds, the cpu must be offline
(otherwise we're in deep trouble anyway.

Remove the cpu_online() check, and put a BUG_ON().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Akinobu Mita" <akinobu.mita@gmail.com>

diff -r 805a2e5e68dd kernel/cpu.c
--- a/kernel/cpu.c	Tue Jul 08 23:04:48 2008 +1000
+++ b/kernel/cpu.c	Tue Jul 08 23:07:43 2008 +1000
@@ -226,8 +226,7 @@ static int __ref _cpu_down(unsigned int 
 	set_cpus_allowed_ptr(current, &tmp);
 
 	err = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
-
-	if (err || cpu_online(cpu)) {
+	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
@@ -235,6 +234,7 @@ static int __ref _cpu_down(unsigned int 
 
 		goto out_allowed;
 	}
+	BUG_ON(cpu_online(cpu));
 
 	/* Wait for it to sleep (leaving idle task). */
 	while (!idle_cpu(cpu))
