Return-Path: <linux-kernel-owner+w=401wt.eu-S937288AbXFGVzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937288AbXFGVzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936676AbXFGVy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:54:59 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:24769 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937262AbXFGVy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:54:57 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 7 Jun 2007 23:55:03 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Stephane Eranian" <eranian@hpl.hp.com>
cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/22] 2.6.22-rc3 perfmon2 : new x86_64 files
Message-ID: <20070607215503.GC29058@erda.amd.com>
References: <200705291348.l4TDmZrR019866@frankl.hpl.hp.com>
 <p73myzlcb2b.fsf@bingen.suse.de>
 <20070531164638.GB23939@frankl.hpl.hp.com>
MIME-Version: 1.0
In-Reply-To: <20070531164638.GB23939@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 07 Jun 2007 21:54:41.0345 (UTC)
 FILETIME=[737CCB10:01C7A94E]
X-WSS-ID: 6A76A12E05S101882-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

> > > +
> > > +	if (current_cpu_data.x86 != 15) {
> > > +		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
> > > +		return -1;
> > > +	}
> > 
> > Already obsolete with Barcelona and Griffin (16 and 17) but very similar
> > counters. 
> > 
> Yes, but those will get new description modules.

see enclosed patch that also enables Barcelona cores. I have tested
your releases on K8 and Barcelona. 2.6.21 release
(perfmon-new-base-070509) works fine. In 2.6.22-rc3 syscalls seems to
be broken. I receive a EBADF error when trying to create a context. It
seems that sys_pfm_create_context() is never called. I could not yet
dig into this deeper.

There are also patches available for new family 10 features. I will
release these patches next week. I already implemented a generic AMD64
PMU description that detects features for different families and CPU
revisions. Enclosed patch is part of the patch series.

-Robert



Index: linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/i386/perfmon/perfmon.c
+++ linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
@@ -1059,6 +1059,7 @@ char *pfm_arch_get_pmu_module_name(void)
 			goto try_arch;
 		}
 	case 15:
+	case 16:
 		/* All Opteron processors */
 		if (cpu_data->x86_vendor == X86_VENDOR_AMD)
 			return "perfmon_k8";
Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
+++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
@@ -307,7 +307,12 @@ static int pfm_k8_probe_pmu(void)
 		return -1;
 	}
 
-	if (current_cpu_data.x86 != 15) {
+	switch (current_cpu_data.x86) {
+	case 15:
+	case 16:
+		PFM_INFO("found family=%d", current_cpu_data.x86);
+		break;
+	default:
 		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
 		return -1;
 	}

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



