Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZBCPCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZBCPCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZBCPCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:02:31 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:39405 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbZBCPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:02:30 -0500
Message-ID: <49885C81.2040901@rsk.demon.co.uk>
Date: Tue, 03 Feb 2009 15:02:25 +0000
From: richard kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Karsten Keil <kkeil@suse.de>
CC: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC] Suspicious bug in module refcounting
References: <20090203134721.GA11069@pingi.kke.suse.de>
In-Reply-To: <20090203134721.GA11069@pingi.kke.suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Keil wrote:
> Hi,
> 
> While debugging a wired SCTP bug we hit from time to time
> the BUG_ON(module_refcount(module) == 0) statement in __module_get().
> After fixing the SCTP bug in final tests runs with lot of traffic
> we still saw this bug message from time to time.
> Looking at the refcounting in sctp, does not show up any forgotten
> get module operation or some wrong put module calls.
> We added some debug code and this shows only, that the test case heavly
> change module_refcount(sctp) bacause the socket accept call also increase
> the module count (and the BUG always was triggered in the __module_get() here).
> If the socket close, it decrease the module refcount, so no problem here.
> Some times the refcount seems to go very high, very quickly and later
> goes down very quickly again, I think this occurs if the network stalls for
> some time (the test case try to saturate a GB networklink).
> So I had the idea that the bug is in the refcounting itself and not related
> to the sctp code.
> After looking closer at __module_get() and module_refcount(module) it looks
> as I'm right, but I can not belive that this bug was not discovered before,
> the code is here since long time.
> The refcount is a per CPU atomic variable, module_refcount() simple add
> in a fully unprotected loop (not disabled irqs, not protected against
> scheduling) all per cpu values.
> 
> The issue is that so the process (it is as syscall from a userspace process)
> get scheduled in the middle of the counting loop, so it already has counted
> some per cpu vales, but not all.
> Now while the process is not active, other processes modify the counts, some
> accepts (== module gets) increase the count on already summed up CPUs,
> some other release sockets on CPUs, which are not already summed up.
> If the process become active again, it read the now decremented values from
> later CPUS, so the total count is too low and may reach zero, in which the above
> BUG_ON() will be triggered.
> 
> To prove this I replaced the BUG_ON with following code:
> 
>         if (module) {
> -               BUG_ON(module_refcount(module) == 0);
> +               unsigned int c = module_refcount(module);
> +
> +               if (unlikely(c == 0)) {
> +                       printk(KERN_ERR" module %s refcount=%x/%x\n", module->name, c,  module_refcount(module));
> +                       module_dump_refcounts(module);
> +                       WARN_ON(1);
> +               }
>                 local_inc(&module->ref[get_cpu()].count);
>                 put_cpu();
>         }
> 
> module_dump_refcounts() does print out the per cpu refcounts.
> If my idea is correct the second call to  module_refcount(module) should
> have a none zero value.
> 
> And indeed:
> 
> Feb  2 03:29:51 pingi5 kernel:  module sctp refcount=0/8e
> Feb  2 03:29:51 pingi5 kernel: CPU0 refcount:38562331
> Feb  2 03:29:51 pingi5 kernel: CPU1 refcount:-38562187
> Feb  2 03:29:51 pingi5 kernel: Badness in __module_get at include/linux/module.h:374
> Feb  2 03:29:51 pingi5 kernel:
> Feb  2 03:29:51 pingi5 kernel: Call Trace: <ffffffff802837c2>{sys_accept+212} <ffffffff8019c76f>{dput+44}
> Feb  2 03:29:51 pingi5 kernel:        <ffffffff8018704f>{__fput+355} <ffffffff801a0dff>{mntput_no_expire+29}
> Feb  2 03:29:51 pingi5 kernel:        <ffffffff801845df>{filp_close+92} <ffffffff8010adba>{system_call+126}
> 
> 
> Do my findings be correct, or do I miss something ?
> 
> A other thing is, why __module_get() should be used anyway, I think it was a
> optimation long time ago, current code seems to need more cycles on default
> SMP kernels as try_module_get(), because of the big loop  in module_refcount()
> which goes trough all possible CPUs (NR_CPU, 64 in default config).
> try_module_get() only has one test and one atomic increment.
> 
> 
> I think we should replace all unprotected __module_get() calls with
> try_module_get(), or remove __module_get() completely.
> 
> 
> Any comments ?
> 

Hi Karsten,

I've been seeing problems in a simple socket test harness that I think
has the same cause. I have several clients all calling a single socket
server on the same machine, under heavy load & after some time the
clients will fail to connect with -EADDRNOTAVAIL even though the server
is still running.

I changed the module ref count to be an atomic_t and the problem goes
away. I haven't tracked down the exact cause of the problem yet ( the
network code is kind of tricky!).

So I think you're right module_refcount() does need some sort of locking.

BTW On my desktop machine I cannot measure any significant performance
differences between the atomic_t refcount & the existing code, so it may
be that atomic_t will be good enough.

regards
Richard





