Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbYAOWut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbYAOWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYAOWul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:50:41 -0500
Received: from quasar.osc.edu ([192.148.249.15]:45359 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbYAOWuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:50:40 -0500
Date: Tue, 15 Jan 2008 17:50:39 -0500
From: Pete Wyckoff <pw@osc.edu>
To: dean gaudet <dean@arctic.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nosmp/maxcpus=0 or 1 -> TSC unstable
Message-ID: <20080115225039.GA25701@osc.edu>
References: <alpine.DEB.0.999999.0801121142370.11727@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.999999.0801121142370.11727@twinlark.arctic.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dean@arctic.org wrote on Sat, 12 Jan 2008 11:48 -0800:
> if i boot an x86 64-bit 2.6.24-rc7 kernel with nosmp, maxcpus=0 or 1 it 
> still disables TSC :)
> 
> Marking TSC unstable due to TSCs unsynchronized
> 
> this is an opteron 2xx box which does have two cpus and no clock-divide in 
> halt or cpufreq enabled so TSC should be fine with only one cpu.
> 
> pretty sure this is the culprit is that num_possible_cpus() > 1, which 
> would mean cpu_possible_map contains the second cpu... but i'm not quite 
> sure what the right fix is... or perhaps this is all intended.

We've seen the same problem.  We use gettimeofday() for timing of
network-ish operations on the order of 10-50 us.  But not having
the TSC makes gettimeofday() itself very slow, on the order of 30 us.

Here's what we've been using for quite a few kernel versions.  I've
not tried to submit it for fear that it could break some other
scenario, as you suggest.  Although in hotplug scenarios, this
function unsynchronized_tsc() should get rerun and disable TSC if
more processors arrive.

At least count this as a "me too".

		-- Pete


>From 0cdcd494bc0e27f49438bc2fc72fd3823629802b Mon Sep 17 00:00:00 2001
From: Pete Wyckoff <pw@osc.edu>
Date: Tue, 15 Jan 2008 17:42:28 -0500
Subject: [PATCH] use tsc on 1 cpu smp

Use num_online_cpus() instead of num_present_cpus() as the
parameter to check when deciding if TSC is good enough.  Thus
explicitly booting with maxcpus=1 will let us use the TSC even on
a dual-processor machine.  This helps reduce gettimeofday
overheads on our dual Opteron nodes immensely (30 us vs 0.5 us).

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 arch/x86/kernel/tsc_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 9c70af4..5f2e91f 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -235,7 +235,7 @@ __cpuinit int unsynchronized_tsc(void)
 	}
 
 	/* Assume multi socket systems are not synchronized */
-	return num_present_cpus() > 1;
+	return num_online_cpus() > 1;
 }
 
 int __init notsc_setup(char *s)
-- 
1.5.3.7

