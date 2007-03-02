Return-Path: <linux-kernel-owner+w=401wt.eu-S1423003AbXCBKbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423003AbXCBKbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 05:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161328AbXCBKbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 05:31:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161184AbXCBKbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 05:31:06 -0500
Date: Fri, 2 Mar 2007 11:22:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>,
       git@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [patch] KVM: T60 resume fix
Message-ID: <20070302102216.GA13575@elte.hu>
References: <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070301104117.GA22788@elte.hu> <20070301145204.GA25304@elte.hu> <Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org> <20070302072100.GB30634@elte.hu> <20070302080441.GA12785@elte.hu> <20070302102018.GA11549@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302102018.GA11549@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] KVM: T60 resume fix
From: Ingo Molnar <mingo@elte.hu>

my T60 laptop does not resume correctly due to KVM attempting to send an 
IPI to a CPU that might be down (or not up yet). (Doing so also triggers 
the send_IPI_mask_bitmask() warning in arch/i386/kernel/smp.c, line 
732.)

with this fix applied my laptop does not hang during resume.

[ KVM will have to disable/enable virtualization on the CPU itself that
  goes down / comes up, not via an IPI sent from the requesting CPU. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/kvm/kvm_main.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux/drivers/kvm/kvm_main.c
===================================================================
--- linux.orig/drivers/kvm/kvm_main.c
+++ linux/drivers/kvm/kvm_main.c
@@ -2083,12 +2083,6 @@ static int kvm_cpu_hotplug(struct notifi
 	case CPU_DEAD:
 	case CPU_UP_CANCELED:
 		decache_vcpus_on_cpu(cpu);
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
-					 NULL, 0, 1);
-		break;
-	case CPU_UP_PREPARE:
-		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
-					 NULL, 0, 1);
 		break;
 	}
 	return NOTIFY_OK;
