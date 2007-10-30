Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXJ3HPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXJ3HPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXJ3HPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:15:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40141 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXJ3HPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:15:08 -0400
Date: Tue, 30 Oct 2007 08:14:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan Hecht <dhecht@vmware.com>
Cc: Zachary Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       jeremy@goop.org, --cc@redhat.com, avi@quramnet.com,
       kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071030071435.GA17074@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com> <20071029230213.GA1982@elte.hu> <47266B90.8000008@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47266B90.8000008@vmware.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan Hecht <dhecht@vmware.com> wrote:

>> but if there's a perfect TSC available (there is such hardware) then 
>> the TSC _is_ the best clocksource. Paravirt now turns it off 
>> unconditionally in essence.
>
> Not really.  In the case hardware TSC is perfect, the paravirt time 
> counter can be implemented directly in terms of hardware TSC; there is 
> no loss in optimization.  This is done transparently.  And virtual TSC 
> can be implemented this way too.

Of course if you duplicate all (or part) of the TSC clocksource driver 
in the paravirt guest code then the "paravirt clocksource" is at least 
as good as the TSC. But that argument is playing word-games, _of course_ 
if you use the same (or similar) code it's at least as good. The real 
question are clocksources that communicate out to the hypervisor, and 
hence have higher overhead than a native, TSC based clocksource - and 
clocksources that use the TSC in a broken way.

> The real improvement that a paravirt clocksource offers over the TSC 
> clocksource is that the guest does not need to measure the TSC 
> frequency itself against some other constant frequency source (which 
> is problematic on a virtual machine). [...]

hey, you need not tell me, i've implemented a hyper-clocksource driver 
myself. But calibration is a boot only issue and there's no reason why 
calibration _has_ to be fragile. For example we could easily extend the 
TSC clocksource driver to not calibrate in the guest but take 
calibration information from the host. It's in essence a trivial and 
obvious extension to calibration. That way we get the highest possible 
performance _and_ we share much of the clocksource driver with the host.

also, the way the TSC is used by guests like Xen is fundamentally 
fragile on SMP. So i have a good reason to distrust the approach of 
hypervisors to timekeeping. The maintenance problem to me is that 
everyone in the paravirt space is busy coding away in their own (often 
broken) direction, replicating the essence of the TSC clocksource driver 
4 times over again and again, with subtle bugs in each variant, even in 
cases where the TSC readout can be trusted perfectly well. 
"Consolidation" and "sharing code" is not a particularly strong point of 
the paravirt projects ;-) (ok, KVM is a notable exception there.)

anyway, i do agree that this patch is wrong currently, mainly due to TSC 
calibration not being reliable in guest-space at the moment - but the 
whole concept of putting a separate clocksource driver into each 
paravirt guest, even in the case where the TSC is perfect, is madness. 
That code, once the hardware gets sane (and there are good signs for 
that), and once calibration can be passed from host to guest reliably, 
_will_ be consolidated, because it makes perfect technical sense.

	Ingo
