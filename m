Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbXGMEyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbXGMEyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 00:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbXGMExy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 00:53:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbXGMExx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 00:53:53 -0400
Date: Fri, 13 Jul 2007 00:53:46 -0400
From: Dave Jones <davej@redhat.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: Re: CPUFreq compilation failure with current GIT.
Message-ID: <20070713045346.GA28641@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Mark Langsdorf <mark.langsdorf@amd.com>
References: <200707131323.22185.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707131323.22185.nigel@nigel.suspend2.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 01:23:16PM +1000, Nigel Cunningham wrote:
 > Hi.
 > 
 > Current git compilation fails on my amd64:
 > 
 >   CC [M]  arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/acpi-cpufreq.o
 >   CC [M]  arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/powernow-k8.o
 > arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/powernow-k8.c: In function 'powernowk8_init':
 > arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/powernow-k8.c:1334: error: 'struct cpuinfo_x86' has no member named 'booted_cores'
 > make[2]: *** [arch/x86_64/kernel/cpufreq/../../../i386/kernel/cpu/cpufreq/powernow-k8.o] Error 1
 > make[1]: *** [arch/x86_64/kernel/cpufreq] Error 2
 > make: *** [arch/x86_64/kernel] Error 2

Fixed in cpufreq.git, will go to linus real soon.
patch below..

	Dave


From: Andrew Morton <akpm@linux-foundation.org>

Make it compile on UP.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Jones <davej@redhat.com>
---

 arch/i386/kernel/cpu/cpufreq/powernow-k8.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/cpufreq/powernow-k8.c~git-cpufreq-fix arch/i386/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c~git-cpufreq-fix
+++ a/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
@@ -1322,16 +1322,21 @@ static struct cpufreq_driver cpufreq_amd
 static int __cpuinit powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0;
+	unsigned int booted_cores = 1;
 
 	for_each_online_cpu(i) {
 		if (check_supported_cpu(i))
 			supported_cpus++;
 	}
 
+#ifdef CONFIG_SMP
+	booted_cores = cpu_data[0].booted_cores;
+#endif
+
 	if (supported_cpus == num_online_cpus()) {
 		printk(KERN_INFO PFX "Found %d %s "
 			"processors (%d cpu cores) (" VERSION ")\n",
-			supported_cpus/cpu_data[0].booted_cores,
+			supported_cpus/booted_cores,
 			boot_cpu_data.x86_model_id, supported_cpus);
 		return cpufreq_register_driver(&cpufreq_amd64_driver);
 	}
_

-- 
http://www.codemonkey.org.uk
