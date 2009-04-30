Return-Path: <linux-kernel-owner+w=401wt.eu-S1764534AbZD3QJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764534AbZD3QJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763554AbZD3QI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:08:59 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:55318 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbZD3QI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:08:58 -0400
Message-ID: <49F9CCD0.2080005@cosmosbay.com>
Date: Thu, 30 Apr 2009 18:07:44 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jesse.brandeburg@intel.com, netdev@vger.kernel.org, haoki@redhat.com,
       mchan@broadcom.com, davidel@xmailserver.org
Subject: [BUG] perf_counter: change cpu frequencies 
References: <49F71B63.8010503@cosmosbay.com> <alpine.DEB.1.10.0904281501300.13862@qirst.com> <49F76174.6060009@cosmosbay.com> <alpine.DEB.1.10.0904281612560.13862@qirst.com> <49F767FD.2040205@cosmosbay.com> <alpine.DEB.1.10.0904281629090.15947@qirst.com> <49F76F6C.80005@cosmosbay.com> <49F77108.7060509@cosmosbay.com> <20090429091130.GA27857@elte.hu> <49F9821C.5010802@cosmosbay.com> <20090430115736.GA24349@elte.hu> <49F9B0F0.40306@cosmosbay.com>
In-Reply-To: <49F9B0F0.40306@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 30 Apr 2009 18:07:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
 
> But if I use plain "perf stat -a sleep 10"
> it seems I get wrong values again (16 G cycles/sec) for all next perf sessions
> 

Well, I confirm all my cpus switched from 3GHz to 2GHz, after

"perf stat -a sleep 10"

(but "perf stat -e instructions -e cycles -a sleep 10" doesnt trigger this problem)

Nothing logged, and /proc/cpuinfo stills reports 3 GHz frequencies

# cat unit.c
main() {
  int i;
  for (i = 0 ; i < 10000000; i++)
        getppid();
}
# time ./unit

real    0m0.818s
user    0m0.289s
sys     0m0.529s
# perf stat -a sleep 10 2>/dev/null
# time ./unit

real    0m1.122s
user    0m0.482s
sys     0m0.640s

# tail -n 27 /proc/cpuinfo
processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz
stepping        : 6
cpu MHz         : 3000.102
cache size      : 6144 KB
physical id     : 1
siblings        : 1
core id         : 3
cpu cores       : 4
apicid          : 7
initial apicid  : 7
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm tpr_shadow vnmi flexpriority
bogomips        : 6000.01
clflush size    : 64
power management:

# grep CPU_FREQ .config
# CONFIG_CPU_FREQ is not set


perf_counter seems promising, but still... needs some bug hunting :)

Thank you

