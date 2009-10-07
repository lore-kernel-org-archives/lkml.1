Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbZJGL1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbZJGL1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759027AbZJGL1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:27:33 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:38289 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbZJGL1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:27:32 -0400
Date: Wed, 7 Oct 2009 16:56:48 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Cc: arun@linux.vnet.ibm.com, Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org
Subject: Re: [v7 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
 management code in x86, cleanup drivers/cpuidle/cpuidle.c and introduce
 cpuidle to POWER.
Message-ID: <20091007112648.GC7646@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20091006152421.GA7278@linux.vnet.ibm.com>
 <20091006163521.GA10425@linux.vnet.ibm.com>
 <1254852279.17055.2.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1254852279.17055.2.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-10-06 20:04:39]:

> On Tue, 2009-10-06 at 22:05 +0530, Arun R Bharadwaj wrote:
> 
> > Also, the per-cpu nature of registration/unregistration of cpuidle
> > has been maintained as ACPI needs this.
> 
> Right, so can't we ditch that and have acpi default to the lowest common
> C-state and warn when various cpus report different C-states?

Hi Peter,

As Arjan mentioned previously, the per-cpu registration has to stay
for x86 for now due to legacy ACPI compatibility.  Breaking that may
break lot of existing users and we do not have a clean fallback
method.  

As far as powerpc is concerned, we can work with a single global
registration.  However we would like to have the same interface across
different archs.

With the new re-factoring (v7), Arun has killed most of the list
traversal and linking between various cpu's cpuidle_driver structures.
Now we have a per-cpu stack of registered devices and we lookup the
structs using online cpumasks.  The cpuidle_driver structure has list
of idle routing pointers (struct cpuidle_state) and rest of it is
statistics that needs to be maintained at a per-cpu level anyway.  All
that is duplicated here is the array of idle routines (struct
cpuidle_state) on each cpu.

The objective of the refactoring is to have a single common idle
routine management framework (remove pm_idle) and we have it done
through cpuidle registration framework.  We can incrementally remove
the per-cpu registration later easily by splitting the cpuidle_driver
structure.

--Vaidy

