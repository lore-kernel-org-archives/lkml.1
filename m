Return-Path: <linux-kernel-owner+w=401wt.eu-S1758807AbYJILua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807AbYJILua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 07:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYJILuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 07:50:22 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52048 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756356AbYJILuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 07:50:21 -0400
Date: Thu, 9 Oct 2008 04:50:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl,
       dipankar@in.ibm.com, tglx@linuxtronix.de, andi@firstfloor.org
Subject: Re: [PATCH] rudimentary tracing for Classic RCU
Message-ID: <20081009115018.GB6628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com> <20081007210947.GP20740@one.firstfloor.org> <20081007212215.GN6384@linux.vnet.ibm.com> <20081009010846.GA10188@linux.vnet.ibm.com> <48EDA2A6.9070707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EDA2A6.9070707@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 02:20:22PM +0800, Lai Jiangshan wrote:

Thank you for looking this over!

> Paul E. McKenney wrote:

[ . . . ]

> > diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> > index 9fdba03..ba32338 100644
> > --- a/kernel/Kconfig.preempt
> > +++ b/kernel/Kconfig.preempt
> > @@ -68,7 +68,6 @@ config PREEMPT_RCU
> >  
> >  config RCU_TRACE
> >  	bool "Enable tracing for RCU - currently stats in debugfs"
> > -	depends on PREEMPT_RCU
> >  	select DEBUG_FS
> >  	default y
> >  	help
> 
> I think that we can move it to lib/Kconfig.debug.

Makes sense!

[ . . . ]

> > +static int __init rcuclassic_trace_init(void)
> > +{
> > +	int ret;
> > +
> > +	rcuclassic_trace_buf = kmalloc(RCUCLASSIC_TRACE_BUF_SIZE, GFP_KERNEL);
> 
> I'm wondering about this.
> rcuclassic_trace_buf is kmalloc-ed when init module.
> 
> In this case, why not define it as:
> static char buf[20*NR_CPUS + 100];
> 
> and use it like:
> pos += snprintf(buf + cnt, sizeof(buf) - cnt, ...);

I will make Andi's suggested change, both here and in other previously
submitted code.

[ . . . ]

> > +	if (!rcuclassic_trace_buf)
> > +		return 1;
> > +	ret = rcuclassic_debugfs_init();
> > +	if (ret)
> > +		kfree(rcuclassic_trace_buf);
> > +	return ret;
> > +}
> > +
> > +static void __exit rcuclassic_trace_cleanup(void)
> > +{
> > +	debugfs_remove(cbdir);
> > +	debugfs_remove(rcudir);
> > +	kfree(rcuclassic_trace_buf);
> > +}
> > +
> > +
> > +module_init(rcuclassic_trace_init);
> > +module_exit(rcuclassic_trace_cleanup);
> 
> 
> I think this trace file shows too little vars for classic rcu.
> 
> It is better that this trace file shows more data.
> such as some data in struct rcu_data(quiescent state handling fields, batch, qlen).
> 
> or add new files: rcu/rcu_data<cpu#>

Indeed!  I will add the ability to dump the rcu_data structures, though
I was planning to just dump all of them rather than CPU-by-CPU.  (Same
approach as in rcutree_trace.c patches.)

							Thanx, Paul
