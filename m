Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbYCEO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbYCEO73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYCEO7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:59:16 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:45952 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYCEO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:59:15 -0500
From: Stephan Diestelhorst <langer_mann@web.de>
To: davej@codemonkey.org.uk
Subject: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Date: Wed, 5 Mar 2008 15:59:09 +0100
User-Agent: KMail/1.9.6
Cc: cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051559.09962.langer_mann@web.de>
X-Provags-ID: V01U2FsdGVkX18UP78EQR4PDw6OC4kO6Qat2OHtp9dZsLHECySG
	RjNRVk/M/12zP4vwBJvlU08o8mmXRtSkW9boRhVyzoTutvtOv2
	7Jl1coZyo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dave,
  I have found that using SMI to change the cpu's frequency on my DELL 
Latitude L400 clobbers the ECX register in speedstep_set_state, causing 
unneccessary retries because the "state" variable has changed silently (GCC 
assumes it is still present in ECX).

The patch is simple: Introduce temporary output "clobber_ecx" operand that 
consumes the clobbered value.

Cheers,
  Stephan

Signed-off: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>

--

--- linux-2.6.24.3/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c.orig	2008-02-26 
01:20:20.000000000 +0100
+++ linux-2.6.24.3/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c	2008-03-05 
15:56:42.000000000 +0100
@@ -160,7 +160,7 @@ static int speedstep_get_state (void)
  */
 static void speedstep_set_state (unsigned int state)
 {
-	unsigned int result = 0, command, new_state;
+	unsigned int result = 0, command, new_state, ecx_clobber;
 	unsigned long flags;
 	unsigned int function=SET_SPEEDSTEP_STATE;
 	unsigned int retry = 0;
@@ -184,7 +184,7 @@ static void speedstep_set_state (unsigne
 		__asm__ __volatile__(
 			"movl $0, %%edi\n"
 			"out %%al, (%%dx)\n"
-			: "=b" (new_state), "=D" (result)
+			: "=b" (new_state), "=D" (result), "=c" (ecx_clobber)
 			: "a" (command), "b" (function), "c" (state), "d" (smi_port), "S" (0)
 			);
 	} while ((new_state != state) && (retry <= SMI_TRIES));
@@ -195,7 +195,7 @@ static void speedstep_set_state (unsigne
 	if (new_state == state) {
 		dprintk("change to %u MHz succeeded after %u tries with result %u\n", 
(speedstep_freqs[new_state].frequency / 1000), retry, result);
 	} else {
-		printk(KERN_ERR "cpufreq: change failed with new_state %u and result %u\n", 
new_state, result);
+		printk(KERN_ERR "cpufreq: change to state %u failed with new_state %u and 
result %u\n", state, new_state, result);
 	}
 
 	return;
