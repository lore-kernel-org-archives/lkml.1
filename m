Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZBJVv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZBJVv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbZBJVvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:51:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35215 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbZBJVvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:51:16 -0500
Date: Tue, 10 Feb 2009 22:48:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@googlemail.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Message-ID: <20090210214804.GB4257@redhat.com>
References: <20090209010233.GA26444@redhat.com> <20090209012824.GA26461@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com> <20090209193625.GA4808@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E4A1E82FE@irsmsx504.ger.corp.intel.com> <20090210184014.GA30545@redhat.com> <1234297319.6112.23.camel@raistlin> <1234299614.6112.55.camel@raistlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234299614.6112.55.camel@raistlin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Markus Metzger wrote:
>
> On Tue, 2009-02-10 at 21:21 +0100, Markus Metzger wrote:
> > On Tue, 2009-02-10 at 19:40 +0100, Oleg Nesterov wrote:
>
> > > Perhaps, for 2.6.29, we can do something like the "patch" below?
> > > 
> > > --- a/arch/x86/kernel/ptrace.c
> > > +++ b/arch/x86/kernel/ptrace.c
> > > @@ -810,11 +810,15 @@ static void ptrace_bts_untrace(struct ta
> > >  
> > >  static void ptrace_bts_detach(struct task_struct *child)
> > >  {
> > > +	// We can race with de_thread/do_wait which
> > > +	// can do ptrace_bts_untrace() before us
> > >  	if (unlikely(child->bts)) {
> > > -		ds_release_bts(child->bts);
> > > -		child->bts = NULL;
> > > -
> > > -		ptrace_bts_free_buffer(child);
> > > +		// This all will be freed by ptrace_bts_untrace()
> > > +		// later, but we should update ->mm
> > > +		down_write(->mmap_sem);
> > > +		mm->total_vm  -= bts_size;
> > > +		mm->locked_vm -= bts_size);
> > > +		up_write(->mmap_sem);
> > >  	}
> > >  }
> > >  #else
> > > 
> > 
>
> There's still a race.
> The kfree() is safe, now, but ptrace_bts_untrace() might have cleared
> child->bts_size before we can refund the memory.

Yes sure, please note the "We can race..." comment at the top
of ptrace_bts_detach().

The goal of this patch is to avoid the crash. The memory accounting
in ->mm is still not right. But at least, the tracer can not "steal"
the memory above the limits. And the "good" tracer should not exit
without detach, and it shouldn't release the tracee from sub-thread
if this can race with detach.

So, afaics, the worst thing which can happen is: the "bad" tracer
is punished by the "unfair" mm->xxx_vm numbers.

Except exec() can release the main thread whatever the tracer does...

> We need to make ptrace_bts_untrace() ignore child->bts_size and clear
> it in ptrace_bts_detach().

This is worse, now we can leak the memory if the tracer doesn't
do ptrace_detach().

Oleg.

