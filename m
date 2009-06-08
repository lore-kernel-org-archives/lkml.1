Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZFHCFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZFHCFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 22:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZFHCFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 22:05:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:30760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZFHCFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 22:05:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,322,1241420400"; 
   d="scan'208";a="522509070"
Subject: Re: [PATCH -v4] x86: MCE: Re-implement MCE log ring buffer as
 per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A2C66BF.5000401@jp.fujitsu.com>
References: <1244085090.8361.360.camel@yhuang-dev.sh.intel.com>
	 <4A28C2E2.4090309@jp.fujitsu.com>
	 <1244189284.8361.514.camel@yhuang-dev.sh.intel.com>
	 <4A28D738.8010202@jp.fujitsu.com>
	 <1244191174.8361.517.camel@yhuang-dev.sh.intel.com>
	 <4A2C66BF.5000401@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 10:05:21 +0800
Message-Id: <1244426721.8361.569.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 09:17 +0800, Hidetoshi Seto wrote:
> Huang Ying wrote:
> > On Fri, 2009-06-05 at 16:28 +0800, Hidetoshi Seto wrote:
> >> Huang Ying wrote:
> >>> On Fri, 2009-06-05 at 15:01 +0800, Hidetoshi Seto wrote:
> >>>> Huang Ying wrote:
> >>>>>  struct mce_log {
> >>>>> -	char signature[12]; /* "MACHINECHECK" */
> >>>>> +	char signature[12]; /* "MACHINECHEC2" */
> >>>>>  	unsigned len;	    /* = MCE_LOG_LEN */
> >>>>> -	unsigned next;
> >>>>>  	unsigned flags;
> >>>>>  	unsigned pad0;
> >>>>> -	struct mce entry[MCE_LOG_LEN];
> >>>>> +	struct mce_log_cpu *mcelog_cpus;
> >>>>>  };
> >>>> What is this *mcelog_cpus to be used for?
> >>>> It seems it will point one of per-CPU buffers (maybe cpu#0's buffer)
> >>>> if I have read the following mce_log_init() correctly.
> >>> It is mainly used by something like kdump, which can search
> >>> "MACHINECHEC2", and analyze mce_log. mcelog_cpus can help kdump find the
> >>> real mcelog storage.
> >> Hum, but it help tools only to find one of buffers, not to find all.
> >>
> >> I think it would be better help for tools if we have another signature
> >> on struct mce_log_cpu, e.g.: 
> >>
> >>  +struct mce_log_cpu {
> >> + 	char signature[**];	/* "MCE_LOG_CPU_VER_1" or so */
> >> +	__u32 cpuid;		/* cpuid or extcpu, same as struct mce */
> >>  +	int head;
> >>  +	int tail;
> >>  +	unsigned long flags;
> >>  +	struct mce entry[MCE_LOG_LEN];
> >>  +};
> >>
> >> How about this?
> > 
> > +	mcelog.mcelog_cpus = &per_cpu_var(mce_log_cpus);
> > 
> > So mcelog.mcelog_cpus are pointed to the buffers of all CPUs, not just
> > that of one CPU. You can find them by analyzing PER cpu data structure.
> 
> I thought that the signature is used to find the structure without such
> analyzing.  If a tool can analyze PER cpu data, then it likely know
> where the mce_log_cpu is, so mcelog.mcelog_cpus will not be required.
> 
> #define per_cpu_var(var) per_cpu__##var
> 
> #define per_cpu(var, cpu) \
>         (*SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
> 
> OK, I have mistook per_cpu_var() for per_cpu(). 
> Then mcelog.mcelog_cpus does not point any of the buffers, but tells where
> the buffer is locating in each of PER cpu data.
> Tools have to get per_cpu_offset(cpu) to know where the PER cpu data
> allocated.  According to pcpu_alloc_bootmem(), it might consider NUMA.
> Anyway It will take a bit more effort.
> 
> So still I think the mcelog.mcelog_cpus is mostly pointless.

Emm, it seem hard to analyze mce_log_cpu from per_cpu_var(mce_log_cpus),
how about following method:

struct mce_log {
    char signature[12];
    ...
    struct mce_log_cpu *mcelog_cpus[];
};

void mcelog_init(void)
{
    int cpu;
    mcelog.mcelog_cpus = kmalloc(sizeof(void *) * num_possible_cpus();
    for_each_possible_cpu(cpu)
	mcelog.mcelog_cpus[cpu] = &per_cpu(mce_log_cpus, cpu);
}

Best Regards,
Huang Ying


