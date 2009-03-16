Return-Path: <linux-kernel-owner+w=401wt.eu-S1759074AbZCPMmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074AbZCPMmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbZCPMmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:42:40 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:48306 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbZCPMmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FX9Njf76t8H97VH4o/4F7/P+zB0cX0mtH+XUFfLHm3Gk3LA8IE+H7+g7Lh39YTOZG9
         gZT0Mt9YVELdLDtLgqF0MVJKAiY8/oQa1sS7U5Z1etQv4y/gD8tjAF0DJ6SXJ80dXK+V
         +AxA1rQnIaUth7EmzjBjeQUk3c04MSQxW3FMI=
Date: Mon, 16 Mar 2009 13:42:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] ftrace: remove struct list_head from
	struct dyn_ftrace
Message-ID: <20090316124229.GB5096@nowhere>
References: <49BA2C9F.8020009@cn.fujitsu.com> <tip-e94142a67f8bad494c593f0a07c9fc2fbec98c0e@git.kernel.org> <20090316123607.GA5096@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316123607.GA5096@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 01:36:09PM +0100, Frederic Weisbecker wrote:
> On Fri, Mar 13, 2009 at 10:39:36AM +0000, Lai Jiangshan wrote:
> > Commit-ID:  e94142a67f8bad494c593f0a07c9fc2fbec98c0e
> > Gitweb:     http://git.kernel.org/tip/e94142a67f8bad494c593f0a07c9fc2fbec98c0e
> > Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
> > AuthorDate: Fri, 13 Mar 2009 17:51:27 +0800
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 13 Mar 2009 11:36:20 +0100
> > 
> > ftrace: remove struct list_head from struct dyn_ftrace
> > 
> > Impact: save memory
> > 
> > The struct dyn_ftrace table is very large, this patch will save
> > about 50%.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Steven Rostedt <srostedt@redhat.com>
> > LKML-Reference: <49BA2C9F.8020009@cn.fujitsu.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  include/linux/ftrace.h |    1 -
> >  kernel/trace/ftrace.c  |   14 ++++++++------
> >  2 files changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index c146c10..9d598bb 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -145,7 +145,6 @@ enum {
> >  };
> >  
> >  struct dyn_ftrace {
> > -	struct list_head	list;
> >  	unsigned long		ip; /* address of mcount call-site */
> >  	unsigned long		flags;
> >  	struct dyn_arch_ftrace	arch;
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index bf78a4c..90d5729 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -272,7 +272,7 @@ enum {
> >  
> >  static int ftrace_filtered;
> >  
> > -static LIST_HEAD(ftrace_new_addrs);
> > +static struct dyn_ftrace *ftrace_new_addrs;
> >  
> >  static DEFINE_MUTEX(ftrace_regex_lock);
> >  
> > @@ -409,8 +409,8 @@ ftrace_record_ip(unsigned long ip)
> >  		return NULL;
> >  
> >  	rec->ip = ip;
> > -
> > -	list_add(&rec->list, &ftrace_new_addrs);
> > +	rec->flags = (unsigned long)ftrace_new_addrs;
> > +	ftrace_new_addrs = rec;
> 
> 
> But... you are overwritting all the ftrace flags infrastructure by
> using it as a list pointer.
> 
> This is breaking dynamic tracing.


May be I'm wrong. May be I misunderstood this patch.
But I don't understand how flags can be used at the same time as a pointer
and as a flag value.

 
> >  
> >  	return rec;
> >  }
> > @@ -716,19 +716,21 @@ unsigned long		ftrace_update_tot_cnt;
> >  
> >  static int ftrace_update_code(struct module *mod)
> >  {
> > -	struct dyn_ftrace *p, *t;
> > +	struct dyn_ftrace *p;
> >  	cycle_t start, stop;
> >  
> >  	start = ftrace_now(raw_smp_processor_id());
> >  	ftrace_update_cnt = 0;
> >  
> > -	list_for_each_entry_safe(p, t, &ftrace_new_addrs, list) {
> > +	while (ftrace_new_addrs) {
> >  
> >  		/* If something went wrong, bail without enabling anything */
> >  		if (unlikely(ftrace_disabled))
> >  			return -1;
> >  
> > -		list_del_init(&p->list);
> > +		p = ftrace_new_addrs;
> > +		ftrace_new_addrs = (struct dyn_ftrace *)p->flags;
> > +		p->flags = 0L;
> >  
> >  		/* convert record (i.e, patch mcount-call with NOP) */
> >  		if (ftrace_code_disable(mod, p)) {
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

