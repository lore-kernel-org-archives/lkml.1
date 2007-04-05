Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbXDEUII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbXDEUII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXDEUII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:08:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:52562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbXDEUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:08:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: Questions about porting perfmon2 to powerpc
Date: Thu, 5 Apr 2007 22:08:00 +0200
User-Agent: KMail/1.9.6
Cc: Kevin Corry <kevcorry@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Carl Love <carll@us.ibm.com>
References: <200704051455.34600.kevcorry@us.ibm.com>
In-Reply-To: <200704051455.34600.kevcorry@us.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704052208.01753.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/5A8f9iEFB/LBM5IO+IG2KNzYVYbuHlo3gs/k
 m8S0oNF1JGSr0sKN4Eg5b6QIQV4tGveDrmhK8wNDD665u3PynO
 LDzI2p4OtqRwJy5W5dKUQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007, Kevin Corry wrote:

> First, the stock 2.6.20 kernel has a prototype in include/linux/smp.h for a 
> function called smp_call_function_single(). However, this routine is only 
> implemented on i386, x86_64, ia64, and mips. Perfmon2 apparently needs to 
> call this to run a function on a specific CPU. Powerpc provides an 
> smp_call_function() routine to run a function on all active CPUs, so I used 
> that as a basis to add an smp_call_function_single() routine. I've included 
> the patch below and was wondering if it looked like a sane approach.

The function itself looks good, but since it's very similar to the existing
smp_call_function(), you should probably try to share some of the code,
e.g. by making a helper function that gets an argument to decide whether
to run on a specific CPU or on all CPUs.

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

In general, it's better to do initcalls as late as possible, so __initcall()
is preferred over subsys_initcall() if both work. Have you tried doing it
the other way and starting perfmon2 from a regular __initcall()?

	Arnd <><
