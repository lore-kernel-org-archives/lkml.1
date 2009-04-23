Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZDWH26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZDWH26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZDWH1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:23 -0400
Received: from sous-sol.org ([216.99.217.87]:48156 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754670AbZDWH1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:18 -0400
Message-Id: <20090423072218.102318325@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [patch 013/100] ACPI: cap off P-state transition latency from buggy BIOSes
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=acpi-cap-off-p-state-transition-latency-from-buggy-bioses.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

upstream commit: a59d1637eb0e0a37ee0e5c92800c60abe3624e24

Some BIOSes report very high frequency transition latency which are plainly
wrong on CPus that can change frequency using native MSR interface.

One such system is IBM T42 (2327-8ZU) as reported by Owen Taylor and
Rik van Riel.

cpufreq_ondemand driver uses this transition latency to come up with a
reasonable sampling interval to sample CPU usage and with such high
latency value, ondemand sampling interval ends up being very high
(0.5 sec, in this particular case), resulting in performance impact due to
slow response to increasing frequency.

Fix it by capping-off the transition latency to 20uS for native MSR based
frequency transitions.

mjg: We've confirmed that this also helps on the X31

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -680,6 +680,18 @@ static int acpi_cpufreq_cpu_init(struct 
 			    perf->states[i].transition_latency * 1000;
 	}
 
+	/* Check for high latency (>20uS) from buggy BIOSes, like on T42 */
+	if (perf->control_register.space_id == ACPI_ADR_SPACE_FIXED_HARDWARE &&
+	    policy->cpuinfo.transition_latency > 20 * 1000) {
+		static int print_once;
+		policy->cpuinfo.transition_latency = 20 * 1000;
+		if (!print_once) {
+			print_once = 1;
+			printk(KERN_INFO "Capping off P-state tranision latency"
+				" at 20 uS\n");
+		}
+	}
+
 	data->max_freq = perf->states[0].core_frequency * 1000;
 	/* table init */
 	for (i=0; i<perf->state_count; i++) {

