Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZLVHo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZLVHo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 02:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZLVHo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 02:44:56 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56141 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZLVHo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 02:44:56 -0500
Date: Mon, 21 Dec 2009 23:44:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/11] SYSCTL: Add proc_rcu_string to manage sysctls
	using rcu strings
Message-ID: <20091222074459.GC9279@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091221220.243954235@firstfloor.org> <20091221012024.A0828B158A@basil.firstfloor.org> <20091222025131.GB9279@linux.vnet.ibm.com> <m18wcvaf1f.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18wcvaf1f.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 07:00:44PM -0800, Eric W. Biederman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > On Mon, Dec 21, 2009 at 02:20:24AM +0100, Andi Kleen wrote:
> >> 
> >> Add a helper to use the new rcu strings for managing access
> >> to text sysctls. Conversions will be in follow-on patches.
> >> 
> >> An alternative would be to use seqlocks here, but RCU seemed
> >> cleaner.
> >> 
> >> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> >
> > Using the below as an example of my concern about access_rcu_string(), FYI.
> >
> >> ---
> >>  include/linux/sysctl.h |    2 +
> >>  kernel/sysctl.c        |   66 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>  kernel/sysctl_check.c  |    1 
> >>  3 files changed, 69 insertions(+)
> >> 
> >> Index: linux-2.6.33-rc1-ak/include/linux/sysctl.h
> >> ===================================================================
> >> --- linux-2.6.33-rc1-ak.orig/include/linux/sysctl.h
> >> +++ linux-2.6.33-rc1-ak/include/linux/sysctl.h
> >> @@ -969,6 +969,8 @@ typedef int proc_handler (struct ctl_tab
> >> 
> >>  extern int proc_dostring(struct ctl_table *, int,
> >>  			 void __user *, size_t *, loff_t *);
> >> +extern int proc_rcu_string(struct ctl_table *, int,
> >> +			 void __user *, size_t *, loff_t *);
> >>  extern int proc_dointvec(struct ctl_table *, int,
> >>  			 void __user *, size_t *, loff_t *);
> >>  extern int proc_dointvec_minmax(struct ctl_table *, int,
> >> Index: linux-2.6.33-rc1-ak/kernel/sysctl.c
> >> ===================================================================
> >> --- linux-2.6.33-rc1-ak.orig/kernel/sysctl.c
> >> +++ linux-2.6.33-rc1-ak/kernel/sysctl.c
> >> @@ -50,6 +50,7 @@
> >>  #include <linux/ftrace.h>
> >>  #include <linux/slow-work.h>
> >>  #include <linux/perf_event.h>
> >> +#include <linux/rcustring.h>
> >> 
> >>  #include <asm/uaccess.h>
> >>  #include <asm/processor.h>
> >> @@ -2016,6 +2017,60 @@ static int _proc_do_string(void* data, i
> >>  }
> >> 
> >>  /**
> >> + * proc_rcu_string - sysctl string with rcu protection
> >> + * @table: the sysctl table
> >> + * @write: %TRUE if this is a write to the sysctl file
> >> + * @buffer: the user buffer
> >> + * @lenp: the size of the user buffer
> >> + * @ppos: file position
> >> + *
> >> + * Handle a string sysctl similar to proc_dostring.
> >> + * The main difference is that the data pointer in the table
> >> + * points to a pointer to a string. The string should be initially
> >> + * pointing to a statically allocated (as a C object, not on the heap)
> >> + * default. When it is replaced old uses will be protected by
> >> + * RCU. The reader should use rcu_read_lock()/unlock() or
> >> + * access_rcu_string().
> >> + */
> >> +int proc_rcu_string(struct ctl_table *table, int write,
> >> +		void __user *buffer, size_t *lenp, loff_t *ppos)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (write) {
> >> +		/* protect writers against each other */
> >> +		static DEFINE_MUTEX(rcu_string_mutex);
> >> +		char *old;
> >> +		char *new;
> >> +
> >> +		new = alloc_rcu_string(table->maxlen, GFP_KERNEL);
> >> +		if (!new)
> >> +			return -ENOMEM;
> >> +		mutex_lock(&rcu_string_mutex);
> >> +		old = *(char **)(table->data);
> >> +		strcpy(new, old);
> >> +		ret = _proc_do_string(new, table->maxlen, write, buffer, lenp, ppos);
> >> +		rcu_assign_pointer(*(char **)(table->data), new);
> >> +		/*
> >> +		 * For the first initialization allow constant strings.
> >> +		 */
> >> +		if (!kernel_address((unsigned long)old))
> >> +			free_rcu_string(old);
> >> +		mutex_unlock(&rcu_string_mutex);
> >> +	} else {
> >> +		char *str;
> >> +
> >> +		str = access_rcu_string(*(char **)(table->data), table->maxlen,
> >> +					GFP_KERNEL);
> >
> > So the above statement picks up table->data, then some other CPU comes
> > in and executes the "write" side of this "if" statement, we get
> > preempted before access_rcu_string() enters its RCU read-side critical
> > section, the grace period elapse, we resume, and ... ouch!
> >
> > One trick would be to make access_rcu_string() be a macro that does
> > first access to its first argument in an RCU read-side critical section.
> > Alternatively, pass in the address of the pointer, rather than the
> > pointer itself.
> >
> > Or explain to me how I am confused.
> 
> That sounds correct to me.  There is also the missing rcu_dereference.
> 
> Which is less important but it would make clear that access_rcu_string
> does the dereference outside of the rcu critical section.

Good point, there does indeed need to be an rcu_dereference() in any case.

							Thanx, Paul
