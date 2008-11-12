Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYKLSf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYKLSf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbYKLSfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:35:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYKLSfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:35:15 -0500
Message-ID: <491B21D4.5030001@redhat.com>
Date: Wed, 12 Nov 2008 13:35:00 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mark.langsdorf@amd.com
Subject: Re: [PATCH] Warn of incorrect cpu_khz on AMD systems
References: <20081104152720.9964.71959.sendpatchset@prarit.bos.redhat.com> <20081106090118.GC4890@elte.hu>
In-Reply-To: <20081106090118.GC4890@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------070605080406080107040504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070605080406080107040504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

New patch replacing printk with WARN() based on Ingo's suggestion...

P.


--------------070605080406080107040504
Content-Type: text/plain;
 name="upstream.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="upstream.patch"

If none of the perfctrs are free when calculating cpu_khz we default to using
ctr 3 (ie, we just choose 3).  This may lead to an incorrect tsc freq value
which can cause the system to be unstable.

To aid in future debugging, WARN the user of a potential problem.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index cb19d65..e71d1ba 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -80,6 +80,8 @@ unsigned long __init calibrate_cpu(void)
 			break;
 	no_ctr_free = (i == 4);
 	if (no_ctr_free) {
+		WARN(1, KERN_WARN "Warning: AMD perfctrs busy ... "
+		     "cpu_khz value may be incorrect.\n");
 		i = 3;
 		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
 		wrmsrl(MSR_K7_EVNTSEL3, 0);

--------------070605080406080107040504--
