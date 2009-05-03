Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZECH0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZECH0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 03:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZECH01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 03:26:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35946 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbZECH00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 03:26:26 -0400
Date: Sun, 3 May 2009 09:25:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>
Cc: Christoph Lameter <cl@linux.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jesse.brandeburg@intel.com, netdev@vger.kernel.org, haoki@redhat.com,
       mchan@broadcom.com, davidel@xmailserver.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] perf_counter: change cpu frequencies
Message-ID: <20090503072535.GA9455@elte.hu>
References: <49F767FD.2040205@cosmosbay.com> <alpine.DEB.1.10.0904281629090.15947@qirst.com> <49F76F6C.80005@cosmosbay.com> <49F77108.7060509@cosmosbay.com> <20090429091130.GA27857@elte.hu> <49F9821C.5010802@cosmosbay.com> <20090430115736.GA24349@elte.hu> <49F9B0F0.40306@cosmosbay.com> <49F9CCD0.2080005@cosmosbay.com> <49FD347F.6030306@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49FD347F.6030306@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Eric Dumazet a écrit :
> > Eric Dumazet a écrit :
> >  
> >> But if I use plain "perf stat -a sleep 10"
> >> it seems I get wrong values again (16 G cycles/sec) for all next perf sessions
> >>
> > 
> > Well, I confirm all my cpus switched from 3GHz to 2GHz, after
> > 
> > "perf stat -a sleep 10"
> > 
> > (but "perf stat -e instructions -e cycles -a sleep 10" doesnt trigger this problem)
> > 
> > Nothing logged, and /proc/cpuinfo stills reports 3 GHz frequencies
> > 
> > # cat unit.c
> > main() {
> >   int i;
> >   for (i = 0 ; i < 10000000; i++)
> >         getppid();
> > }
> > # time ./unit
> > 
> > real    0m0.818s
> > user    0m0.289s
> > sys     0m0.529s
> > # perf stat -a sleep 10 2>/dev/null
> > # time ./unit
> > 
> > real    0m1.122s
> > user    0m0.482s
> > sys     0m0.640s
> > 
> > # tail -n 27 /proc/cpuinfo
> > processor       : 7
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 23
> > model name      : Intel(R) Xeon(R) CPU           E5450  @ 3.00GHz
> > stepping        : 6
> > cpu MHz         : 3000.102
> > cache size      : 6144 KB
> > physical id     : 1
> > siblings        : 1
> > core id         : 3
> > cpu cores       : 4
> > apicid          : 7
> > initial apicid  : 7
> > fdiv_bug        : no
> > hlt_bug         : no
> > f00f_bug        : no
> > coma_bug        : no
> > fpu             : yes
> > fpu_exception   : yes
> > cpuid level     : 10
> > wp              : yes
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 lahf_lm tpr_shadow vnmi flexpriority
> > bogomips        : 6000.01
> > clflush size    : 64
> > power management:
> > 
> > # grep CPU_FREQ .config
> > # CONFIG_CPU_FREQ is not set
> > 
> > 
> > perf_counter seems promising, but still... needs some bug hunting :)
> > 
> 
> Update :
> 
> Mike Galbraith suggested me to try various things, and finally, I discovered
> this frequency change was probably a BIOS problem on my HP BL460c G1
> 
> System Options -> Power regulator for Proliant
> 
> [*] HP Dynamic Power Savings Mode
> [ ] HP Static Low Power Mode
> [ ] HP Static High Performance Mode
> [ ] OS Control Mode
> 
> 
> I switched it to 'OS Control Mode'
> 
> Then acpi-cpufreq could load, and no more frequencies changes on a "perf -a sleep 10" 
> session, using or not cpufreq.
> (Supported cpufreq speeds on these cpus : 1999 & 2999 MHz)
> 
> So it was a BIOS issue

ah! That makes quite a bit of sense. The BIOS interfering with an OS 
feature ... Was that the default setting in the BIOS?

> # perf stat -a sleep 10
> 
>  Performance counter stats for 'sleep':
> 
>    80005.418223  task clock ticks     (msecs)
>           80266  context switches     (events)
>               3  CPU migrations       (events)
>             486  pagefaults           (events)
>    240013851624  CPU cycles           (events) << good >>
>    239076501419  instructions         (events)
>          679464  cache references     (events)
>   <not counted>  cache misses
> 
>  Wall-clock time elapsed: 10000.468808 msecs

That looks perfect now.

It would also be really nice to have a sysrq-p dump of your PMU 
state before you've done any profiling. Is there any trace of the 
BIOS meddling with them, that we could detect (and warn about) 
during bootup?

Thanks,

	Ingo
