Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0CLPmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 10:42:16 -0500
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:46164 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab0CLPmO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 10:42:14 -0500
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
From: Robert =?ISO-8859-1?Q?Sch=F6ne?= <robert.schoene@tu-dresden.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
In-Reply-To: <4B9A552D.6080103@linux.intel.com>
References: <1268399863.3407.15.camel@localhost>
	 <4B9A552D.6080103@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 16:41:46 +0100
Message-ID: <1268408506.3407.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 12.03.2010, 06:52 -0800 schrieb Arjan van de Ven:
> On 3/12/2010 5:17, Robert Schöne wrote:
> > This patch fixes the following behaviour:
> > Currently, the power_frequency event is reported for the cpu (core) which initiated the frequency change.
> > It should be reported for the cpu that actually changes its frequency.
> >
> > Example: when using
> >   taskset -c 0 echo<new_frequency>  >  /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
> > cpu 0 is traced, instead of cpu 1
> >
> > Signed of by Robert Schoene<robert.schoene@tu-dresden.de>
> >
> >
> > diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > index 1b1920f..0a47f10 100644
> > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > @@ -174,6 +174,7 @@ static void do_drv_write(void *_cmd)
> >
> >          switch (cmd->type) {
> >          case SYSTEM_INTEL_MSR_CAPABLE:
> > +               trace_power_frequency(POWER_PSTATE, cmd->val);
> >                  rdmsr(cmd->addr.msr.reg, lo, hi);
> >                  lo = (lo&  ~INTEL_MSR_RANGE) | (cmd->val&  INTEL_MSR_RANGE);
> >                  wrmsr(cmd->addr.msr.reg, lo, hi);
> > @@ -363,7 +364,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
> >                  }
> >          }
> >
> > -       trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
> >
> >          switch (data->cpu_feature) {
> >          case SYSTEM_INTEL_MSR_CAPABLE:
> >
> >
> 
> are you sure this is right?
> it's moving something from outside a switch statement to inside only one prong of a switch statement...

I'm pretty sure, since I'm moving it from function acpi_cpufreq_target(...) to do_drv_write(...)

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Robert Schoene
Technische Universitaet Dresden
Zentrum fuer Informationsdienste und Hochleistungsrechnen
01062 Dresden

Tel.: (0351) 463-42483, Fax: (0351) 463-37773
E-Mail: Robert.Schoene@tu-dresden.de

