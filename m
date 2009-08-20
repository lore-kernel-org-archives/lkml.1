Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZHTNNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZHTNNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZHTNNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:13:04 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:10378 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754222AbZHTNNC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:13:02 -0400
X-SpamScore: 14
X-BigFish: VPS14(zz14c3Lzz1202hzz3198u327alz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KOOFD8-01-06H-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:12:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/15] sched: Fix scheduling for multi-node processors
Message-ID: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:12:44.0391 (UTC) FILETIME=[E7A99770:01CA2197]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Subsequent patches adapt scheduling code to support multi-node processors.

In short, the required changes need to fulfill two requirements:

(1) The set of CPUs in a NUMA node does not necessarily span CPUs of entire
    sockets anymore. (Current code assumes that.)

(2) The additional hierarchy in the CPU topology (i.e. internal node) might
    be useful when doing load balancing when power saving matters.

Patches 1-7 (add basic) support fo a new scheduling domain (called MN for multi-node)
Patch 8 adds a knob to control power_savings balancing for MN domain
Patches 9, 10 add the snippets to do the power_savings balancing for MN domain
Patch 11 adds a way to pass unlimited __cpu_power information to upper domain levels
Patch 12 allows NODE domain to be parent of MC domain (and thus child of MN domain)
Patch 13 detects whether NODE domain is parent of MC instead of CPU domain
Patch 14 fixes perf policy scheduling when NODE domain is parent of MC domain
Patch 15 fixes cpu_coregroup_mask to use mask of core_siblings instead of node_siblings
         (I admit that this change should better be added to my topology patches.)

To apply the patches you need to use tip/master as of today
(containing the sched cleanup patches) plus the 8 topology patches
that I have sent recently. (See
http://marc.info/?l=linux-kernel&m=124964980507887)

Full power saving scheduling options on multi-node processors are only
available with CONFIG_SCHED_MN=y. See example and example output
below.


Regards,

Andreas

PS: I send this as RFC. It seems to be pretty stable, though. But I
    want to do some more testing before I'd ask to apply this to
    tip-tree and I also want to check the performance impact of the
    new sched domain level.

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632
--------------------------------------------------------------------------------
Examples:
=========
(1) To demonstrate power_savings balancing I provide top output when system
    is partially loaded.

 (Note: sched_mc_power_savings=sched_mn_power_savings=0)

 # for i in `seq 1 6`; do nbench& done

 top - 15:41:08 up 7 min,  3 users,  load average: 2.49, 0.64, 0.21
 Tasks: 267 total,   7 running, 260 sleeping,   0 stopped,   0 zombie
 Cpu0  : 49.7%us,  0.0%sy,  0.0%ni, 50.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu5  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu6  : 50.2%us,  0.0%sy,  0.0%ni, 49.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu8  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu9  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu10 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu11 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu12 : 48.8%us,  0.0%sy,  0.0%ni, 51.2%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu13 :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu14 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu15 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu16 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu17 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu18 : 50.8%us,  0.0%sy,  0.0%ni, 49.2%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu19 :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu20 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu21 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu22 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu23 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

 # echo 1  >> /sys/devices/system/cpu/sched_mn_power_savings

 top - 15:42:27 up 8 min,  3 users,  load average: 3.91, 1.49, 0.54
 Tasks: 267 total,   7 running, 260 sleeping,   0 stopped,   0 zombie
 Cpu0  :  0.0%us,  0.3%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu1  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu2  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu5  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu6  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu7  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu8  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu9  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu10 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu11 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu12 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu13 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu14 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu15 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu16 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu17 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu18 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu19 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu20 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu21 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu22 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu23 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

 # echo 2  >> /sys/devices/system/cpu/sched_mc_power_savings 

 top - 15:43:09 up 9 min,  3 users,  load average: 4.93, 2.06, 0.77
 Tasks: 267 total,   7 running, 260 sleeping,   0 stopped,   0 zombie
 Cpu0  : 99.0%us,  0.0%sy,  0.0%ni,  1.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu1  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu2  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu3  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu4  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu5  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu6  :  0.7%us,  0.0%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu8  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu9  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu10 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu11 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu12 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu13 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu14 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu15 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu16 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu17 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu18 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu19 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu20 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu21 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu22 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu23 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

 # echo 0  >> /sys/devices/system/cpu/sched_mc_power_savings 
 # echo 0  >> /sys/devices/system/cpu/sched_mn_power_savings 

 top - 15:44:22 up 10 min,  3 users,  load average: 5.38, 2.86, 1.15
 Tasks: 267 total,   7 running, 260 sleeping,   0 stopped,   0 zombie
 Cpu0  : 49.2%us,  0.3%sy,  0.0%ni, 50.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu5  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu6  : 50.8%us,  0.0%sy,  0.0%ni, 49.2%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu8  :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu9  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu10 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu11 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu12 : 49.2%us,  0.0%sy,  0.0%ni, 50.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu13 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu14 :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu15 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu16 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu17 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu18 : 50.7%us,  0.0%sy,  0.0%ni, 49.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu19 :100.0%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu20 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu21 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu22 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
 Cpu23 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

--------------------------------------------------------------------------------
(2) To illustrate the new domain hierarchy I give examples for sched
    domains and groups of CPU 23 of my test system:

CONFIG_SCHED_MN=n
sched_mc_power_savings=0

 CPU23 attaching sched-domain:
  domain 0: span 18-23 level MC
   groups: 23 18 19 20 21 22
   domain 1: span 18-23 level NODE
    groups: 18-23 (__cpu_power = 6144)
    domain 2: span 0-23 level CPU
     groups: 18-23 0-5 6-11 12-17

CONFIG_SCHED_MN=n
sched_mc_power_savings=2

 CPU23 attaching sched-domain:
  domain 0: span 18-23 level MC
   groups: 23 18 19 20 21 22
   domain 1: span 18-23 level NODE
    groups: 18-23 (__cpu_power = 6144)
    domain 2: span 0-23 level CPU
     groups: 18-23 (__cpu_power = 6144) 0-5 (__cpu_power = 6144) 6-11 (__cpu_power = 6144) 12-17 (__cpu_power = 6144)

CONFIG_SCHED_MN=y, CONFIG_NUMA=y
sched_mc_power_savings=0, sched_mn_power_savings=0

 CPU23 attaching sched-domain:
  domain 0: span 18-23 level MC
   groups: 23 18 19 20 21 22
   domain 1: span 18-23 level NODE
    groups: 18-23 (__cpu_power = 6144)
    domain 2: span 12-23 level MN
     groups: 18-23 12-17
     domain 3: span 0-23 level CPU
      groups: 12-23 0-11

CONFIG_SCHED_MN=y, CONFIG_NUMA=y
sched_mc_power_savings=0, sched_mn_power_savings=1

 CPU23 attaching sched-domain:
  domain 0: span 18-23 level MC
   groups: 23 18 19 20 21 22
   domain 1: span 18-23 level NODE
    groups: 18-23 (__cpu_power = 6144)
    domain 2: span 12-23 level MN
     groups: 18-23 12-17
     domain 3: span 0-23 level CPU
      groups: 12-23 (__cpu_power = 12288) 0-11 (__cpu_power = 12288)

CONFIG_SCHED_MN=y, CONFIG_NUMA=y
sched_mc_power_savings=2, sched_mn_power_savings=0

 CPU23 attaching sched-domain:
  domain 0: span 18-23 level MC
   groups: 23 18 19 20 21 22
   domain 1: span 18-23 level NODE
    groups: 18-23 (__cpu_power = 6144)
    domain 2: span 12-23 level MN
     groups: 18-23 (__cpu_power = 6144) 12-17 (__cpu_power = 6144)
     domain 3: span 0-23 level CPU
      groups: 12-23 (__cpu_power = 12288) 0-11 (__cpu_power = 12288)

CONFIG_SCHED_MN=y, CONFIG_NUMA=y, CONFIG_ACPI_NUMA=n
(and CONFIG_SCHED_MN=y, CONFIG_NUMA=n)
sched_mc_power_savings=0, sched_mn_power_savings=0

 CPU23 attaching sched-domain:
  domain 0: span 18-23 level MC
   groups: 23 18 19 20 21 22
   domain 1: span 12-23 level MN
    groups: 18-23 12-17
    domain 2: span 0-23 level CPU
     groups: 12-23 0-11

CONFIG_SCHED_MN=y, CONFIG_NUMA=y, CONFIG_ACPI_NUMA=n
(and CONFIG_SCHED_MN=y, CONFIG_NUMA=n)
sched_mc_power_savings=0, sched_mn_power_savings=1

 CPU23 attaching sched-domain:
  domain 0: span 18-23 level MC
   groups: 23 18 19 20 21 22
   domain 1: span 12-23 level MN
    groups: 18-23 12-17
    domain 2: span 0-23 level CPU
     groups: 12-23 (__cpu_power = 12288) 0-11 (__cpu_power = 12288)

CONFIG_SCHED_MN=y, CONFIG_NUMA=y, CONFIG_ACPI_NUMA=n
(and CONFIG_SCHED_MN=y, CONFIG_NUMA=n)
sched_mc_power_savings=2, sched_mn_power_savings=0

 CPU23 attaching sched-domain:
  domain 0: span 18-23 level MC
   groups: 23 18 19 20 21 22
   domain 1: span 12-23 level MN
    groups: 18-23 (__cpu_power = 6144) 12-17 (__cpu_power = 6144)
    domain 2: span 0-23 level CPU
     groups: 12-23 (__cpu_power = 12288) 0-11 (__cpu_power = 12288)

--------------------------------------------------------------------------------
(3) Further information -- just for completeness.

With NUMA support and SRAT detection the kernel uses following NUMA
information:

  # numactl --hardware
 available: 4 nodes (0-3)
 node 0 cpus: 0 1 2 3 4 5
 node 0 size: 2047 MB
 node 0 free: 1761 MB
 node 1 cpus: 6 7 8 9 10 11
 node 1 size: 2046 MB
 node 1 free: 1990 MB
 node 2 cpus: 18 19 20 21 22 23
 node 2 size: 2048 MB
 node 2 free: 2004 MB
 node 3 cpus: 12 13 14 15 16 17
 node 3 size: 2048 MB
 node 3 free: 2002 MB
 node distances:
 node   0   1   2   3 
   0:  10  16  16  16 
   1:  16  10  16  16 
   2:  16  16  10  16 
   3:  16  16  16  10 

Without ACPI SRAT support (e.g. CONFIG_ACPI_NUMA=n) the NUMA
information is:

 # numactl  --hardware
 available: 1 nodes (0-0)
 node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
 node 0 size: 8189 MB
 node 0 free: 7900 MB
 node distances:
 node   0 
   0:  10

--------------------------------------------------------------------------------
FINI


