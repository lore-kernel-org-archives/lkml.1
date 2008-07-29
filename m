Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbYG2Wl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbYG2Wl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbYG2WlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:41:19 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:51093 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756534AbYG2WlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:41:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0GALc3j0hMRKxB/2dsb2JhbACBW4lEphw
Date: Tue, 29 Jul 2008 18:41:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: module-placed markers/tracepoints
Message-ID: <20080729224115.GA5209@Krystal>
References: <20080717155724.897537670@polymtl.ca> <48862A30.7050701@qumranet.com> <y0mabg991c3.fsf@ton.toronto.redhat.com> <488635A7.2030609@qumranet.com> <20080722221204.GA14661@Krystal> <488C49CC.8040800@qumranet.com> <20080728005405.GA7941@Krystal> <20080729161836.GA10751@redhat.com> <20080729170151.GA24851@Krystal> <20080729211543.GB17097@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080729211543.GB17097@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:12:15 up 55 days,  2:53,  4 users,  load average: 1.05, 1.60,
	1.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi -
> 
> Some locals are wondering -- is there code for (or need for new code
> for) incrementing module reference counts while markers and/or
> tracepoints resident in modules have active clients?
> 
> - FChE

Hi Frank,

Probe module unloading is supposed to be done automatically assuming the
following module unload behavior :

1 - Module unload code takes the stop machine lock.
2 - It is assumed that the module exit function is called at that time,
  while no preempt-disabled section is executed. This function
  unregisters the callbacks.
3 - Given that preemption is disabled around tracepoint/marker calls, no
  calls are left to a freed module.

Actually, I notice that it might not be the case. I took for granted
what (I can't remember who ? Rusty ?) told me about module unload code.
If we look at sys_delete_module() :


        /* Stop the machine so refcounts can't move and disable module. */
        ret = try_stop_module(mod, flags, &forced);
        if (ret != 0)
                goto out;

        /* Never wait if forced. */
        if (!forced && module_refcount(mod) != 0)
                wait_for_zero_refcount(mod);

        mutex_unlock(&module_mutex);
        /* Final destruction now noone is using it. */
        if (mod->exit != NULL)
                mod->exit();

So we see that mod->exit(), which I believe is responsible for calling
the module exit() functions, is called after the stop_machine, not
during the stop machine.

Therefore, what would be needed here is to add a synchronize_sched()
after mod->exit() in module.c or after each tracepoint/marker unregister
in marker.c/tracepoint.c. However, I'd really prefer to add this to
module.c since adding this for _every_ unregister will slow down
processing or multiple probe unregistration too much.

Rusty, am I understanding that correctly ?

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
