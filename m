Return-Path: <linux-kernel-owner+w=401wt.eu-S935952AbXFFWTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935952AbXFFWTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935124AbXFFWS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:18:56 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:44714 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934819AbXFFWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:mime-version:content-type:message-id:cc:content-transfer-encoding:subject:date:to:x-mailer:from;
        b=Rti1Qlc4iJ+7walrl8fxNYpmlQUA5WKf7sz+G0qtjsjarGMR5mgIpHVvy1vIYnz/N0+cTjSdfTrzh2FSb2MMdXqIdom4VMfgR/QbJhqDZjqiGaOHMTwVcd1cMYvF3LQwrrWu5FIDbT+GRhZkzQJ+w5cG0fhrg/1XJhr9L0x2ex4=
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <30838F2E-65FC-4566-9DFE-359401BB3F54@gmail.com>
Cc: Mark Rustad <MRustad@mac.com>
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC] X86 SMP cpu enumeration changes
Date: Wed, 6 Jun 2007 17:18:52 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.752.2)
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As a followup to the message I posted earlier, I found that the  
following patch restores the old behavior of allowing maxcpus to  
effectively turn off hyperthreading. In case you missed my earlier  
message, in 2.6.16 through at least 2.6.19 using the maxcpus trick  
will fail to use all of your physical cpus.

Although this patch works for me, I am quite sure that this patch is  
unacceptable to folks using CPU hotplug, however. One alternative  
would be to make the two lines of code in each location conditional  
on CONFIG_HOTPLUG_CPU and !CONFIG_HOTPLUG_CPU respectively, but that  
seems a little ugly.

Does anyone have a better fix?

I know my mailer smashes the patch, but this is intended for  
discussion rather than application.

--- a/arch/i386/kernel/mpparse.c        2006-11-29 15:57:37.000000000  
-0600
+++ b/arch/i386/kernel/mpparse.c	2007-06-06 16:41:06.635814335 -0500
@@ -180,9 +180,6 @@ static void __devinit MP_processor_info
         }
         apic_version[m->mpc_apicid] = ver;
-       phys_cpu = apicid_to_cpu_present(apicid);
-       physids_or(phys_cpu_present_map, phys_cpu_present_map,  
phys_cpu);
-
         if (num_processors >= NR_CPUS) {
                 printk(KERN_WARNING "WARNING: NR_CPUS limit of %i  
reached."
                         "  Processor ignored.\n", NR_CPUS);
@@ -195,6 +192,9 @@ static void __devinit MP_processor_info
                 return;
         }
+       phys_cpu = apicid_to_cpu_present(apicid);
+       physids_or(phys_cpu_present_map, phys_cpu_present_map,  
phys_cpu);
+
         cpu_set(num_processors, cpu_possible_map);
         num_processors++;


-- 
Mark Rustad, MRustad@gmail.com


