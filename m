Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYFBV71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYFBV71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYFBV7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:59:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16606 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYFBV7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:59:17 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5308"; a="3447199"
Message-ID: <48446D46.2010903@qualcomm.com>
Date: Mon, 02 Jun 2008 14:59:34 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, "Derek L. Fults" <dfults@sgi.com>,
       devik <devik@cdi.cz>, Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Randy.Dunlap" <rddunlap@osdl.org>, suresh.b.siddha@intel.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com> <20080602164203.GA2477@sgi.com> <48443E66.6060205@qualcomm.com> <20080602214151.GA7072@sgi.com>
In-Reply-To: <20080602214151.GA7072@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich wrote:
> On Mon, Jun 02, 2008 at 11:39:34AM -0700, Max Krasnyansky wrote:
>> Ah, I know exactly what you're talking about.  However this is non-issue these
>> days. In order to clear cpuN from all the timers and other things all you need
>> to do is to bring that cpu off-line
>> 	echo 0 > /sys/devices/cpu/cpuN/online
>> and then bring it back online
>> 	echo 1 > /sys/devices/cpu/cpuN/online
> 
> Although it seemed like something of a hack, we experimented with this
> previously and found that it didn't work reliably.  I'm sure things
> have gotten better, but will need to revisit.
Yes it used to be somewhat unstable. These days it solid. I'm using it on a
wide range of systems: uTCA Core2Duo, NUMA dual-Opteron, 8way Core2, etc. And
things work as expected.
I forgot to mention that it's not just timers. There are also work queues and
delayed work that have similar side effects (ie they stick to the CPU they
were originally scheduled on). Hotplug cleans all that stuff very nicely.

btw I would not call it a hack. ie Using cpu hotplug for isolation purposes.
By definition hotplug must be able to migrate _everything_ running on the cpuN
when it goes off-line, otherwise it simply won't work. And that's exactly what
we need for the isolation too (migrate everything running on a cpuN to other
cpus).

>> There are currently a couple of issues with scheduler domains and hotplug
>> event handling. I do have the fix for them, and Paul had already acked it.
> 
> Until a proven reliable method for doing this is firmly in place (as
> firmly as anything is, anyway),  I don't think we should be removing
> the alternative.
Agree. That's why I submitted the removal patch along with those fixes ;-).

>> initialization). See my latest "default IRQ affinity" patch.
> Nice idea.
Thanx.

>> Also isolcpus= conflicts with the scheduler domains created by the cpusets.
> 
> What sort of conflict are we talking about? I assume once you've begun
> setting up cpusets that include those cpus that you're intention is to change
> the original behavior.
That exactly where the conflict is. Lets say you boot with isolcpus=2 (ie cpu2
is not load balanced), then you add cpu2 along with cpu3 to cpuset N and
enable load balancing in cpusetN. In that case cpu2 will still remain
unbalanced which is definitely a wrong behaviour.

Max





