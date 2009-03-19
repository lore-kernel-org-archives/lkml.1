Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZCSGDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZCSGDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZCSGDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:03:43 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:47746 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZCSGDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:03:42 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 02:03:42 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Wub+mnqX65vGoawGIX5PzseKYZOk/R2gL83didO9mqtZSSUIbZd1+LVkW5mWw7c2n8
         Zda8z+SrEeggyIR9v86Llj/RQnoCK26hpPKINC2HalTpCu3fRdE2wWsX1KtlrCZp87g3
         AK/HYxeYEDhTdhlU1WhpfQtSQo2vtVxvOkGtY=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: cpufreq@vger.kernel.org
Subject: 2.6.29-rcX: wierd iteractions with CPUFREQ
Date: Wed, 18 Mar 2009 22:57:21 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, davej@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903182257.21691.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Something weird is happening with 2.6.29 - once my laptop starts heating
up and fans come up it locks at 800MHz, but there are no valid thermal
events. If I enable cpufreq debug I am getting the following (dump stack
was added by myself to see where __cpufreq_set_policy is being called from):

CPU0: setting new policy for CPU 0: 800000 - 2201000 kHz                                      
Pid: 220, comm: kacpi_notify Not tainted 2.6.29-rc8 #110
Call Trace:                                                                                   
 [<ffffffff812fd35e>] __cpufreq_set_policy+0x3a/0x210                                         
 [<ffffffff812fed87>] cpufreq_update_policy+0x112/0x134                                       
 [<ffffffff812feda9>] ? handle_update+0x0/0x38                                                
 [<ffffffff8121bde7>] acpi_processor_ppc_has_changed+0xc8/0xd1                                
 [<ffffffff8120f69d>] ? acpi_bus_get_device+0x2a/0x3e                                         
 [<ffffffff81218298>] acpi_processor_notify+0x64/0x10d                                        
 [<ffffffff814505bf>] ? _spin_unlock_irq+0x30/0x62                                            
 [<ffffffff811fae58>] acpi_ev_notify_dispatch+0x64/0x70                                       
 [<ffffffff811f46d2>] acpi_os_execute_deferred+0x31/0x3e                                      
 [<ffffffff8104e301>] run_workqueue+0x108/0x21b                                               
 [<ffffffff8104e2af>] ? run_workqueue+0xb6/0x21b                                              
 [<ffffffff811f46a1>] ? acpi_os_execute_deferred+0x0/0x3e                                     
 [<ffffffff8104e4f9>] worker_thread+0xe5/0xf6                                                 
 [<ffffffff81052599>] ? autoremove_wake_function+0x0/0x3d                                     
 [<ffffffff8104e414>] ? worker_thread+0x0/0xf6                                                
 [<ffffffff810521b8>] kthread+0x4e/0x7b                                                       
 [<ffffffff8100cb7a>] child_rip+0xa/0x20                                                      
 [<ffffffff81035d11>] ? finish_task_switch+0x0/0xca                                           
 [<ffffffff8100c540>] ? restore_args+0x0/0x30                                                 
 [<ffffffff8105216a>] ? kthread+0x0/0x7b                                                      
 [<ffffffff8100cb70>] ? child_rip+0x0/0x20                                                    
freq-table: request for verification of policy (800000 - 2201000 kHz) for cpu 0               
freq-table: verification lead to (800000 - 2201000 kHz) for cpu 0                             
freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0                
freq-table: verification lead to (800000 - 800000 kHz) for cpu 0                              
cpufreq-core: new min and max freqs are 800000 - 800000 kHz                                   
cpufreq-core: governor: change or update limits                                               
cpufreq-core: __cpufreq_governor for CPU 0, event 3                                           
cpufreq-core: target for CPU 0: 800000 kHz, relation 1                                        
freq-table: request for target 800000 kHz (relation: 1) for cpu 0
freq-table: target is 4 (800000 kHz, 4)
cpufreq-core: notification 0 of frequency transition to 800000 kHz
cpufreq-core: notification 1 of frequency transition to 800000 kHz

As you can see for some reason the 2nd validation clams the frequency to 800
(although the first one done immediately before says that 2.2GHz is fine)
and the system slows to a crawl.

-- 
Dmitry
