Return-Path: <linux-kernel-owner+w=401wt.eu-S1759822AbZLOK3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822AbZLOK3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759624AbZLOK3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:29:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264AbZLOK3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:29:13 -0500
Message-ID: <4B2764F5.9000206@redhat.com>
Date: Tue, 15 Dec 2009 12:29:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: Poor KVM guest performance on an HP rack server
References: <4B243B2B.806@pardus.org.tr> <4B24BE52.6060703@redhat.com> <4B24D1C2.9010807@pardus.org.tr> <4B24D6DD.8060509@pardus.org.tr>
In-Reply-To: <4B24D6DD.8060509@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2009 01:58 PM, Ozan Çağlayan wrote:
>
> KVM related messages on the host server:
>
> ~ # dmesg |grep kvm
> [ 3649.058945] loaded kvm module (kvm-kmod-2.6.32)
> [ 3683.736737] kvm: emulating exchange as write (It's interesting, what does it mean?)
>    

An exchange instruction (cmpxchg, likely) was emulated using a write.  
Since it happens under lock, this is safe.

> First of all if there are some specific outputs that will reveal the
> IO/CPU boundness of the workload, I'd like to give them too. I'm not
> much familiar with diagnostic/analysis tools..
>
>  From host's POV:
> ----------------
>
> Guest is idle:
>
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 26117 root      20   0 2153m 175m 1356 S    5  0.5   0:33.57 qemu-kvm
>
> Guest is configuring CUPS:
>
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 26117 root      20   0 2129m 180m 1356 S  143  0.6   0:44.34 qemu-kvm (peak at 140,150~ %CPU)
>
>    

Definitely looks cpu bound.

> load average reached 0.91 at the end of the configuration.
>
> SMP view of top command shows that only Cpu2 and Cpu9 are involved,
> other ones are zeroed (maybe coherent with -smp 2, don't have much idea):
>
> Cpu2  : 28.4%us, 31.4%sy,  0.0%ni, 40.2%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
> Cpu9  : 27.7%us, 26.7%sy,  0.0%ni, 45.5%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
>    

Can you provide kvm_stat output while this happens?

> Configuring CUPS:
>
>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 19258 root      20   0  3396 1656 1192 R   18  0.1   0:05.20 configure (Saw maximum 22 %CPU)
>    

Do you have any idea what this configure does?  If it is a very 
fork/exec intensive workload, you can expect some slowdown on older 
processors.

> The following is the highest load average instant during configuration:
>
> top - 11:35:32 up 33 min,  3 users,  load average: 0.56, 0.25, 0.15
> Tasks:  99 total,   4 running,  95 sleeping,   0 stopped,   0 zombie
> Cpu0  :  4.7%us, 68.3%sy,  0.0%ni, 27.0%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
> Cpu1  :  4.3%us, 66.3%sy,  0.0%ni, 29.3%id,  0.0%wa,  0.0%hi,  0.0%si, 0.0%st
> Mem:   2061660k total,   137564k used,  1924096k free,    58672k buffers
> Swap:   307192k total,        0k used,   307192k free,    49240k cached
>
> vmstat -n 1:
> ------------
>
> (context switches and interrupts are much more higher during
> configuration than the idle state)
>    

>   1  0      0 1924788  58592  49176    0    0     0     0 1413  401  2 33 65  0  0  (./configure)
>   1  0      0 1924092  58592  49072    0    0     0     4 2210  599  5 57 38  0  0
>   1  0      0 1924544  58592  49080    0    0     0     0 2131  349  5 51 45  0  0
>    

That's consistent with a fork/exec load, though the numbers are not that 
high.

-- 
error compiling committee.c: too many arguments to function

