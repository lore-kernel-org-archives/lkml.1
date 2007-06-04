Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbXFDQ4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbXFDQ4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704AbXFDQ4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:56:44 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21463 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843AbXFDQ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:56:43 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Peter Oruba" <peter.oruba@amd.com>
Organization: AMD
To: cpufreq@lists.linux.org.uk
Subject: [PATCH] bugfix cpufreq in combination with performance governor
Date: Mon, 4 Jun 2007 18:56:23 +0200
User-Agent: KMail/1.9.7
cc: "Linux List" <linux-kernel@vger.kernel.org>
References: <200705291547.10134.peter.oruba@amd.com>
 <20070529160621.GC13235@redhat.com>
 <200705291820.06896.peter.oruba@amd.com>
In-Reply-To: <200705291820.06896.peter.oruba@amd.com>
MIME-Version: 1.0
Message-ID: <200706041856.23594.peter.oruba@amd.com>
X-OriginalArrivalTime: 04 Jun 2007 16:56:23.0573 (UTC)
 FILETIME=[48584450:01C7A6C9]
X-WSS-ID: 6A7A9BB020G4004511-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Mai 2007 18:20:06 schrieb Peter Oruba:
> Am Dienstag, 29. Mai 2007 18:06:21 schrieben Sie:
> > On Tue, May 29, 2007 at 03:47:00PM +0200, Peter Oruba wrote:
> >  > Dave,
> >  > 
> >  > I am contacting you regarding a frequency scaling issue that I encountered with the performance governor in combination with CPU hotplug. In cpufreq.c CPU frequency is reduced to its 
> >  > minimum before the CPU gets unregistered and set offline. Does that have a particular reason? Since the (k8-)governor does not monitor CPU frequency that setting also applies then to the remaining CPU
> >  > as well and lets the system run on the lowest frequency although performance is chose as the policy.
> >  > 
> >  > ---
> >  > static int cpufreq_cpu_callback(struct notifier_block *nfb,
> >  >                                         unsigned long action, void *hcpu)
> >  > {
> >  > 
> >  > [......]
> >  > 
> >  >                 case CPU_DOWN_PREPARE_FROZEN:
> >  >                         if (unlikely(lock_policy_rwsem_write(cpu)))
> >  >                                 BUG();
> >  > 
> >  >                         policy = cpufreq_cpu_data[cpu];
> >  >                         if (policy) {
> >  >                                 __cpufreq_driver_target(policy, policy->min,
> >  >                                                 CPUFREQ_RELATION_H);
> >  >                         }
> >  >                         __cpufreq_remove_dev(sys_dev);
> > 
> > This is the path taken when we call suspend.
> > To be honest, I doubt that reducing the speed has any benefit at all,
> > as we're about to put the CPU to sleep anyway.
> > 
> > (btw, in future sending questions to cpufreq@lists.linux.org.uk is a better
> >  idea. The subsystem is sufficiently complex that at times, others can
> >  answer questions better than I can, especially with the various
> >  implementations all being subtley different).
> > 
> > Thanks,
> > 
> > 	Dave
> > 
> Okay, removing the __cpufreq_driver_target call would solve would obviously solve that problem (which btw also exists on Core2, as I tested a couple of minutes ago). Is it planned to be changed 
> in the near future?
> 
> Thanks,
> Peter
> 
My patch, aimed at that issue.

Signed-off by: Peter Oruba <peter.oruba@amd.com>

---
--- cpufreq/drivers/cpufreq/cpufreq.c.orig      2007-06-04 18:30:57.000000000 +0200
+++ cpufreq/drivers/cpufreq/cpufreq.c   2007-06-04 18:43:01.000000000 +0200
@@ -1698,11 +1698,6 @@ static int cpufreq_cpu_callback(struct n
                        if (unlikely(lock_policy_rwsem_write(cpu)))
                                BUG();

-                       policy = cpufreq_cpu_data[cpu];
-                       if (policy) {
-                               __cpufreq_driver_target(policy, policy->min,
-                                               CPUFREQ_RELATION_H);
-                       }
                        __cpufreq_remove_dev(sys_dev);
                        break;
                case CPU_DOWN_FAILED:

---

-- 
AMD Saxony Limited Liability Company & Co. KG
Operating System Research Center
Wilschdorfer Landstr. 101, 01109 Dresden, Germany
Register Court Dresden: HRA 4896
General Partner authorized to represent:
AMD Saxony LLC (Wilmington, Delaware, US)
General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


