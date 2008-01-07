Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYAGToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYAGToT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYAGToL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:44:11 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:42305 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbYAGToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:44:09 -0500
Date: Tue, 8 Jan 2008 01:13:36 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>, mingo@elte.hu,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com,
       paulmck@linux.vnet.ibm.com, rostedt@goodmis.org
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost Tracing
Message-ID: <20080107194336.GA4556@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20071231060911.GB6461@in.ibm.com> <20080103163055.GB27651@Krystal> <20080104105858.GA13865@in.ibm.com> <20080105124632.GA16576@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105124632.GA16576@Krystal>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 07:46:32AM -0500, Mathieu Desnoyers wrote:
> * Gautham R Shenoy (ego@in.ibm.com) wrote:
> > On Thu, Jan 03, 2008 at 11:30:55AM -0500, Mathieu Desnoyers wrote:
> > > * K. Prasad (prasad@linux.vnet.ibm.com) wrote:
> > > > This patch converts the tracing mechanism of Preempt RCU boosting into
> > > > markers. The handler functions for these markers are included inside
> > > > rcupreempt_trace.c and will be included only when PREEMPT_RCU_BOOST is
> > > > chosen.
> > > >  
> > > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > > ---
> > > >  include/linux/rcupreempt_trace.h |   46 ++++++++
> > > >  kernel/rcupreempt-boost.c        |  211 ++++-----------------------------------
> > > >  kernel/rcupreempt_trace.c        |  183 +++++++++++++++++++++++++++++++++
> > > >  3 files changed, 251 insertions(+), 189 deletions(-)
> > > >  
> > > > Index: linux-2.6.24-rc2-rt1.MARKER_PATCHES_NEW/include/linux/rcupreempt_trace.h
> > > > ===================================================================
> > > > --- linux-2.6.24-rc2-rt1.MARKER_PATCHES_NEW.orig/include/linux/rcupreempt_trace.h
> > > > +++ linux-2.6.24-rc2-rt1.MARKER_PATCHES_NEW/include/linux/rcupreempt_trace.h
> > > > @@ -102,5 +102,51 @@ extern int rcupreempt_flip_flag(int cpu)
> > > >  extern int rcupreempt_mb_flag(int cpu);
> > > >  extern char *rcupreempt_try_flip_state_name(void);
> > > >  
> > > > +#ifdef CONFIG_PREEMPT_RCU_BOOST
> > > > +struct preempt_rcu_boost_trace {
> > > > +	unsigned long rbs_stat_task_boost_called;
> > > > +	unsigned long rbs_stat_task_boosted;
> > > > +	unsigned long rbs_stat_boost_called;
> > > > +	unsigned long rbs_stat_try_boost;
> > > > +	unsigned long rbs_stat_boosted;
> > > > +	unsigned long rbs_stat_unboost_called;
> > > > +	unsigned long rbs_stat_unboosted;
> > > > +	unsigned long rbs_stat_try_boost_readers;
> > > > +	unsigned long rbs_stat_boost_readers;
> > > > +	unsigned long rbs_stat_try_unboost_readers;
> > > > +	unsigned long rbs_stat_unboost_readers;
> > > > +	unsigned long rbs_stat_over_taken;
> > > > +};
> > > > +
> > > > +#define DEFINE_PREEMPT_RCU_BOOST_MARKER_HANDLER(preempt_rcu_boost_var) \
> > > > +void preempt_rcu_boost_var##_callback(const struct marker *mdata, \
> > > > +				void *private_data, const char *format, ...) \
> > > > +{ \
> > > > +	va_list ap; \
> > > > +	int cpu; \
> > > > +	struct preempt_rcu_boost_trace *boost_trace; \
> > > > +	va_start(ap, format); \
> > > > +	cpu = va_arg(ap, typeof(unsigned int)); \
> > > 
> > > (sorry for late response, I just came back from vacation)
> > > 
> > > Instead of passing the cpu id as a marker parameter, why don't you
> > > simply use smp_processor_id() right here ?
> > > 
> > 
> > Agreed. 
> > 
> > Also in patch 1, in cases where we're using markers in place of RCU_TRACE_ME(), 
> > we need not pass the parameter and simply use smp_processor_id().
> > 
> > It's only the RCU_TRACE_RDP() that requires cpuid to be passed.
> > 
> 
> 
> And it would help if you declare the format string with something like :
> 
> "cpuid %u" instead of "%u"
> 
> This way, if a generic tracer like LTTng dumps the traces and later a
> plugin in an analysis tool like LTTV have to hook on a specific field of
> your event, it can access it by specifying the marker name and field
> name. And even if fields are added to this event, it won't break
> compatibility as long as this field is there and have the same name.
> 
> Mathieu

Hi Mathieu,
	Thanks for your suggestions.

Even in functions such as rcu_check_callbacks_rt, rcu_advance_callbacks_rt and
__rcu_advance_callbacks, where a call to RCU_TRACE_RDP() is made, the
'cpu' variable is populated at an early stage with the
return value of smp_processor_id().

__rcu_advance_callbacks() <-- rcu_check_callbacks_rt() <--
rcu_check_callbacks() <-- update_process_times().

update_process_times() [if understood correctly, is called at timer
interrupt level] populates the 'cpu' with smp_processor_id().

There doesn't seem to be a need to pass down the 'cpu' parameter for
the above RCU functions including respective trace_mark() calls.

I am re-sending the patches with your suggested changes in subsequent
mails.

Thanks,
K.Prasad

> 
> > 
> > Thanks and Regards
> > gautham.
> > 
> > 
> > > -- 
> > > Mathieu Desnoyers
> > > Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > -- 
> > Gautham R Shenoy
> > Linux Technology Center
> > IBM India.
> > "Freedom comes with a price tag of responsibility, which is still a bargain,
> > because Freedom is priceless!"
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
