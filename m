Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbZGaHGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbZGaHGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZGaHGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:06:40 -0400
Received: from mga10.intel.com ([192.55.52.92]:56889 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbZGaHGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:06:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,301,1246863600"; 
   d="scan'208";a="479547593"
Subject: Re: Dynamic configure max_cstate
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Corrado Zoccolo <czoccolo@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <4A726844.7040505@gmail.com>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de>
	 <1248748935.2560.669.camel@ymzhang>
	 <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com>
	 <1248771635.2560.682.camel@ymzhang>
	 <20090728101135.GA22358@rhlx01.hs-esslingen.de>
	 <4A726844.7040505@gmail.com>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 15:06:46 +0800
Message-Id: <1249024006.2560.735.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 21:43 -0600, Robert Hancock wrote:
> On 07/28/2009 04:11 AM, Andreas Mohr wrote:
> > Hi,
> >
> > On Tue, Jul 28, 2009 at 05:00:35PM +0800, Zhang, Yanmin wrote:
> >> I tried different clocksources. For exmaple, I could get a better (30%) result with
> >> hpet. With hpet, cpu utilization is about 5~8%. Function hpet_read uses too much cpu
> >> time. With tsc, cpu utilization is about 2~3%. I think more cpu utilization causes fewer
> >> C state transitions.
> >>
> >> With idle=poll, the result is about 10% better than the one of hpet. If using idle=poll,
> >> I didn't find result difference among different clocksources.
> >
> > IOW, this seems to clearly point to ACPI Cx causing it.
> >
> > Both Corrado and me have been thinking that one should try skipping all
> > bigger-latency ACPI Cx states whenever there's an ongoing I/O request where an
> > immediate reply interrupt is expected.
> >
> > I've been investigating this a bit, and interesting parts would perhaps include
> >    . kernel/pm_qos_params.c
> >    . drivers/cpuidle/governors/menu.c (which acts on the ACPI _cx state
> > structs as configured by drivers/acpi/processor_idle.c)
> >    . and e.g. the wait_for_completion_timeout() part in drivers/ata/libata-core.c
> >      (or other sources in case of other disk I/O mechanisms)
> >
> > One way to do some quick (and dirty!!) testing would be to set a flag
> > before calling wait_for_completion_timeout() and testing for this flag in
> > drivers/cpuidle/governors/menu.c and then skip deeper Cx states
> > conditionally.
> >
> > As a very quick test, I tried a
> > while :; do :; done
> > loop in shell and renicing shell to 19 (to keep my CPU out of ACPI idle),
> > but bonnie -s 100 results initially looked promising yet turned out to
> > be inconsistent. The real way to test this would be idle=poll.
> > My test system was Athlon XP with /proc/acpi/processor/CPU0/power
> > latencies of 000 and 100 (the maximum allowed value, BTW) for C1/C2.
> >
> > If the wait_for_completion_timeout() flag testing turns out to help,
> > then one might intend to use the pm_qos infrastructure to indicate
> > these conditions, however it might be too bloated for such a
> > purpose, a relatively simple (read: fast) boolean flag mechanism
> > could be better.
> >
> > Plus one could then create a helper function which figures out a
> > "pretty fast" Cx state (independent of specific latency times!).
> > But when introducing this mechanism, take care to not ignore the
> > requirements defined by pm_qos settings!
> >
> > Oh, and about the places which submit I/O requests where one would have to
> > flag this: are they in any way correlated with the scheduler I/O wait
> > value? Would the I/O wait mechanism be a place to more easily and centrally
> > indicate that we're waiting for a request to come back in "very soon"?
> > OTOH I/O requests may have vastly differing delay expectations,
> > thus specifically only short-term expected I/O replies should be flagged,
> > otherwise we're wasting lots of ACPI deep idle opportunities.
> 
> Did the results show a big difference in performance between maximum C2 
> and maximum C3? 
No big difference. I tried different max cstate by processor.max_cstate.
Mostly, processor.max_cstate=1 could get the similiar result like idle=poll.

> Thing with C3 is that it likely will have some 
> interference with bus-master DMA activity as the CPU has to wake up at 
> least partially before the SATA controller can complete DMA operations, 
> which will likely stall the controller for some period of time. There 
> would be an argument for avoiding going into deep C-states which can't 
> handle snooping while IO is in progress and DMA will shortly be occurring..

