Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZBJVAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZBJVAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZBJVA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:00:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:29911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZBJVA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PvfmlTqhOkiTfKi/3iV8u9GZSCAFTULqRnSj0HAJXy3UVh6UCABauAbhTq9HPQwJSO
         Lzs+H4y7p7b1YQLUoPnEP52Vg5e0tPyWkUxbY69ZQyxAOCnSpJx7iVacqXA5PxqN2y+Y
         j1qNFZqwC7S4I+dINrWPFyHAMFcmBaN9oULKk=
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Markus Metzger <markus.t.metzger@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1234297319.6112.23.camel@raistlin>
References: <20090209010233.GA26444@redhat.com>
	 <20090209012824.GA26461@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E4A1E7C8B@irsmsx504.ger.corp.intel.com>
	 <20090209193625.GA4808@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E4A1E82FE@irsmsx504.ger.corp.intel.com>
	 <20090210184014.GA30545@redhat.com>  <1234297319.6112.23.camel@raistlin>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 22:00:14 +0100
Message-Id: <1234299614.6112.55.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 21:21 +0100, Markus Metzger wrote:
> On Tue, 2009-02-10 at 19:40 +0100, Oleg Nesterov wrote:

> > Perhaps, for 2.6.29, we can do something like the "patch" below?
> > 
> > --- a/arch/x86/kernel/ptrace.c
> > +++ b/arch/x86/kernel/ptrace.c
> > @@ -810,11 +810,15 @@ static void ptrace_bts_untrace(struct ta
> >  
> >  static void ptrace_bts_detach(struct task_struct *child)
> >  {
> > +	// We can race with de_thread/do_wait which
> > +	// can do ptrace_bts_untrace() before us
> >  	if (unlikely(child->bts)) {
> > -		ds_release_bts(child->bts);
> > -		child->bts = NULL;
> > -
> > -		ptrace_bts_free_buffer(child);
> > +		// This all will be freed by ptrace_bts_untrace()
> > +		// later, but we should update ->mm
> > +		down_write(->mmap_sem);
> > +		mm->total_vm  -= bts_size;
> > +		mm->locked_vm -= bts_size);
> > +		up_write(->mmap_sem);
> >  	}
> >  }
> >  #else
> > 
> 

There's still a race.
The kfree() is safe, now, but ptrace_bts_untrace() might have cleared
child->bts_size before we can refund the memory.

We need to make ptrace_bts_untrace() ignore child->bts_size and clear
it in ptrace_bts_detach().


regards,
markus.


