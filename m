Return-Path: <linux-kernel-owner+w=401wt.eu-S1767303AbXDEUcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767303AbXDEUcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767304AbXDEUcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:32:20 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53038 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767306AbXDEUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:32:16 -0400
From: Kevin Corry <kevcorry@us.ibm.com>
Organization: IBM
To: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org
Subject: Re: Questions about porting perfmon2 to powerpc
Date: Thu, 5 Apr 2007 15:32:07 -0500
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Carl Love <carll@us.ibm.com>
References: <200704051455.34600.kevcorry@us.ibm.com> <200704052208.01753.arnd@arndb.de>
In-Reply-To: <200704052208.01753.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051532.08775.kevcorry@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu April 5 2007 3:08 pm, Arnd Bergmann wrote:
> On Thursday 05 April 2007, Kevin Corry wrote:
> > First, the stock 2.6.20 kernel has a prototype in include/linux/smp.h for
> > a function called smp_call_function_single(). However, this routine is
> > only implemented on i386, x86_64, ia64, and mips. Perfmon2 apparently
> > needs to call this to run a function on a specific CPU. Powerpc provides
> > an smp_call_function() routine to run a function on all active CPUs, so I
> > used that as a basis to add an smp_call_function_single() routine. I've
> > included the patch below and was wondering if it looked like a sane
> > approach.
>
> The function itself looks good, but since it's very similar to the existing
> smp_call_function(), you should probably try to share some of the code,
> e.g. by making a helper function that gets an argument to decide whether
> to run on a specific CPU or on all CPUs.

Ok. I'll see what I can come up with and post another patch today or tomorrow.


> > Next, we ran into a problem related to Perfmon2 initialization and sysfs.
> > The problem turned out to be that the powerpc version of topology_init()
> > is defined as an __initcall() routine, but Perfmon2's initialization is
> > done as a subsys_initcall() routine. Thus, Perfmon2 tries to initialize
> > its sysfs information before some of the powerpc cpu information has been
> > initialized. However, on all other architectures, topology_init() is
> > defined as a subsys_initcall() routine, so this problem was not seen on
> > any other platforms. Changing the powerpc version of topology_init() to a
> > subsys_initcall() seems to have fixed the bug. However, I'm not sure if
> > that is going to cause problems elsewhere in the powerpc code. I've
> > included the patch below (after the smp-call-function-single patch). Does
> > anyone know if this change is safe, or if there was a specific reason
> > that topology_init() was left as an __initcall() on powerpc?
>
> In general, it's better to do initcalls as late as possible, so
> __initcall() is preferred over subsys_initcall() if both work. Have you
> tried doing it the other way and starting perfmon2 from a regular
> __initcall()?

For the moment, I made the change to topology_init() since it was the simplest 
fix to get things working. I have considered switching the perfmon2 
initialization to __initcall(), but there are apparently some timing issues 
with ensuring that the perfmon2 core code is initialized before any of its 
sub-modules. Since they could all be compiled statically in the kernel, I'm 
not sure if there's a way to ensure the ordering of calls within a single 
initcall level. I'll need to ask Stephane if there were any other reasons why 
subsys_initcall() was used for perfmon2.

Thanks, Arnd.
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
