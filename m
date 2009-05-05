Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZEEXh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZEEXh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZEEXhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:37:48 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:54287 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbZEEXhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:37:47 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090505233339.542880f8@lxorguk.ukuu.org.uk>
References: <1241462661.412.8.camel@alok-dev1>	<4A00ADDE.9000908@zytor.com>
	 <20090505224417.0f00c2f0@lxorguk.ukuu.org.uk>
	 <1241561394.8665.31.camel@alok-dev1>
	 <20090505233339.542880f8@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 05 May 2009 16:37:47 -0700
Message-Id: <1241566667.8665.62.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-05-05 at 15:33 -0700, Alan Cox wrote:
> > IMO, one of the main motives of HRT implementation apart from getting
> > higher precision timers was that we now don't necessarily need to rely
> 
> Timer frequency and HZ are two entirely different things nowdyas

Huh ? maybe I am reading this code incorrectly, but this is what I
understand, the APIC is still being programmed to wake HZ time every
second if the system is nonidle (periodic mode). 
Only if the system is idle does the kernel program the APIC in one shot
mode as a result the tickless kernel gives us a lot less pain when the
guest is idle. 

Here are the numbers with a HZ=100 kernel which proves this hypothesis. 

[root@alok-vm-rhel64 ~]# cat /proc/interrupts | grep "timer" ; time
sleep 30 ; cat /proc/interrupts | grep "timer"
  0:         36          0   IO-APIC-edge      timer
LOC:       7549       7176   Local timer interrupts

real    0m30.006s
user    0m0.000s
sys     0m0.000s
  0:         36          0   IO-APIC-edge      timer
LOC:       7616       7209   Local timer interrupts


So in this case when the system is (pretty much) "idle" the total number
of wakeup's are far less just about 65 in the total 30sec on cpu0.

If I run a simple program which does a tight loop, this to check the
behavior when the system is non-idle, 

[root@alok-vm-rhel64 ~]# cat /proc/interrupts | grep "timer" ;
time ./tightloop_short ; cat /proc/interrupts | grep "timer"
  0:         36          0   IO-APIC-edge      timer
LOC:       8008       7453   Local timer interrupts

real    0m30.377s
user    0m30.370s
sys     0m0.000s
  0:         36          0   IO-APIC-edge      timer
LOC:      11049      10493   Local timer interrupts

Here we see that we had a total of ~3000 interrupts. In this case the
system was non-idle and hence the APIC was programmed in periodic mode. 

The tightloop program only does this
 int main()
{
        unsigned long long count;
        while(count++ < 5999999999UL);
        return 0;
}


If I do the same experiments on a HZ=1000 kernel I  see that the number
of interrupts would rise to 30000 in the second case.

I did check that the "apic_timer_irqs" counter - that is read from the
proc file  - is updated only from smp_apic_timer_interrupt code path, so
this can't be a interrupt accounting bug.

In short, I don't believe that HZ and timer frequency are not related
nowadays, please correct me if I am missing anything here. 

> 
> > on a high timer frequency. If you see problems with Desktop feel and
> > responsiveness don't you think there would be other problem which might
> > be causing that ?  Your argument about the "desktop feel and
> > responsiveness" doesn't explain what actual problem did you see.
> 
> People spent months poking at the differences before HZ=1000 became the
> default. It wasn't due for amusement values - but this is irrelevant
> anyway on a modern kernel as HZ=1000 is simply a precision setting that
> affects things like poll()
> 
> HZ on a tickless system has no meaningful relationship to wakup rates -
> which are what I assume you actually care about.

Yes I care about the wakeup rates and as explained above HZ does affect
that.

> 
> So do you want to change the precision of poll() and other
> functionality ? or do you want to change the wakeup rates and
> corresponding virtualisation overhead ?
> 
> If the latter then HZ is not the thing to touch.
> 
> What are you *actually* trying to achieve ?
> What measurements have you done that make you think HZ is relevant in a
> tickless kernel ?
> 
I hope all these questions are answered above.

Thanks,
Alok
> 
> Alan

