Return-Path: <linux-kernel-owner+w=401wt.eu-S1764292AbYBPDox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764292AbYBPDox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYBPDop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:44:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:24770 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYBPDoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:44:44 -0500
Subject: [PATCH 1/2] Preempt realtime Oops syslog
From: Min Zhang <mzhang@mvista.com>
Reply-To: mzhang@mvista.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Monta Vista
Date: Fri, 15 Feb 2008 19:44:43 -0800
Message-Id: <1203133483.10893.25.camel@dhcp140.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bust_spinlocks when kernel die from do_trap to flush Oops
dump to syslog immediatly. Oops is missing from syslog if it is from
non-preemptible section, because on PREEMPT_RT kernel, Oops printk
doesn't wake up klogd from non-preemptible context; see
release_console_sem in kernel/printk.c. 

Tested by Oops in module_init and insmod that kernel module. The
Oops is in non-preemptive context because modules are loaded from 
inside a realtime priority thread in a preemptive realtime kernel. 

Only apply to PPC arch because bust_spinlocks has already been used 
by x86 and other architectures

Signed-off-by: Min Zhang <mzhang@mvista.com>

Index: rt-2.6/arch/ppc/kernel/traps.c
===================================================================
--- rt-2.6.orig/arch/ppc/kernel/traps.c
+++ rt-2.6/arch/ppc/kernel/traps.c
@@ -92,6 +92,7 @@ int die(const char * str, struct pt_regs
 	if (nl)
 		printk("\n");
 	show_regs(fp);
+	bust_spinlocks(0);
 	add_taint(TAINT_DIE);
 	spin_unlock_irq(&die_lock);
 	/* do_exit() should take care of panic'ing from an interrupt


