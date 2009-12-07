Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbZLGAWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbZLGAWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbZLGAV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:21:56 -0500
Received: from kroah.org ([198.145.64.141]:34643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575AbZLGANl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:41 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:56 2009
Message-Id: <20091207000655.925379789@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dominik Brodowski <linux@brodo.de>, Dave Jones <davej@redhat.com>
Subject: [085/119] [CPUFREQ] speedstep-ich: fix error caused by 394122ab144dae4b276d74644a2f11c44a60ac5c
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=speedstep-ich-fix-error-caused-by-394122ab144dae4b276d74644a2f11c44a60ac5c.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rusty Russell <rusty@rustcorp.com.au>

commit 8dca15e40889e5d5e9655b03ba79c26200f760ce upstream.

"[CPUFREQ] cpumask: avoid playing with cpus_allowed in speedstep-ich.c"
changed the code to mistakenly pass the current cpu as the "processor"
argument of speedstep_get_frequency(), whereas it should be the type of
the processor.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14340

Based on a patch by Dave Mueller.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Dominik Brodowski <linux@brodo.de>
Reported-by: Dave Mueller <dave.mueller@gmx.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -232,28 +232,23 @@ static unsigned int speedstep_detect_chi
 	return 0;
 }
 
-struct get_freq_data {
-	unsigned int speed;
-	unsigned int processor;
-};
-
-static void get_freq_data(void *_data)
+static void get_freq_data(void *_speed)
 {
-	struct get_freq_data *data = _data;
+	unsigned int *speed = _speed;
 
-	data->speed = speedstep_get_frequency(data->processor);
+	*speed = speedstep_get_frequency(speedstep_processor);
 }
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	struct get_freq_data data = { .processor = cpu };
+	unsigned int speed;
 
 	/* You're supposed to ensure CPU is online. */
-	if (smp_call_function_single(cpu, get_freq_data, &data, 1) != 0)
+	if (smp_call_function_single(cpu, get_freq_data, &speed, 1) != 0)
 		BUG();
 
-	dprintk("detected %u kHz as current frequency\n", data.speed);
-	return data.speed;
+	dprintk("detected %u kHz as current frequency\n", speed);
+	return speed;
 }
 
 /**


