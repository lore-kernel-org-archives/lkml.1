Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYIPNx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYIPNx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYIPNxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:53:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:50383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYIPNxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:53:49 -0400
Date: Tue, 16 Sep 2008 06:53:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: arun@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       a.p.zijlstra@chello.nl, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/1]: timers: Timer Migration
Message-ID: <20080916065345.76d052e1@infradead.org>
In-Reply-To: <20080916091219.GA1068@linux.vnet.ibm.com>
References: <20080916091219.GA1068@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 14:42:31 +0530
Arun R Bharadwaj <arun@linux.vnet.ibm.com> wrote:

> Hi,
> 
> An idle cpu on which device drivers have initialized timers, has to
> be frequently woken up to service the timers. So, consolidation of
> timers onto a fewer number of cpus is important. Migration of timers
> from idle cpus onto lesser idle cpus is necessary. Currently, timers
> are migrated during the cpu offline operation. However cpu-hotplug
> for the sake of idle system power management is too heavy. So, this
> patch implements a lightweight timer migration framework.

while I absolutely like reducing power consumption... I'm not sure this
helps or is the right approach.

First of all, it's of course absolutely better to fix timers and apps
that cause them (and with PowerTOP we fixed basically all the bad
stuff).

Second, in terms of power; a wake up is a wake up, it doesn't really
matter where it happens. 

Now we could do some consolidation (which realistically needs the range
timer feature that's aimed for 2.6.28), but I would much rather do that
in a different way: rather than actively moving stuff, I would instead
suggest sharing the timer queues between logical cpus that share the
same cache. (Now its an admin choice if he wants this on a "shared L1",
"shared L2" or "shared L3" basis). 

Or if you want to forcefully migrate timers, don't move existing ones,
just on queue/requeue put the on not-the-local-cpu. Sure they'll fire
once on the "wrong" cpu, but that's a very short term problem!

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
