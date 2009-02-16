Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbZBPNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbZBPNWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZBPNWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:22:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbZBPNWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:22:06 -0500
Date: Mon, 16 Feb 2009 14:21:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216132151.GA17996@elte.hu>
References: <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain> <20090215110104.GB31351@elte.hu> <20090215180355.GA2273@localhost.localdomain> <20090215193102.GA16873@elte.hu> <20090216084223.GA2641@localhost.localdomain> <20090216095059.GL6182@elte.hu> <87hc2u61e9.fsf@free.fr> <20090216122632.GA3158@elte.hu> <87ljs6pmao.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljs6pmao.fsf@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Damien Wyart <damien.wyart@free.fr> wrote:

> * Ingo Molnar <mingo@elte.hu> [090216 13:26]:
> > We do get 0x100 which is 1 << RCU_SOFTIRQ, i.e. the RCU softirq. Paul, 
> > this indeed seems to be a CONFIG_TREE_RCU=y bug.
> 
> > What is weird is that RCU_SOFTIRQ gets set again and again - but there's 
> > no raise_softirq() calls. Could you please do a two-CPU trace too via:
> 
> >    echo 3 > /debug/tracing/tracing_cpumask
> 
> > So that we can see what's happening on the other CPU?
> 
> > Also, could you please apply the debug patch below (or update to the 
> > very latest -tip tree), so that we get trace entries of softirq triggers 
> > too?
> 
> Ok, the new trace with these additional modifications is here:
> http://damien.wyart.free.fr/ksoftirqd_pb/trace_tip_2009.02.16_1300_ksoftirqd_pb_abstime_proc_mask3.txt.gz

thanks.

This confirms that SOFTIRQ_RCU gets raised here in the timer IRQ:

  136.255963 |   0)   sleep-2345   |               |          update_process_times() {
  136.255964 |   0)   sleep-2345   |               |            account_process_tick() {
  136.255965 |   0)   sleep-2345   |   0.779 us    |              account_system_time();
  136.255966 |   0)   sleep-2345   |   2.262 us    |            }
  136.255967 |   0)   sleep-2345   |               |            run_local_timers() {
  136.255968 |   0)   sleep-2345   |   0.802 us    |              hrtimer_run_queues();
  136.255969 |   0)   sleep-2345   |               |              raise_softirq() {
  136.255970 |   0)   sleep-2345   |               |                raise_softirq_irqoff() {
  136.255971 |   0)   sleep-2345   |               |                  __raise_softirq_irqoff() {
  136.255972 |   0)   sleep-2345   |               |                    /* nr: 1 */
  136.255973 |   0)   sleep-2345   |   2.194 us    |                  }
  136.255974 |   0)   sleep-2345   |   3.832 us    |                }
  136.255975 |   0)   sleep-2345   |   5.491 us    |              }
  136.255976 |   0)   sleep-2345   |   8.667 us    |            }
  136.255976 |   0)   sleep-2345   |   0.792 us    |            rcu_pending();
  136.255978 |   0)   sleep-2345   |               |            rcu_check_callbacks() {
  136.255979 |   0)   sleep-2345   |   0.781 us    |              idle_cpu();
  136.255981 |   0)   sleep-2345   |               |              raise_softirq() {
  136.255981 |   0)   sleep-2345   |               |                raise_softirq_irqoff() {
  136.255982 |   0)   sleep-2345   |               |                  __raise_softirq_irqoff() {
  136.255983 |   0)   sleep-2345   |               |                    /* nr: 8 */
  136.255984 |   0)   sleep-2345   |   1.555 us    |                  }
  136.255984 |   0)   sleep-2345   |   3.059 us    |                }
  136.255985 |   0)   sleep-2345   |   4.594 us    |              }
  136.255986 |   0)   sleep-2345   |   7.800 us    |            }
  136.255987 |   0)   sleep-2345   |   0.737 us    |            printk_tick();

again and again.

	Ingo
