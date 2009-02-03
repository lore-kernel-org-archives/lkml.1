Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZBCNre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZBCNre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZBCNr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:47:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:49913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZBCNrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:47:25 -0500
Date: Tue, 3 Feb 2009 14:47:21 +0100
From: Karsten Keil <kkeil@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFC] Suspicious bug in module refcounting
Message-ID: <20090203134721.GA11069@pingi.kke.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.34-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While debugging a wired SCTP bug we hit from time to time
the BUG_ON(module_refcount(module) == 0) statement in __module_get().
After fixing the SCTP bug in final tests runs with lot of traffic
we still saw this bug message from time to time.
Looking at the refcounting in sctp, does not show up any forgotten
get module operation or some wrong put module calls.
We added some debug code and this shows only, that the test case heavly
change module_refcount(sctp) bacause the socket accept call also increase
the module count (and the BUG always was triggered in the __module_get() here).
If the socket close, it decrease the module refcount, so no problem here.
Some times the refcount seems to go very high, very quickly and later
goes down very quickly again, I think this occurs if the network stalls for
some time (the test case try to saturate a GB networklink).
So I had the idea that the bug is in the refcounting itself and not related
to the sctp code.
After looking closer at __module_get() and module_refcount(module) it looks
as I'm right, but I can not belive that this bug was not discovered before,
the code is here since long time.
The refcount is a per CPU atomic variable, module_refcount() simple add
in a fully unprotected loop (not disabled irqs, not protected against
scheduling) all per cpu values.

The issue is that so the process (it is as syscall from a userspace process)
get scheduled in the middle of the counting loop, so it already has counted
some per cpu vales, but not all.
Now while the process is not active, other processes modify the counts, some
accepts (== module gets) increase the count on already summed up CPUs,
some other release sockets on CPUs, which are not already summed up.
If the process become active again, it read the now decremented values from
later CPUS, so the total count is too low and may reach zero, in which the above
BUG_ON() will be triggered.

To prove this I replaced the BUG_ON with following code:

        if (module) {
-               BUG_ON(module_refcount(module) == 0);
+               unsigned int c = module_refcount(module);
+
+               if (unlikely(c == 0)) {
+                       printk(KERN_ERR" module %s refcount=%x/%x\n", module->name, c,  module_refcount(module));
+                       module_dump_refcounts(module);
+                       WARN_ON(1);
+               }
                local_inc(&module->ref[get_cpu()].count);
                put_cpu();
        }

module_dump_refcounts() does print out the per cpu refcounts.
If my idea is correct the second call to  module_refcount(module) should
have a none zero value.

And indeed:

Feb  2 03:29:51 pingi5 kernel:  module sctp refcount=0/8e
Feb  2 03:29:51 pingi5 kernel: CPU0 refcount:38562331
Feb  2 03:29:51 pingi5 kernel: CPU1 refcount:-38562187
Feb  2 03:29:51 pingi5 kernel: Badness in __module_get at include/linux/module.h:374
Feb  2 03:29:51 pingi5 kernel:
Feb  2 03:29:51 pingi5 kernel: Call Trace: <ffffffff802837c2>{sys_accept+212} <ffffffff8019c76f>{dput+44}
Feb  2 03:29:51 pingi5 kernel:        <ffffffff8018704f>{__fput+355} <ffffffff801a0dff>{mntput_no_expire+29}
Feb  2 03:29:51 pingi5 kernel:        <ffffffff801845df>{filp_close+92} <ffffffff8010adba>{system_call+126}


Do my findings be correct, or do I miss something ?

A other thing is, why __module_get() should be used anyway, I think it was a
optimation long time ago, current code seems to need more cycles on default
SMP kernels as try_module_get(), because of the big loop  in module_refcount()
which goes trough all possible CPUs (NR_CPU, 64 in default config).
try_module_get() only has one test and one atomic increment.


I think we should replace all unprotected __module_get() calls with
try_module_get(), or remove __module_get() completely.


Any comments ?


-- 
Karsten Keil
SuSE Labs
