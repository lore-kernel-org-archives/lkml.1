Return-Path: <linux-kernel-owner+w=401wt.eu-S1767415AbXDEXEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767415AbXDEXEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767406AbXDEXEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:04:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:47579 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767266AbXDEXEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:04:23 -0400
Subject: Re: Questions about porting perfmon2 to powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kevin Corry <kevcorry@us.ibm.com>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Carl Love <carll@us.ibm.com>
In-Reply-To: <200704051455.34600.kevcorry@us.ibm.com>
References: <200704051455.34600.kevcorry@us.ibm.com>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 09:04:02 +1000
Message-Id: <1175814243.30879.146.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 14:55 -0500, Kevin Corry wrote:
> Hello,
> 
> Carl Love and I have been working on getting the latest perfmon2 patches 
> (http://perfmon2.sourceforge.net/) working on Cell, and on powerpc in 
> general. We've come up with some powerpc-specific questions and we're hoping 
> to get some opinions from the powerpc kernel developers.
> 
> First, the stock 2.6.20 kernel has a prototype in include/linux/smp.h for a 
> function called smp_call_function_single(). However, this routine is only 
> implemented on i386, x86_64, ia64, and mips. Perfmon2 apparently needs to 
> call this to run a function on a specific CPU. Powerpc provides an 
> smp_call_function() routine to run a function on all active CPUs, so I used 
> that as a basis to add an smp_call_function_single() routine. I've included 
> the patch below and was wondering if it looked like a sane approach.

We should do better... it will require some backend work for the various
supported PICs though. I've always wanted to look into doing a
smp_call_function_cpumask in fact :-)

> Next, we ran into a problem related to Perfmon2 initialization and sysfs. The 
> problem turned out to be that the powerpc version of topology_init() is 
> defined as an __initcall() routine, but Perfmon2's initialization is done as 
> a subsys_initcall() routine. Thus, Perfmon2 tries to initialize its sysfs 
> information before some of the powerpc cpu information has been initialized. 
> However, on all other architectures, topology_init() is defined as a 
> subsys_initcall() routine, so this problem was not seen on any other 
> platforms. Changing the powerpc version of topology_init() to a 
> subsys_initcall() seems to have fixed the bug. However, I'm not sure if that 
> is going to cause problems elsewhere in the powerpc code. I've included the 
> patch below (after the smp-call-function-single patch). Does anyone know if 
> this change is safe, or if there was a specific reason that topology_init() 
> was left as an __initcall() on powerpc?

It would make sense to follow what other archs do. Note that if both
perfmon and topology_init are subsys_initcall, that is on the same
level, it's still a bit hairy to expect one to be called before the
other...

Ben.


