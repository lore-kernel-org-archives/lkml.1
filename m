Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZBWJSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZBWJSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbZBWJSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:18:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbZBWJSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:18:12 -0500
Date: Mon, 23 Feb 2009 01:17:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-Id: <20090223011712.853aa94d.akpm@linux-foundation.org>
In-Reply-To: <20090223090735.GH9582@elte.hu>
References: <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com>
	<20090220154619.GC6960@linux.vnet.ibm.com>
	<19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com>
	<20090221014056.GU6960@linux.vnet.ibm.com>
	<19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com>
	<20090221174703.GA6860@linux.vnet.ibm.com>
	<19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com>
	<19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com>
	<20090222030030.GD6860@linux.vnet.ibm.com>
	<20090223051709.GA5990@linux.vnet.ibm.com>
	<20090223090735.GH9582@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 10:07:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> > ---
> > 
> >  init/main.c         |    3 +++
> >  kernel/rcuclassic.c |    4 +++-
> >  kernel/rcutree.c    |    4 +++-
> >  3 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/init/main.c b/init/main.c
> > index 8442094..51f4b71 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -121,6 +121,8 @@ static char *static_command_line;
> >  static char *execute_command;
> >  static char *ramdisk_execute_command;
> >  
> > +int idle_task_is_really_idle;	/* set to 1 late in boot. */
> > +
> >  #ifdef CONFIG_SMP
> >  /* Setup configured maximum number of CPUs to activate */
> >  unsigned int __initdata setup_max_cpus = NR_CPUS;
> > @@ -463,6 +465,7 @@ static noinline void __init_refok rest_init(void)
> >  	 * at least once to get things moving:
> >  	 */
> >  	init_idle_bootup_task(current);
> > +	idle_task_is_really_idle = 1;
> >  	preempt_enable_no_resched();
> >  	schedule();
> >  	preempt_disable();
> 
> Could you please use system_state instead? We could insert a new 
> stage - or just use SYSTEM_RUNNING as the trigger.

I think the standalone flag is better (once those extern-decls-in-C get
fixed).

system_state's semantics have, err, evolved over time.  If this happens
again (and the patch sneaks past my attention) then there's a risk that
code which depends upon system_state will break - this has happened in
the past.  Plus piling more dependencies on system_state of course
makes any evolution of its semantics harder to do...

It seems safer/saner/more-robust to create the additional
application-specific global as Paul has done.  One more word of bss
won't kill us.  It adds a few more words of .text, but it's in __init.


