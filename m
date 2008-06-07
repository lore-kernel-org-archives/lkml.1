Return-Path: <linux-kernel-owner+w=401wt.eu-S1764167AbYFGBWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764167AbYFGBWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760762AbYFGBJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:41 -0400
Received: from sous-sol.org ([216.99.217.87]:42539 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759592AbYFGBJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:26 -0400
Message-Id: <20080607010625.185674501@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Renninger <trenn@suse.de>, "Anthony L. Awtrey" <tony@awtrey.com>
Subject: [patch 35/50] CPUFREQ: Make acpi-cpufreq more robust against BIOS freq changes behind our back.
Content-Disposition: inline; filename=make-acpi-cpufreq-more-robust-against-bios-freq-changes-behind-our-back.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

upstream commit: e56a727b023d40d1adf660168883f30f2e6abe0a

We checked the hardware freq with OS cached freq value in get_cur_freqon_cpu().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: "Anthony L. Awtrey" <tony@awtrey.com>
[chrisw: backport to 2.6.25.4]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -339,6 +339,7 @@ static unsigned int get_cur_freq_on_cpu(
 {
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, cpu);
 	unsigned int freq;
+	unsigned int cached_freq;
 
 	dprintk("get_cur_freq_on_cpu (%d)\n", cpu);
 
@@ -347,7 +348,16 @@ static unsigned int get_cur_freq_on_cpu(
 		return 0;
 	}
 
+	cached_freq = data->freq_table[data->acpi_data->state].frequency;
 	freq = extract_freq(get_cur_val(cpumask_of_cpu(cpu)), data);
+	if (freq != cached_freq) {
+		/*
+		 * The dreaded BIOS frequency change behind our back.
+		 * Force set the frequency on next target call.
+		 */
+		data->resume = 1;
+	}
+
 	dprintk("cur freq = %u\n", freq);
 
 	return freq;

-- 
