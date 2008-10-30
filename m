Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYJ3VOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYJ3VOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYJ3VOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:14:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51017 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYJ3VOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:14:10 -0400
Date: Thu, 30 Oct 2008 17:14:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 2/2] ftrace: nmi update statistics
In-Reply-To: <20081030133852.11be15a8.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0810301709510.21031@gandalf.stny.rr.com>
References: <20081030200831.467420488@goodmis.org> <20081030201128.000197812@goodmis.org> <20081030133852.11be15a8.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Andrew Morton wrote:

> On Thu, 30 Oct 2008 16:08:33 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > This patch adds dynamic ftrace NMI update statistics to the
> > /debugfs/tracing/dyn_ftrace_total_info stat file.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  arch/x86/kernel/ftrace.c |   26 ++++++++++++++++++++++++--
> >  kernel/trace/trace.c     |   31 ++++++++++++++++++++++++-------
> 
> No header files were modified, but ftrace_arch_read_dyn_info() should
> have been declared so that the above two compilation units see the
> declaration.

Ah, you caught me being lazy ;-)  Since both also define the function, I 
figured I'd be OK. But you are right, this would prevent bugs where the
two functions somehow got different parameters.

Will fix.

> 
> > 
> > Index: linux-tip.git/arch/x86/kernel/ftrace.c
> > ===================================================================
> > --- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-10-30 15:30:12.000000000 -0400
> > +++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-10-30 15:51:51.000000000 -0400
> > @@ -91,6 +91,19 @@ static int mod_code_write;
> >  static void *mod_code_ip;
> >  static void *mod_code_newcode;
> >  
> > +static int nmi_wait_count;
> > +static atomic_t nmi_update_count;
> 
> <the ATOMIC_INIT thing>

Hmm, this being arch specific code, is there such a thing as "atomic 
declared as zero on x86 is OK" rule?

> 
> > +int ftrace_arch_read_dyn_info(char *buf, int size)
> > +{
> > +	int r;
> > +
> > +	r = snprintf(buf, size, "%u %u",
> > +		     nmi_wait_count,
> > +		     atomic_read(&nmi_update_count));
> > +	return r;
> > +}
> 
> Yes, nmi_wait_count is an unsigned quantity.  Might as well define it
> thusly?

OK.

> 
> >  static void ftrace_mod_code(void)
> >  {
> >  	/*
> > @@ -109,8 +122,10 @@ void ftrace_nmi_enter(void)
> >  	atomic_inc(&in_nmi);
> >  	/* Must have in_nmi seen before reading write flag */
> >  	smp_mb();
> > -	if (mod_code_write)
> > +	if (mod_code_write) {
> >  		ftrace_mod_code();
> > +		atomic_inc(&nmi_update_count);
> > +	}
> >  }
> >  
> >  void ftrace_nmi_exit(void)
> > @@ -122,8 +137,15 @@ void ftrace_nmi_exit(void)
> >  
> >  static void wait_for_nmi(void)
> >  {
> > -	while (atomic_read(&in_nmi))
> > +	int waited = 0;
> > +
> > +	while (atomic_read(&in_nmi)) {
> > +		waited = 1;
> >  		cpu_relax();
> > +	}
> > +
> > +	if (waited)
> > +		nmi_wait_count++;
> >  }
> >  
> >  static int
> > Index: linux-tip.git/kernel/trace/trace.c
> > ===================================================================
> > --- linux-tip.git.orig/kernel/trace/trace.c	2008-10-30 15:18:45.000000000 -0400
> > +++ linux-tip.git/kernel/trace/trace.c	2008-10-30 15:51:51.000000000 -0400
> > @@ -2837,22 +2837,39 @@ static struct file_operations tracing_ma
> >  
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> >  
> > +#define DYN_INFO_BUF_SIZE 1023
> > +static char ftrace_dyn_info_buffer[DYN_INFO_BUF_SIZE+1];
> 
> Could be made local to tracing_read_dyn_info().
> 
> 
> Could just be
> 
> 	static char ftrace_dyn_info_buffer[1024];
> 
> then use sizeof/ARRAY_SIZE elsewhere.  I think this is a bit safer and

I think there's a defined macro for that... (goes look)

Yep! it's called ARRAY_SIZE(arr)

> more readable - the reader doesn't have to run around the code checking
> that the correct #define was used in both places.

Will fix.

Thanks,

-- Steve
