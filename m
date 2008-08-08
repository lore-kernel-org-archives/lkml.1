Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbYHHRvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbYHHRvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYHHRv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:51:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54220 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYHHRv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:51:27 -0400
Date: Fri, 8 Aug 2008 10:50:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: mark.langsdorf@amd.com, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] powernow-k8: fix build errors
Message-Id: <20080808105040.291097a2.randy.dunlap@oracle.com>
In-Reply-To: <20080808173822.GP26295@codemonkey.org.uk>
References: <20080808101950.7a942fa6.randy.dunlap@oracle.com>
	<20080808173822.GP26295@codemonkey.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 13:38:22 -0400 Dave Jones wrote:

> I think something like below may be better..
> Same thing, but with one less ifdef ?

Close, but no cigar.

> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> index 7a09ba4..3ba6fd2 100644
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -951,6 +951,7 @@ static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data)
>  }
>  
>  #else
> +static int powernow_k8_cpu_preinit_acpi(struct powernow_k8_data *data) { return -ENODEV; }

(void) // parameters

>  static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data) { return -ENODEV; }
>  static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data) { return; }
>  static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index) { return; }
> @@ -1349,7 +1351,9 @@ static void __exit powernowk8_exit(void)
>  	dprintk("exit\n");
>  
>  	cpufreq_unregister_driver(&cpufreq_amd64_driver);
> 
> +#ifdef CONFIG_X86_POWERNOW_K8_ACPI
>  	free_percpu(acpi_perf_data);
> +#ifdef

#endif

>  }
>  
>  MODULE_AUTHOR("Paul Devriendt <paul.devriendt@amd.com> and Mark Langsdorf <mark.langsdorf@amd.com>");


---
(your) new patch:
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20080808.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-next-20080808/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -951,6 +951,7 @@ static void powernow_k8_cpu_exit_acpi(st
 }
 
 #else
+static int powernow_k8_cpu_preinit_acpi(void) { return -ENODEV; }
 static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data) { return -ENODEV; }
 static void powernow_k8_cpu_exit_acpi(struct powernow_k8_data *data) { return; }
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index) { return; }
@@ -1349,7 +1350,9 @@ static void __exit powernowk8_exit(void)
 
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 
+#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 	free_percpu(acpi_perf_data);
+#endif
 }
 
 MODULE_AUTHOR("Paul Devriendt <paul.devriendt@amd.com> and Mark Langsdorf <mark.langsdorf@amd.com>");
