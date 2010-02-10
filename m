Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0BJPXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:23:48 -0500
Received: from borg.medozas.de ([188.40.89.202]:35208 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0BJPXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:23:47 -0500
Date: Wed, 10 Feb 2010 16:23:33 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: jens.axboe@oracle.com
Subject: Re: kswapd continuously active
In-Reply-To: <20100208140837.GN1025@kernel.dk>
Message-ID: <alpine.LSU.2.01.1002101619080.15416@obet.zrqbmnf.qr>
References: <20100208140837.GN1025@kernel.dk>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


>On Mon, Feb 08 2010, Jan Engelhardt wrote:
>
>> Could it be that there is something synchronize_rcu()-like in the
>> game that-- as a result of how RCU works-- just takes ages with 24
>> VCPUs?
>
>The only synchronize_rcu() involved in the writeback code happens when 
>a bdi exits, so you should not hit that. It'll do call_rcu() for work 
>completions, but 1) you should not see a lot of work entries, and 2) 
>lots of other kernel code will do that, too.
>
>Are you seeing a lot of CPU usage? What does eg perf top -a say?

top - 16:19:42 up  1:02,  3 users,  load average: 3.05, 3.87, 3.51
Cpu(s):  0.0%us,  0.2%sy,  0.0%ni, 98.2%id,  1.6%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   8063800k total,  6676472k used,  1387328k free,   767040k buffers
Swap:        0k total,        0k used,        0k free,  4775464k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND           
26354 root      20   0  3472 1704 1184 R    4  0.0   0:00.33 top                
26198 jengelh   20   0  2864 1368 1152 S    4  0.0   0:03.72 watch              
  574 root      20   0     0    0    0 D    3  0.0   0:52.20 jbd2/sda6-8        
  312 root      20   0     0    0    0 R    1  0.0   0:29.29 flush-8:0          
    1 root      20   0  2408  936  808 S    0  0.0   0:01.13 init               


When it comes down hard, i.e. when there is always new data arriving
while sys_sync is working, the loadavg is usually in the range of
1.0*CPUs up to 2.0*CPUs. The top dump shown here is after quiescing
writers.

>And what setup is this, I didn't realize you were running a virtualized
>setup?

It is real; but I usually use the term VCPU because this iron has
1 CPU with 6 cores with 24 threads, not 24 CPU (packages).

