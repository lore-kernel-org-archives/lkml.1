Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZHKRxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZHKRxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 13:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZHKRxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 13:53:48 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:43468 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZHKRxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 13:53:47 -0400
Date: Tue, 11 Aug 2009 23:23:41 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Li, Shaohua" <shaohua.li@intel.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090811175341.GA6328@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com> <20090806015855.GA20596@sli10-desk.sh.intel.com> <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl> <20090810081941.GA18649@elf.ucw.cz> <1249950137.11545.38184.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249950137.11545.38184.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 05:22:17PM -0700, Pallipadi, Venkatesh wrote:
> Also, I don't think using just the ACPI/BIOS supplied states in _CST is
> right thing to do for offline. _CST is meant for C-state and BIOS may
> not include some C-state in _CST if the system manufacturer thinks that
> the latency is too high for the state to be used as a C-state. That
> limitation applies for C-state as the cpu is expected to come out of
> C-state often and execute code handle interrupts etc. But, that
> restriction does not apply for offline online which is not as frequent
> as C-state entry and it already has big latency with startup IPI, and a
> whole baggage of CPU setup code. So, using BIOS CST info for CPU offline
> state doesn't seem right.
> 
> May be having (to pick a number) 3 possible offline states for all
> platforms with one for halt equivalent and one for deepest possible that
> CPU can handle and one for deepest possible that platform likes for
> C-states may make sense. Will keeps things simpler in terms of usage
> expectations and possibly reduce the misuse oppurtubity?

Yes, I think we should let specific archs advertise a small set
of possible offline states and let the cpu state be set to one of
those only keeping the platform implementation robust.

Here is variant of the original proposal from Gautham -

/sys/devices/system/cpu/cpu<number>/available_states

For example, available state for an Intel platform could be exported as
"online dealloc C1 C6"

online = fully up
dealloc = offline and de-allocated (as in virtualized environment)
C1 = C1 or C1E halt
C6 = C6 sleep

/sys/devices/system/cpu/cpu<number>/state

Writing any of the available states to this file triggers transition to that 
state barring some transitions that are disallowed to keep things simple
(e.g. dealloc cpus support only transition to online).

/sys/devices/system/cpu/cpu<number>/online

Backward compatibility - online = 0 changes state to C6 or dealloc depending
on the platform. online = 1 changes state to online.

Would this make sense ?

Thanks
Dipankar




