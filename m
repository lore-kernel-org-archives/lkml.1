Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYIXLSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYIXLSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYIXLSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:18:39 -0400
Received: from mercury.realtime.net ([205.238.132.86]:57175 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYIXLSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:18:38 -0400
X-Greylist: delayed 968 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2008 07:18:38 EDT
In-Reply-To: <1222251467.8277.73.camel@pasglop>
References: <200809231743.23828.ossthema@de.ibm.com> , <20080915100406.342e027a@bull.net> <200809240958.m8O9wM7k010996@sullivan.realtime.net> <1222251467.8277.73.camel@pasglop>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f30d1d832fd4ad096afccf198c14a7bb@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Christoph Raisch <RAISCH@de.ibm.com>, linuxppc-dev@ozlabs.org,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Sebastien Dugue <sebastien.dugue@bull.net>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with hardirq preemption
Date: Wed, 24 Sep 2008 06:02:54 -0500
To: benh@kernel.crashing.org
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 24, 2008, at 5:17 AM, Benjamin Herrenschmidt wrote:
> On Wed, 2008-09-24 at 04:58 -0500, Milton Miller wrote:
>> The per-interrupt mask and unmask calls have to go through RTAS, a
>> single-threaded global context, which in addition to increasing
>> path length will really limit scalability.  The interrupt controller
>> poll and reject facilities are accessed through hypervisor calls
>> which are comparable to a fast syscall, and parallel to all cpus.
>
> Note also that the XICS code thus assumes, iirc, as does the cell IIC
> code, that eoi is called on the -same- cpu that fetched the interrupt
> initially. That assumption can be broken with IRQ threads no ?

There may be some implicit assumption in that we expect the cpu 
priority to be returned to normal by the EOI, but there is nothing in 
the hardware that requires the EOI to come from the same cpu as 
accepted the interrupt for processing, with the exception of the IPI 
which is per-cpu (and the only interrupt that is per-cpu).

It would probably mean adding the concept of the current cpu priority 
vs interrupts and making sure we write it to hardware at irq_exit() 
time when deferring the actual irq handlers.

The MPIC hardware, on the other hand, maintains a queue of pending 
interrupts (It has been about a decade but the number 4-5 comes to 
mind), and the hardware must receive the EOI on the cpu that took it.  
I am guessing that the handling described (take level irq, mask it, eoi 
it, dispatch the thread, then unmask it after processing) is a result 
to work within those limitations.  Do you know the cell IIC to know if 
its mpic or xics in this regard?

The other unknown is the (very few) platforms that present as xics but 
are really firmware on mpic.  If they do a full virtual layer and don't 
take shortcuts but do eoi/mask like described here they should work, 
but I would not be surprised that does not hold true :-(.

milton

