Return-Path: <linux-kernel-owner+w=401wt.eu-S933583AbXGQIYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbXGQIYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933464AbXGQIXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:23:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33032 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933443AbXGQIXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:23:42 -0400
Date: Tue, 17 Jul 2007 13:53:32 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitriy Zavin <dmitriyz@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Ashok Raj <ashok.raj@intel.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, heiko.carstens@de.ibm.com,
       kiran@scalex86.org, clameter@sgi.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/10] cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
Message-ID: <20070717082331.GA12231@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070716134855.GA1858@APFDCB5C> <20070716135347.GD2040@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716135347.GD2040@APFDCB5C>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

On Mon, Jul 16, 2007 at 10:53:47PM +0900, Akinobu Mita wrote:
> The functions in a CPU notifier chain is called with CPU_UP_PREPARE event
> before making the CPU online. If one of the callback returns NOTIFY_BAD,
> it stops to deliver CPU_UP_PREPARE event, and CPU online operation is canceled.
> Then CPU_UP_CANCELED event is delivered to the functions in a CPU notifier
> chain again.
> 
> This CPU_UP_CANCELED event is delivered to the functions which have been
> called with CPU_UP_PREPARE, not delivered to the functions which haven't
> been called with CPU_UP_PREPARE.
> 
> The problem that makes existing cpu hotplug error handlings complex is
> that the CPU_UP_CANCELED event is delivered to the function that has
> returned NOTIFY_BAD, too.
> 
> Usually we don't expect to call destructor function against the
> object that has failed to initialize. It is like:
> 
> 	err = register_something();
> 	if (err) {
> 		unregister_something(); // bug
> 		return err;
> 	}
> 
> So it is natural to deliver CPU_UP_CANCELED event only to the functions
> that have returned NOTIFY_OK with CPU_UP_PREPARE event and not to call
> the function that have returned NOTIFY_BAD. This is what this patch is doing.

Yes, this makes sense. However, it might break slab.
If I am not mistaken, slab code initializes multiple objects in 
CPU_UP_PREPARE and relies on the CPU_UP_CANCELLED to destroy the 
objects which successfully got initialized before the some object's
initialization went bad.

But then, I'm no expert on slab, so Cc'ing the right people.

There must be a way to share the code across CPU_UP_CANCELLED and
destruction of correctly initialized objects in CPU_UP_PREPARE 
(on a failure). That fix might be required before this patch goes in.

Regards
gautham.

> 
> Otherwise, every cpu hotplug notifiler has to track whether
> notifiler event is failed or not for each cpu.
> (drivers/base/topology.c is doing this with topology_dev_map)
> 
> Similary this patch makes same thing with CPU_DOWN_PREPARE and
> CPU_DOWN_FAILED evnets.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> ---
>  kernel/cpu.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: 2.6-mm/kernel/cpu.c
> ===================================================================
> --- 2.6-mm.orig/kernel/cpu.c
> +++ 2.6-mm/kernel/cpu.c
> @@ -138,6 +138,7 @@ static int _cpu_down(unsigned int cpu, i
>  	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
>  					hcpu, -1, &nr_calls);
>  	if (err == NOTIFY_BAD) {
> +		nr_calls--;
>  		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
>  					  hcpu, nr_calls, NULL);
>  		printk("%s: attempt to take down CPU %u failed\n",
> @@ -221,6 +222,7 @@ static int __cpuinit _cpu_up(unsigned in
>  	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
>  							-1, &nr_calls);
>  	if (ret == NOTIFY_BAD) {
> +		nr_calls--;
>  		printk("%s: attempt to bring up CPU %u failed\n",
>  				__FUNCTION__, cpu);
>  		ret = -EINVAL;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
