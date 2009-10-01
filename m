Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZJAM6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZJAM6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZJAM6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:58:19 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:50291 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094AbZJAM6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 08:58:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAPRBxEpMROOX/2dsb2JhbACBUNUIhCkE
Date: Thu, 1 Oct 2009 08:58:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rostedt@goodmis.org, ak@suse.de, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com
Subject: Re: [PATCH 1/4] jump label - make init_kernel_text() global
Message-ID: <20091001125821.GC6640@Krystal>
References: <cover.1253831945.git.jbaron@redhat.com> <77d69d0f3c8e1f98a4c2392ea4e4f6c25ed177f4.1253831946.git.jbaron@redhat.com> <20091001112003.GA2962@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091001112003.GA2962@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:54:37 up 43 days, 23:44,  2 users,  load average: 0.14, 0.22,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Jason Baron <jbaron@redhat.com> wrote:
> 
> > allow usage of init_kernel_text - we need this in jump labeling to 
> > avoid attemtpting to patch code that has been freed as in the __init 
> > sections
> 
> s/attemtpting/attempting
> 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > ---
> >  include/linux/kernel.h |    1 +
> >  kernel/extable.c       |    2 +-
> >  2 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index f61039e..9d3419f 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -295,6 +295,7 @@ extern int get_option(char **str, int *pint);
> >  extern char *get_options(const char *str, int nints, int *ints);
> >  extern unsigned long long memparse(const char *ptr, char **retptr);
> >  
> > +extern int init_kernel_text(unsigned long addr);
> >  extern int core_kernel_text(unsigned long addr);
> >  extern int __kernel_text_address(unsigned long addr);
> >  extern int kernel_text_address(unsigned long addr);
> > diff --git a/kernel/extable.c b/kernel/extable.c
> > index 7f8f263..f6893ad 100644
> > --- a/kernel/extable.c
> > +++ b/kernel/extable.c
> > @@ -52,7 +52,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
> >  	return e;
> >  }
> >  
> > -static inline int init_kernel_text(unsigned long addr)
> > +int init_kernel_text(unsigned long addr)
> >  {
> >  	if (addr >= (unsigned long)_sinittext &&
> >  	    addr <= (unsigned long)_einittext)
> 
> i'm confused. Later on jump_label_update() does:
> 
> +                       if (!(system_state == SYSTEM_RUNNING &&
> +                                       (init_kernel_text(iter->code))))
> +                               jump_label_transform(iter, type);
> 
> which is:
> 
> +                       if (system_state != SYSTEM_RUNNING ||
> +                                       !init_kernel_text(iter->code)))
> +                               jump_label_transform(iter, type);
> 
> What is the logic behind that? System going into SYSTEM_RUNNING does not 
> coincide with free_initmem() precisely.
> 
> Also, do we ever want to patch init-text tracepoints? I think we want to 
> stay away from them as much as possible.

My experience with tracepoint instruentation is that as soon as we start
using them in inline functions (e.g. memory allocation, interrupt
entry/exit), we start making these functions unusable in init code. That
a very unwelcome side-effect that I'd like to prevent by making sure
tracepoints and the patching mechanism underneath supports init code
patching. Node that it does not have to be complicated.

But I think you are right that the logic seems fuzzy in this specific
spot of the patch.

Thanks,

Mathieu

> 
> It appears to me that what we want here is a straight:
> 
>                        if (kernel_text(iter->code))
>                                jump_label_transform(iter, type);
> 
> Also, maybe a WARN_ONCE(!kernel_text()) - we should never even attempt 
> to transform non-patchable code. If yes then we want to know about that 
> in a noisy way and not skip it silently.
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
