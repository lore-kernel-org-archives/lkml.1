Return-Path: <linux-kernel-owner+w=401wt.eu-S1763979AbXIKSp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763979AbXIKSp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbXIKSpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:45:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36024 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063AbXIKSpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:45:15 -0400
Date: Tue, 11 Sep 2007 11:44:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070911114417.3f6e9e1b.akpm@linux-foundation.org>
In-Reply-To: <1189535883.5235.13.camel@chaos>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<200709111323.56030.rjw@sisk.pl>
	<20070911042228.1ef690e0.akpm@linux-foundation.org>
	<200709111409.13796.rjw@sisk.pl>
	<20070911112531.80bac380.akpm@linux-foundation.org>
	<1189535883.5235.13.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 20:38:03 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 2007-09-11 at 11:25 -0700, Andrew Morton wrote:
> > > It evidently assumes cpuidle to be present, which is not in the mainline.
> > 
> > Bear in mind that the cpuidle patch fixes resume-from-ram when cpuidle is
> > disabled in config.
> > 
> > > It seems to me that the total effect of this one and the hackpatch is that
> > > the C states are not handled any more.
> > 
> > hm.
> > 
> > dmesg without the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-bad.txt
> > dmesg with the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-good.txt
> > difference: http://userweb.kernel.org/~akpm/dmesg-diff.txt
> > 
> > there doesn't seem to be a lot of difference in the time handling, except
> > there are large changes in when things happen in the bootup sequence.
> 
> The question is whether the system goes into C2 with the patch applied.
> 
> Can you please provide the output of /proc/acpi/processor/CPU0/power for
> both the bad and the good one ?
> 

good:

sony:/home/akpm> cat /proc/acpi/processor/CPU0/power
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 8000 usec
states:
    C1:                  type[C1] promotion[--] demotion[--] latency[001] usage[00000000] duration[00000000000000000000]
    C2:                  type[C2] promotion[--] demotion[--] latency[001] usage[00000000] duration[00000000000000000000]

bad:

sony:/home/akpm> cat /proc/acpi/processor/CPU0/power
active state:            C2
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 8000 usec
states:
    C1:                  type[C1] promotion[C2] demotion[--] latency[001] usage[00000010] duration[00000000000000000000]
   *C2:                  type[C2] promotion[--] demotion[C1] latency[001] usage[00008316] duration[00000000000170717293]
