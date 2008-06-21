Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYFUB5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYFUB5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 21:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYFUB5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 21:57:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15830 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYFUB5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 21:57:34 -0400
Date: Fri, 20 Jun 2008 18:39:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       josh@freedesktop.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] Make rcutorture more vicious: reinstate boot-time
 testing
Message-Id: <20080620183916.e7be2cea.randy.dunlap@oracle.com>
In-Reply-To: <20080620054724.GA21460@linux.vnet.ibm.com>
References: <20080618122144.GA27143@linux.vnet.ibm.com>
	<20080618162649.GA18326@linux.vnet.ibm.com>
	<20080619092914.GB15228@elte.hu>
	<20080619155854.GA5084@linux.vnet.ibm.com>
	<20080619141725.2d231fc1.randy.dunlap@oracle.com>
	<20080620054724.GA21460@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 22:47:24 -0700 Paul E. McKenney wrote:

> On Thu, Jun 19, 2008 at 02:17:25PM -0700, Randy Dunlap wrote:
> > On Thu, 19 Jun 2008 08:58:54 -0700 Paul E. McKenney wrote:
> > 
> > > On Thu, Jun 19, 2008 at 11:29:14AM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > Hello again!
> > > > > 
> > > 
> > >  Documentation/RCU/torture.txt      |   21 
> > >  Documentation/RCU/torture.txt.orig |    8 
> >                                 ~~~~~
> > 
> > >  kernel/rcutorture.c                |   14 
> > >  kernel/rcutorture.c.orig           |   59 
> >                        !!!!
> > 
> > >  kernel/sysctl.c                    |   13 
> > >  kernel/sysctl.c.orig               | 2851 +++++++++++++++++++++++++++++++++++++
> >                    ~~~~
> > 
> > >  lib/Kconfig.debug                  |   20 
> > >  lib/Kconfig.debug.orig             |  679 ++++++++
> >                      ~~~~
> > 
> > What's with all of these .orig files, eh??
> 
> Gah, typos generating the diffs.  :-/
> 
> > >  8 files changed, 3651 insertions(+), 14 deletions(-)
> 
> How about the following instead?  (I expect to be following up with
> a version that gets rid of the threads in response to writing a "0"
> to /proc/sys/kernel/rcutorture_runnable later on.)

Yes, much better.  Thanks.

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  Documentation/RCU/torture.txt |   21 ++++++++++++++-------
>  kernel/rcutorture.c           |   14 ++++++++++++--
>  kernel/sysctl.c               |   13 +++++++++++++
>  lib/Kconfig.debug             |   20 +++++++++++++++++++-
>  4 files changed, 58 insertions(+), 10 deletions(-)
> 
> diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt linux-2.6.26-rc4-rcut2-proc/Documentation/RCU/torture.txt
> --- linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt	2008-06-18 05:15:43.000000000 -0700
> +++ linux-2.6.26-rc4-rcut2-proc/Documentation/RCU/torture.txt	2008-06-18 08:11:19.000000000 -0700
> @@ -10,13 +10,20 @@ status messages via printk(), which can 
>  command (perhaps grepping for "torture").  The test is started
>  when the module is loaded, and stops when the module is unloaded.
>  
> -However, actually setting this config option to "y" results in the system
> -running the test immediately upon boot, and ending only when the system
> -is taken down.  Normally, one will instead want to build the system
> -with CONFIG_RCU_TORTURE_TEST=m and to use modprobe and rmmod to control
> -the test, perhaps using a script similar to the one shown at the end of
> -this document.  Note that you will need CONFIG_MODULE_UNLOAD in order
> -to be able to end the test.
> +CONFIG_RCU_TORTURE_TEST_RUNNABLE
> +
> +It is also possible to specify CONFIG_RCU_TORTURE_TEST=y, which will
> +result in the tests being loaded into the base kernel.  In this case,
> +the CONFIG_RCU_TORTURE_TEST_RUNNABLE config option is used to specify
> +whether the RCU torture tests are to be started immediately during
> +boot or whether the /proc/sys/kernel/rcutorture_runnable file is used
> +to enable them.  This /proc file can be used to repeatedly pause and
> +restart the tests, regardless of the initial state specified by the
> +CONFIG_RCU_TORTURE_TEST_RUNNABLE config option.
> +
> +You will normally -not- want to start the RCU torture tests during boot
> +(and thus the default is CONFIG_RCU_TORTURE_TEST_RUNNABLE=n), but doing
> +this can sometimes be useful in finding boot-time bugs.
>  
>  
>  MODULE PARAMETERS
> diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c
> --- linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c	2008-06-18 04:54:41.000000000 -0700
> +++ linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c	2008-06-19 04:48:56.000000000 -0700
> @@ -125,6 +125,13 @@ static struct list_head rcu_torture_remo
>  
>  static int stutter_pause_test = 0;
>  
> +#if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
> +#define RCUTORTURE_RUNNABLE_INIT 1
> +#else
> +#define RCUTORTURE_RUNNABLE_INIT 0
> +#endif
> +int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
> +
>  /*
>   * Allocate an element from the rcu_tortures pool.
>   */
> @@ -188,8 +195,11 @@ rcu_random(struct rcu_random_state *rrsp
>  static void
>  rcu_stutter_wait(void)
>  {
> -	while (stutter_pause_test)
> -		schedule_timeout_interruptible(1);
> +	while (stutter_pause_test || !rcutorture_runnable)
> +		if (rcutorture_runnable)
> +			schedule_timeout_interruptible(1);
> +		else
> +			schedule_timeout_interruptible(HZ);
>  }
>  
>  /*
> diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut1-stutter/kernel/sysctl.c linux-2.6.26-rc4-rcut2-proc/kernel/sysctl.c
> --- linux-2.6.26-rc4-rcut1-stutter/kernel/sysctl.c	2008-05-30 04:39:01.000000000 -0700
> +++ linux-2.6.26-rc4-rcut2-proc/kernel/sysctl.c	2008-06-18 07:35:26.000000000 -0700
> @@ -82,6 +82,9 @@ extern int maps_protect;
>  extern int sysctl_stat_interval;
>  extern int latencytop_enabled;
>  extern int sysctl_nr_open_min, sysctl_nr_open_max;
> +#ifdef CONFIG_RCU_TORTURE_TEST
> +extern int rcutorture_runnable;
> +#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
>  
>  /* Constants used for minimum and  maximum */
>  #if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
> @@ -813,6 +816,16 @@ static struct ctl_table kern_table[] = {
>  		.child		= key_sysctls,
>  	},
>  #endif
> +#ifdef CONFIG_RCU_TORTURE_TEST
> +	{
> +		.ctl_name       = CTL_UNNUMBERED,
> +		.procname       = "rcutorture_runnable",
> +		.data           = &rcutorture_runnable,
> +		.maxlen         = sizeof(int),
> +		.mode           = 0644,
> +		.proc_handler   = &proc_dointvec,
> +	},
> +#endif
>  /*
>   * NOTE: do not add new entries to this table unless you have read
>   * Documentation/sysctl/ctl_unnumbered.txt
> diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut1-stutter/lib/Kconfig.debug linux-2.6.26-rc4-rcut2-proc/lib/Kconfig.debug
> --- linux-2.6.26-rc4-rcut1-stutter/lib/Kconfig.debug	2008-05-30 04:39:01.000000000 -0700
> +++ linux-2.6.26-rc4-rcut2-proc/lib/Kconfig.debug	2008-06-18 06:32:48.000000000 -0700
> @@ -531,16 +531,34 @@ config BOOT_PRINTK_DELAY
>  config RCU_TORTURE_TEST
>  	tristate "torture tests for RCU"
>  	depends on DEBUG_KERNEL
> -	depends on m
>  	default n
>  	help
>  	  This option provides a kernel module that runs torture tests
>  	  on the RCU infrastructure.  The kernel module may be built
>  	  after the fact on the running kernel to be tested, if desired.
>  
> +	  Say Y here if you want RCU torture tests to be built into
> +	  the kernel.
>  	  Say M if you want the RCU torture tests to build as a module.
>  	  Say N if you are unsure.
>  
> +config RCU_TORTURE_TEST_RUNNABLE
> +	bool "torture tests for RCU runnable by default"
> +	depends on RCU_TORTURE_TEST = y
> +	default n
> +	help
> +	  This option provides a way to build the RCU torture tests
> +	  directly into the kernel without them starting up at boot
> +	  time.  You can use /proc/sys/kernel/rcutorture_runnable
> +	  to manually override this setting.  This /proc file is
> +	  available only when the RCU torture tests have been built
> +	  into the kernel.
> +
> +	  Say Y here if you want the RCU torture tests to start during
> +	  boot (you probably don't).
> +	  Say N here if you want the RCU torture tests to start only
> +	  after being manually enabled via /proc.
> +
>  config KPROBES_SANITY_TEST
>  	bool "Kprobes sanity tests"
>  	depends on DEBUG_KERNEL
> --

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
