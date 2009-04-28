Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZD1IeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZD1IeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZD1Ids
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:33:48 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:55771 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbZD1Idp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:33:45 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC PATCH v1 0/3] Saving power by cpu evacuation using
 sched_mc=n
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
In-Reply-To: <20090427142044.GA7178@dirshya.in.ibm.com>
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
	 <1240826954.8216.8.camel@twins>  <20090427142044.GA7178@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 10:33:38 +0200
Message-Id: <1240907618.7620.86.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-27 at 19:50 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-04-27 12:09:14]:

> > The whole thing seems to be targeted at thermal management, not power
> > saving. Therefore using the power saving stuff is backwards.
> 
> The framework is useful for power savings and thermal management.
> Actually we can generalise this a framework to throttle cores.

To what purpose?

> Power savings need only core evacuation, kernel can decide the most
> optimum cores to evacuate for best power savings.  While in thermal
> management we will additional need a 'vector' parameter to direct the
> load to different parts of the system and level the heat generated.

Power saving should not generate idle, it should just accumulate idle in
the most favourable way.

Thermal management must generate idle to avoid hardware breakdown etc.
Does it really need more than a single max_thermal_capacity knob? That
is, does it really matter which die in the machine generates the heat?

If so, why?
 
> > Provide a knob that provides max_thermal_capacity, and schedule
> > accordingly.
> 
> Yes, we can pick a generic name and use this as a function of total
> system capacity to indicate number of cores to evacuate.

No, it should be in a thermal unit, not nr of cores.

> > FWIW I utterly hate these force idle things because they cause the
> > scheduler to become non-work conserving, but I have to concede that
> > software will likely be more suited to handle the thermal overload issue
> > than hardware will ever be -- so for that use case I'm willing to go
> > along.
> 
> Yes, I agree with your opinion.  However if we can come up with
> a clean framework to take cores out of scheduler's view, then the work
> conserving nature of the scheduler can be preserved on the sub-set of
> cores.  Inserting idle states is more intrusive than leaving out full
> cores.

Not really, when you consider the machine (or load-balance domain)
taking out a few cores it still non-work preserving as you take away
capacity.

I'm against taking out capacity for anything other than thermal
management -- full stop.

> > Also, the user interface should be that single thermal capacity knob,
> > more fine grained control is undesired.
> 
> For power savings, a single evacuation knob will do.  While for
> thermal we will need additional parameters to choose the right cores
> to evacuate.  Some sort of directional/vector parameter.

Why? are machines that non-uniform in cooling capacity that it really
matters which core generates the heat? Sounds like badly designed
hardware to me.

I would expect it to only be the total head generated/power taken from
the rack unit.

> > Also, before you continue, expand on the interaction with realtime
> > processes.
> 
> Sure.  We will run into complications with respect to realtime
> scheduling.  You had earlier pointed out a need for variable cpu power
> to achieve fairness for non-realtime tasks in the presence of realtime
> tasks.  We should re-visit that idea.

There is that, another point is load generated by SCHED_OTHER tasks
pushing the machine in thermal overload should not shut down the
capacity needed for the real-time tasks.


