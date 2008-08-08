Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbYHHToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbYHHToT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYHHToL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:44:11 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:31584 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYHHToK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:44:10 -0400
X-BigFish: VPS-21(z21eWz936eQzzzzz32i6bh43j)
X-WSS-ID: 0K5AS52-02-0E6-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Date: Fri, 8 Aug 2008 14:44:00 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC5A@sausexmb4.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression in 2.6.27-rc1 for set_cpus_allowed_ptr
Thread-Index: Acj5jxsH3+Ta4d+QTP2yO9FmkW1I6w==
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Aug 2008 19:44:01.0314 (UTC) FILETIME=[1B440020:01C8F98F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of my co-workers noticed that the powernow-k8
driver no longer restarts when a CPU core is 
hot-disabled and then hot-enabled on AMD quad-core
systems.  

The following comands work fine on 2.6.26 and fail 
on 2.6.27-rc1:

echo 0 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu3/online
find /sys -name cpufreq

For 2.6.26, the find will return a cpufreq
directory for each processor.  In 2.6.27-rc1,
the cpu3 directory is missing.

After digging through the code, the following
logic is failing when the core is hot-enabled
at runtime.  The code works during the boot
sequence.

	cpumask_t = current->cpus_allowed;
	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
	if (smp_processor_id() != cpu)
		return -ENODEV;

The objective is to move to the specific CPU and
test it's MSRs to see if it is supported.  For
some reason, it isn't working.  Any suggestions
on how to fix this are appreciated.

-Mark Langdsorf
Operating System Research Center
AMD

