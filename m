Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbZFVGJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbZFVGJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbZFVGJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:09:05 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:51576 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZFVGJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:09:04 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@in.ibm.com>, Rusty Russel <rusty@rustcorp.com.au>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Subject: Re: [RFD PATCH 0/4] cpu: Bulk CPU Hotplug support.
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
 <20090615232318.74b099a6.akpm@linux-foundation.org>
 <20090616080715.GB7961@dirshya.in.ibm.com>
 <1245223977.13761.21576.camel@twins>
 <20090617143804.GA6767@linux.vnet.ibm.com> <20090617150700.GB20345@elte.hu>
 <1245270387.6670.19.camel@laptop> <20090620153503.GA11701@elte.hu>
From: Nathan Lynch <ntl@pobox.com>
Date: Mon, 22 Jun 2009 01:08:51 -0500
In-Reply-To: <20090620153503.GA11701@elte.hu> (Ingo Molnar's message of
 "Sat\, 20 Jun 2009 17\:35\:03 +0200")
Message-ID: <m2eitcrea4.fsf@pobox.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 30ED305C-5EF3-11DE-AEC9-B5D1A546830D-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> On Wed, 2009-06-17 at 17:07 +0200, Ingo Molnar wrote:
>> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>> > 
>> > > On Wed, Jun 17, 2009 at 09:32:57AM +0200, Peter Zijlstra wrote:
>> > > > On Tue, 2009-06-16 at 13:37 +0530, Vaidyanathan Srinivasan wrote:
>> > > > > * Andrew Morton <akpm@linux-foundation.org> [2009-06-15 23:23:18]:
>> > > > > 
>> > > > > > On Tue, 16 Jun 2009 11:08:39 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:
>> > > > > > 
>> > > > > > > Currently on a ppc64 box with 16 CPUs, the time taken for
>> > > > > > > a individual cpu-hotplug operation is as follows.
>> > > > > > > 
>> > > > > > >     # time echo 0 > /sys/devices/system/cpu/cpu2/online
>> > > > > > >     real    0m0.025s
>> > > > > > >     user    0m0.000s
>> > > > > > >     sys     0m0.002s
>> > > > > > > 
>> > > > > > >     # time echo 1 > /sys/devices/system/cpu/cpu2/online
>> > > > > > >     real    0m0.021s
>> > > > > > >     user    0m0.000s
>> > > > > > >     sys     0m0.000s
>> > > > > > 
>> > > > > > Surprised.  Do people really online and offline CPUs frequently enough
>> > > > > > for this to be a problem?
>> > > > > 
>> > > > > Certainly not for hardware faults or hardware replacement, but
>> > > > > cpu-hotplug interface is useful for changing system configuration to
>> > > > > meet different objectives like
>> > > > > 
>> > > > > * Reduce system capacity to reduce average power and reduce heat
>> > > > > 
>> > > > > * Increasing number of cores and threads in a CPU package is leading
>> > > > >   to multiple cpu offline/online operations for any perceivable effect
>> > > > > 
>> > > > > * Dynamically change CPU configurations in virtualized environments
>> > > > 
>> > > > I tend to agree with Andrew, if any of those things are done 
>> > > > frequent enough that the hotplug performance matter you're doing 
>> > > > something mighty odd.
>> > > 
>> > > Boot speedup?
>> > 
>> > Also, if it brings more attention (and more stability and more 
>> > bugfixes) to CPU hotplug that's only good.
>> 
>> Sure, but do we need the extra complexity?
>> 
>> I mean, sure bootup speed might be nice, but any of the scenarios 
>> given should simply not require cpu hotplug actions of a frequent 
>> enough nature that any performance matters.
>
> Well, the fact that the patches exist show that there's people 
> caring about the speedup here. The speedup itself is non-trivial.

If I correctly understand the behavior of the patch set as posted, there
is no speedup beyond eliminating the overhead of multiple writes to
/sys/devices/system/cpu/cpu*/online.  To obtain non-trivial speedups via
bulk hotplug, one or both of the following items from the TODO list need
to be completed:

- Enhance the subsystem notifiers to work on a cpumask_var_t instead of a cpu
  id.

- Optimize the subsystem notifiers to reduce the time consumed while
  handling CPU_[DOWN_PREPARE/DEAD/UP_PREPARE/ONLINE] events for the
  cpumask_var_t.

Right?

(The powerpc-specific patch at the beginning of the series improves
hot-online time for a single cpu in some circumstances and is basically
unrelated to the aim of the patch set -- it should go upstream through
the powerpc tree independently.)
