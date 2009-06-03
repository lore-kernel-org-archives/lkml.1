Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZFCSUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZFCSUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZFCSUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:20:40 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:16504 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752574AbZFCSUk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:20:40 -0400
X-SpamScore: -38
X-BigFish: VPS-38(zz146fK1432R98dR1805M179dR1442Jzz1202hzzz32i6bh17ch6di62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KKODLV-02-3HL-01
Date: Wed, 3 Jun 2009 20:20:23 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com, mingo@elte.hu,
       norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
Message-ID: <20090603182023.GA28083@aftab>
References: <20090528164720.0af5752b.akpm@linux-foundation.org> <20090529103329.GB23530@aftab> <20090529130115.a44efaee.akpm@linux-foundation.org> <20090530081954.GA21954@liondog.tnic> <20090530014007.3c1e22d5.akpm@linux-foundation.org> <4A218761.5080607@zytor.com> <20090601145326.GA28260@liondog.tnic> <4A2407D1.5050706@zytor.com> <20090601181208.GA30565@liondog.tnic> <4A24248E.3060005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A24248E.3060005@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 03 Jun 2009 18:20:25.0976 (UTC) FILETIME=[F7676780:01C9E477]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 11:57:18AM -0700, H. Peter Anvin wrote:
> Borislav Petkov wrote:
> > Actually, popcnt got added to gas in July 2006 so checking the gas
> > version should suffice, IMHO.
> 
> gas is part of binutils.
> 
> > Anyway, I proposed something similar before but Andrew suggested that we
> > should simply slap in the opcode so we don't need the Kbuild changes.
> > The advantage of the approach is that it works unconditionally on all
> > toolchains and introduces less code changes. Hmm...
> 
> That really sucks, though, in the long run.  I personally prefer to have
> the "right thing" -- which in this case is probably gcc intrinsics --
> and then a fallback that will gradually fall out of use.

Ok, here's a simple performance data measurement exercise:

I went and rerouted all the cpumask_weight calls in sched.c through a
noinline local definition:

static noinline unsigned int my_weight(const struct cpumask *mask)
{
       return cpumask_weight(mask);
}

so that I could be able to dynamically ftrace the invocations. Compiling
a kernel (make -j8) on a quad core Fam10h gave the following trace
(excerpt):

          <idle>-0     [000]   313.120141: my_weight <-scheduler_tick
          <idle>-0     [000]   313.120145: my_weight <-select_nohz_load_balancer
          <idle>-0     [000]   313.124133: my_weight <-scheduler_tick
          <idle>-0     [000]   313.124138: my_weight <-select_nohz_load_balancer
          <idle>-0     [000]   313.128124: my_weight <-scheduler_tick
          <idle>-0     [000]   313.128127: my_weight <-select_nohz_load_balancer
          <idle>-0     [000]   313.132116: my_weight <-scheduler_tick
          <idle>-0     [000]   313.132120: my_weight <-select_nohz_load_balancer
          <idle>-0     [000]   313.136109: my_weight <-scheduler_tick
          <idle>-0     [000]   313.136114: my_weight <-select_nohz_load_balancer
           <...>-3986  [002]   313.138868: my_weight <-sched_balance_self
           <...>-3986  [002]   313.138870: my_weight <-sched_balance_self
           <...>-4064  [003]   313.138942: my_weight <-sched_balance_self
           <...>-4064  [003]   313.138945: my_weight <-sched_balance_self
           <...>-4064  [000]   313.142034: my_weight <-sched_balance_self
           <...>-4064  [000]   313.142037: my_weight <-sched_balance_self
           <...>-4065  [001]   313.143509: my_weight <-sched_balance_self
           <...>-4065  [001]   313.143511: my_weight <-sched_balance_self
            make-3777  [000]   313.146553: my_weight <-sched_balance_self
            make-3777  [000]   313.146554: my_weight <-sched_balance_self
           <...>-4066  [001]   313.146614: my_weight <-sched_balance_self
           <...>-4066  [001]   313.146614: my_weight <-sched_balance_self
           <...>-4066  [003]   313.149516: my_weight <-sched_balance_self


and the following stats:

compile time: ~309.373623 secs
my_weight calls on _all_ cores: 54005
	(cpu0: 14262, cpu1: 14417, cpu2: 11654, cpu3: 13672)

leading to approx. 174.56 calls per second on _ALL_ cores combined. If,
hypothetically speaking, this is a representative workload and we forget
the ftrace overhead, it looks like there's no need to switch to the
hardware version of hweight since this'll bring a bunch of code changes
which simply wouldn't justify themselves wrt to performance improvement.
It is just not worth the effort.

Of course, I'm open for suggestions wrt to a better workload but from
looking at the code, the most frequent hweight call site seems to be
scheduler_tick which happens with HZ frequency and even this is by
several magnitudes not enough for a measurable performance improvement.

Hmm..?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

