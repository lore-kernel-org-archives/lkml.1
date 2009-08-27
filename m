Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbZH0C4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbZH0C4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZH0C4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:56:16 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36337 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZH0C4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A6XP0op7Epi5JaXlTR+HvMmlPQLqH7ZmkL56RlNekrwqQbRsJ9ZskYCZNWzoIXr7i5
         yjWZQDpwL37C+FJ9m2exqRGgpy87X1+afRvBP4uMlwVkXoOJPSYhBZrhpQsYTu6wU6zO
         hW4Q1O6ZFyHDoXnZ8vdHSGwHIwo8tADSNvOqI=
Date: Thu, 27 Aug 2009 04:56:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       =?utf-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 06/18] tracing: Ftrace dynamic ftrace_event_call support
Message-ID: <20090827025612.GF6759@nowhere>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251340337-5640-7-git-send-email-fweisbec@gmail.com> <4A95F3BC.3080502@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A95F3BC.3080502@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 10:47:24AM +0800, Li Zefan wrote:
> > -int trace_define_field(struct ftrace_event_call *call, const char *type,
> > -		       const char *name, int offset, int size, int is_signed,
> > +int trace_define_field(struct ftrace_event_call *call, char *type,
> > +		       char *name, int offset, int size, int is_signed,
> >  		       int filter_type)
> 
> I don't see why you remove "const"? 



Because kprobes uses dynamically allocated strings as names.
That said, I should turn it back to const, it's indeed more sane.
I don't remember exactly the reason of this. I had to resolve several
conflicts between Masami's patchset and tracing/core, but I did
wrong in this part, indeed.


 
> >  {
> >  	struct ftrace_event_field *field;
> > @@ -92,9 +92,7 @@ int trace_define_common_fields(struct ftrace_event_call *call)
> >  }
> >  EXPORT_SYMBOL_GPL(trace_define_common_fields);
> 
> ...
> 
> >  	for (i = 0; i < meta->nb_args; i++) {
> > -		ret = trace_define_field(call, meta->types[i],
> > -					 meta->args[i], offset,
> > +		ret = trace_define_field(call, (char *)meta->types[i],
> > +					 (char *)meta->args[i], offset,
> 
> This is not good..


Yeah.


> 
> >  					 sizeof(unsigned long), 0,
> >  					 FILTER_OTHER);
> >  		offset += sizeof(unsigned long);
> > @@ -277,13 +277,13 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
> >  		trace_current_buffer_unlock_commit(event, 0, 0);
> >  }
> 
> ...
> 
> > -int reg_event_syscall_exit(void *ptr)
> > +int reg_event_syscall_exit(struct ftrace_event_call *call)
> >  {
> >  	int ret = 0;
> >  	int num;
> >  	char *name;
> >  
> > -	name = (char *)ptr;
> > +	name = (char *)call->data;
> 
> nitpick: implicit cast is fine.
> 
> >  	num = syscall_name_to_nr(name);
> >  	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
> >  		return -ENOSYS;
> > @@ -342,12 +342,12 @@ int reg_event_syscall_exit(void *ptr)
> >  	return ret;
> >  }
> >  
> > -void unreg_event_syscall_exit(void *ptr)
> > +void unreg_event_syscall_exit(struct ftrace_event_call *call)
> >  {
> >  	int num;
> >  	char *name;
> >  
> > -	name = (char *)ptr;
> > +	name = (char *)call->data;
> 
> ditto


Ok, I'll send a delta patch to fix these.

Thanks.


> 
> >  	num = syscall_name_to_nr(name);
> >  	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
> >  		return;

