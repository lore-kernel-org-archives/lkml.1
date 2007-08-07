Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbXHGVQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbXHGVQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964946AbXHGUzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:55:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59701 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964920AbXHGUzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:55:04 -0400
Date: Tue, 7 Aug 2007 13:47:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [2.6.22.2 review 57/84] acpi-cpufreq: Proper ReadModifyWrite of
	PERF_CTL MSR
Message-ID: <20070807204755.GG23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-cpufreq-proper-readmodifywrite-of-perf_ctl-msr.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

[CPUFREQ] acpi-cpufreq: Proper ReadModifyWrite of PERF_CTL MSR

During recent acpi-cpufreq changes, writing to PERF_CTL msr
changed from RMW of entire 64 bit to RMW of low 32 bit and clearing of
upper 32 bit. Fix it back to do a proper RMW of the MSR.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -167,11 +167,13 @@ static void do_drv_read(struct drv_cmd *
 
 static void do_drv_write(struct drv_cmd *cmd)
 {
-	u32 h = 0;
+	u32 lo, hi;
 
 	switch (cmd->type) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
-		wrmsr(cmd->addr.msr.reg, cmd->val, h);
+		rdmsr(cmd->addr.msr.reg, lo, hi);
+		lo = (lo & ~INTEL_MSR_RANGE) | (cmd->val & INTEL_MSR_RANGE);
+		wrmsr(cmd->addr.msr.reg, lo, hi);
 		break;
 	case SYSTEM_IO_CAPABLE:
 		acpi_os_write_port((acpi_io_address)cmd->addr.io.port,
@@ -372,7 +374,6 @@ static int acpi_cpufreq_target(struct cp
 	struct cpufreq_freqs freqs;
 	cpumask_t online_policy_cpus;
 	struct drv_cmd cmd;
-	unsigned int msr;
 	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	unsigned int i;
@@ -417,11 +418,7 @@ static int acpi_cpufreq_target(struct cp
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_CTL;
-		msr =
-		    (u32) perf->states[next_perf_state].
-		    control & INTEL_MSR_RANGE;
-		cmd.val = get_cur_val(online_policy_cpus);
-		cmd.val = (cmd.val & ~INTEL_MSR_RANGE) | msr;
+		cmd.val = (u32) perf->states[next_perf_state].control;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;

-- 
