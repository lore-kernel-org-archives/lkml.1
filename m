Return-Path: <linux-kernel-owner+w=401wt.eu-S970436AbXFIDIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970436AbXFIDIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 23:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968629AbXFIDIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 23:08:16 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:32368 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968490AbXFIDIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 23:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:subject:to:cc:x-priority:in-reply-to:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:from;
        b=jghQaO1XdiLpDrTQriqEiPBF3Q9lH8OfrDrTORBlzgLV9fmMPZga7PrtkrWGTinrVJiJ0OzgPP4zTqpLtRP8nAVsopiRXql9YvbQHJg4I/CVHA5HUltgWudcnhTJoNkgzYY/wmxWes4+q8YjKpSzFFuxrbNeiHIKijyQT9oGZRU=
Date: Fri,  8 Jun 2007 22:08:12 -0500
Subject: [PATCH] [RFC] wrong cpus started
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Mark Rustad <mrustad@gmail.com>
X-Priority: 3
In-Reply-To: <30838F2E-65FC-4566-9DFE-359401BB3F54@gmail.com>
Message-ID: <r02010500-1049-A8BB7786163611DC88190011247BAB0A@[192.168.1.21]>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Mailer: Mailsmith 2.1.5 (Blindsider)
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed that recent kernels, 2.6.16 through at least 2.6.19, hyperthreading
can no longer be effectively disabled by using maxcpus. This means that anyone that
was using maxcpus to disable hyperthreading when running Linux will no longer be
using all of their physical cpus.

The following patch restores the earlier behavior, but I am fairly sure that some
CPU hotplug environments would not want this change. I can imagine making the two
lines moved in the patch below to instead be conditional on CONFIG_HOTPLUG_CPU and
!CONFIG_HOTPLUG_CPU respectively. Can someone more familiar with hotplug CPU come
up with a better fix?

--- a/arch/i386/kernel/mpparse.c	2006-11-29 15:57:37.000000000 -0600
+++ b/arch/i386/kernel/mpparse.c	2007-06-06 16:41:06.635814335 -0500
@@ -180,9 +180,6 @@ static void __devinit MP_processor_info 
 	}
 	apic_version[m->mpc_apicid] = ver;
 
-	phys_cpu = apicid_to_cpu_present(apicid);
-	physids_or(phys_cpu_present_map, phys_cpu_present_map, phys_cpu);
-
 	if (num_processors >= NR_CPUS) {
 		printk(KERN_WARNING "WARNING: NR_CPUS limit of %i reached."
 			"  Processor ignored.\n", NR_CPUS);
@@ -195,6 +192,9 @@ static void __devinit MP_processor_info 
 		return;
 	}
 
+	phys_cpu = apicid_to_cpu_present(apicid);
+	physids_or(phys_cpu_present_map, phys_cpu_present_map, phys_cpu);
+
 	cpu_set(num_processors, cpu_possible_map);
 	num_processors++;
 
-- 
Mark Rustad, mrustad@gmail.com
