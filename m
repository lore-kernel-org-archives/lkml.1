Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbXGXTfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbXGXTfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXGXTfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:35:43 -0400
Received: from users.sycamorenet.com ([12.146.0.130]:38608 "EHLO
	edsel.sycamorenet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762560AbXGXTfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:35:42 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH -rt] Preemption problem in kernel RT Patch
Date: Tue, 24 Jul 2007 15:36:29 -0400
Message-ID: <77B279EC7347F341A6AE891AA6AD68E93142A5@ranchero.sycamorenet.com>
In-Reply-To: <20070724191515.GC13268@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -rt] Preemption problem in kernel RT Patch
Thread-Index: AcfOJxpu1Cfa2CBISKiVNrBca7OklgAAc7CQ
From: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 24 Jul 2007 19:36:31.0638 (UTC) FILETIME=[EFDA2360:01C7CE29]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

> ah ... i think i did it like that because i didnt realize that there 
> would be a recursive call sequence, i was concentrating on recursive 
> locking.

	That makes sense.  It doesn't seem right that it gets called 
recursive in the first place.  I'm not sure, however, if the tunnel 
code can help it as it uses ip_output to send packets.

> incidentally, this code got cleaned up in .23-rc1-rt0, and now it looks 
> quite similar to your suggested fix. Could you double-check that it 
> solves your problem?

I've downloaded .23-rc1-rt0.  It appears the issue remains in both places
as seen below:


net/core/dev.c:  dev_queue_xmit

#ifdef CONFIG_PREEMPT_RT
		if (1) {
#else
		int cpu = raw_smp_processor_id(); /* ok because BHs are off */

		if (dev->xmit_lock_owner != cpu) {
#endif


and net/sched/sch_generic.c: qdisc_restart

#ifdef CONFIG_PREEMPT_RT
		netif_tx_lock(dev);
#else
		if (netif_tx_trylock(dev))
			/* Another CPU grabbed the driver tx lock */
			return handle_dev_cpu_collision(skb, dev, q);
#endif

	Mark

	

-----Original Message-----
From: Ingo Molnar [mailto:mingo@elte.hu]
Sent: Tuesday, July 24, 2007 3:15 PM
To: Beauchemin, Mark
Cc: Thomas Gleixner; linux-kernel@vger.kernel.org; David Miller
Subject: Re: [PATCH -rt] Preemption problem in kernel RT Patch



* Beauchemin, Mark <Mark.Beauchemin@sycamorenet.com> wrote:

> I'm not sure why the check for recursion has been removed.  In the 
> backtrace below, I think it would be caught by this check and not 
> recursively call the spinlock code.

ah ... i think i did it like that because i didnt realize that there 
would be a recursive call sequence, i was concentrating on recursive 
locking.

incidentally, this code got cleaned up in .23-rc1-rt0, and now it looks 
quite similar to your suggested fix. Could you double-check that it 
solves your problem?

	Ingo


