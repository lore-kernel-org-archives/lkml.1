Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYHHRhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYHHRhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYHHRhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:37:42 -0400
Received: from testure.choralone.org ([194.9.77.134]:35892 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYHHRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:37:41 -0400
Date: Fri, 8 Aug 2008 13:38:22 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mark.langsdorf@amd.com, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] powernow-k8: fix build errors
Message-ID: <20080808173822.GP26295@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Randy Dunlap <randy.dunlap@oracle.com>, mark.langsdorf@amd.com,
	lkml <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>
References: <20080808101950.7a942fa6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808101950.7a942fa6.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 10:19:50AM -0700, Randy Dunlap wrote:
 > From: Randy Dunlap <randy.dunlap@oracle.com>
 > 
 > Fix build when CONFIG_X86_POWERNOW_K8_ACPI=n:
 > (seems that someone forgot to test this build combo)
 > (fix 25 of 50 randconfig build errors)

Yikes. I'll add that to my pre-push test script.
(I currently only test allmodconfig/allyes/allno for all
 the changed files within each patch)

 > linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1334: error: implicit declaration of function 'powernow_k8_cpu_preinit_acpi'
 > linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1352: error: 'acpi_perf_data' undeclared (first use in this function)
 > 
 > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
 > ---
 >  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    4 ++++
 >  1 file changed, 4 insertions(+)
 > 
 > --- linux-next-20080808.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
 > +++ linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
 > @@ -1331,7 +1331,9 @@ static int __cpuinit powernowk8_init(voi
 >  	}
 >  
 >  	if (supported_cpus == num_online_cpus()) {
 > +#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 >  		powernow_k8_cpu_preinit_acpi();
 > +#endif

I think something like below may be better..
Same thing, but with one less ifdef ?

	Dave

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 7a09ba4..3ba6fd2 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -951,6 +951,7 @@ static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data)
 }
 
 #else
+static int powernow_k8_cpu_preinit_acpi(struct powernow_k8_data *data) { return -ENODEV; }
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data) { return -ENODEV; }
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data) { return; }
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index) { return; }
@@ -1349,7 +1351,9 @@ static void __exit powernowk8_exit(void)
 	dprintk("exit\n");
 
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);

+#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 	free_percpu(acpi_perf_data);
+#ifdef
 }
 
 MODULE_AUTHOR("Paul Devriendt <paul.devriendt@amd.com> and Mark Langsdorf <mark.langsdorf@amd.com>");
-- 
http://www.codemonkey.org.uk
