Return-Path: <linux-kernel-owner+w=401wt.eu-S934096AbZJOGHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbZJOGHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 02:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZJOGHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 02:07:36 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:33828 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZJOGHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 02:07:34 -0400
Date: Thu, 15 Oct 2009 11:36:52 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v8 PATCH 2/8]: cpuidle: implement a list based approach to
	register a set of idle routines.
Message-ID: <20091015060651.GA4569@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com> <20091008095027.GC20595@linux.vnet.ibm.com> <1254998162.26976.270.camel@twins> <20091008104249.GJ20595@linux.vnet.ibm.com> <1254999033.26976.272.camel@twins> <8763akh4re.fsf@basil.nowhere.org> <20091014061727.GA8605@linux.vnet.ibm.com> <20091014071838.GE23248@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091014071838.GE23248@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2009-10-14 09:18:38]:

> > How about something like this..
> > If the arch does not enable CONFIG_CPU_IDLE, the cpuidle_idle_call
> > which is called from cpu_idle() should call default_idle without
> > involving the registering cpuidle steps. This should prevent bloating
> > up of the kernel for archs which dont want to use cpuidle.
> 
> On x86 some people want small kernel too, so selecting it on a architecture
> granuality is not good. Also you can make it default, you just need
> to slim it down first.
> 

No, I dont mean selecting it on an architecture granularity.

At compile time, if CONFIG_CPU_IDLE is disabled, the arch can redefine
cpuidle_idle_call. For e.g. in arch/x86/kernel/process.c

#ifndef CONFIG_CPU_IDLE
void cpuidle_idle_call(void)
{
	if (local_idle)
		local_idle();
	else
		default_idle();
}
#endif

where local_idle points to the idle routine selected using
select_idle_routine() which can be poll, mwait, c1e.

So this way, we still preserve the exact same functionality as before
and we also remove the ugly pm_idle exported function pointer and we
avoid unnecessary code bloat for platforms who do not want to use
cpuidle.

--arun
