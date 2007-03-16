Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbXCPI6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbXCPI6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXCPI6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:58:52 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:32291 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbXCPI6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:58:51 -0400
Subject: Re: Stolen and degraded time and schedulers
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Dan Hecht <dhecht@vmware.com>
Cc: Rik van Riel <riel@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dwalker@mvista.com, cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, paulus@au1.ibm.com,
       Zachary Amsden <zach@vmware.com>
In-Reply-To: <45F9AE1D.7080203@vmware.com>
References: <45F6D1D0.6080905@goop.org>
	 <1173816769.22180.14.camel@localhost>	<45F70A71.9090205@goop.org>
	 <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org>
	 <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org>
	 <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org>
	 <45F85A62.8050001@vmware.com> <45F85BBB.70707@goop.org>
	 <45F85F43.9030803@vmware.com> <45F866AF.9060609@goop.org>
	 <45F999D4.6080602@vmware.com> <45F9A42D.7090205@goop.org>
	 <45F9A788.1010008@vmware.com> <45F9A93A.2030400@redhat.com>
	 <45F9AE1D.7080203@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Fri, 16 Mar 2007 09:59:01 +0100
Message-Id: <1174035541.2811.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 13:35 -0700, Dan Hecht wrote:
> >> Yes, the part in the "i.e." above is describing available time.  So, 
> >> it is essentially is the same definition of stolen time VMI uses:
> > 
> >> stolen time     == ready to run but not running
> >> available time  == running or not ready to run
> > 
> > S390 too.  We were quite careful to make sure that steal time
> > means the same on the different platforms when the code was
> > introduced.
> > 
> 
> The S390 folks should correct me if I'm mistaken, but I think S390 works 
> a bit differently.  I don't think their "steal clock" will differentiate 
> between idle time and stolen time (since it's implemented as a hardware 
> clock that counts the time a particular vcpu context is executing on the 
> pcpu).  So they need the kernel to differentiate between really stolen 
> time and just idle time.  At least, I assume this is why 
> account_steal_time() can then sometimes account steal time towards idle, 
> and looking at arch/s390/kernel/vtime.c seems to indicate this.
> idle period.

For s390 we have: stolen time == wanted to run but the hypervisor didn't
let us. The way this is implemented is by using the cpu timer. This is a
per-cpu register that is fully virtualized. It runs at the same rate as
the clock, but only if the virtual cpu is scheduled to run. If the real
cpu falls out of the guest context the guest cpu timer just stops. The
wall clock (TOD) keeps ticking. The calculation to find the amount of
stolen time is now simple: TOD clock - guest cpu timer.
For idle there is a little pitfall. If the guest cpu is a dedicated cpu
under LPAR loading a wait psw does not cause the guest cpu fall out of
the guest context. The guest cpu timer will continue ticking. In this
case the time spent in idle is accounted via system_time. If the guest
cpu is a shared cpu then loading a wait psw will cause the cpu to fall
out of guest context and the guest cpu timer will be stopped. In this
case the idle time will be accounted via steal_time. 

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


