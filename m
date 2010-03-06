Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0CFBp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 20:45:58 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:49414 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0CFBp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 20:45:57 -0500
Date: Fri, 5 Mar 2010 17:45:13 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH tip/core/rcu 1/3] ftrace: replace
 read_barrier_depends() with rcu_dereference_raw()
Message-ID: <20100306014513.GA13858@feather>
References: <20100305230256.GA9410@linux.vnet.ibm.com>
 <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1267838945.10871.1786.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267838945.10871.1786.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 08:29:05PM -0500, Steven Rostedt wrote:
> On Fri, 2010-03-05 at 15:03 -0800, Paul E. McKenney wrote:
> > Replace the calls to read_barrier_depends() in ftrace_list_func() with
> > rcu_dereference_raw() to improve readability.  The reason that we use
> > rcu_dereference_raw() here is that removed entries are never freed,
> > instead they are simply leaked.  This is one of a very few cases where
> > use of rcu_dereference_raw() is the long-term right answer.  And I don't
> > yet know of any others.  ;-)
> > 
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Thanks Paul!
> 
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> 
> >  
> > @@ -154,8 +159,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
> >  	 * the ops->next pointer is valid before another CPU sees
> >  	 * the ops pointer included into the ftrace_list.
> >  	 */
> > -	smp_wmb();
> > -	ftrace_list = ops;
> > +	rcu_assign_pointer(ftrace_list, ops);
> 
> [ Off topic ]
> 
> I looked at rcu_assign_pointer() and it is:
> 
> #define rcu_assign_pointer(p, v) \
> 	({ \
> 		if (!__builtin_constant_p(v) || \
> 		    ((v) != NULL)) \
> 			smp_wmb(); \
> 		(p) = (v); \
> 	})
> 
> My question is, why that crazy if? The only time that will fail is if we
> are assigning the constant NULL to p. What makes NULL so important here?
> Can't there be a case when assigning NULL to p will require that wmb()?

The barrier ensures that the reader can't see the new p and the old
*p.  Since you can't look at *NULL, that concern doesn't apply.

- Josh Triplett
