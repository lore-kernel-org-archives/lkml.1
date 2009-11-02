Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZKBNAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZKBNAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZKBNAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:00:15 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:24342 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZKBNAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:00:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ma0krhnlatH4T9FdnHTa7vdY6xCT5STr7fwNUZLTHCUdmRo6oNhYx9a7ogv/s1DqOU
         h4zASF11KLIYwrgikIcr/EyOkUuAJnCejDpOkVos5oFT7vWbxH3z97L3b+aGVtAaY0mC
         6pR0q3kC92gEmYRdWY+i6YiKPVJLnKNsB4kmk=
Date: Mon, 2 Nov 2009 14:00:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>, Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH 1/6] perf/core: Provide a kernel-internal interface to
	get to performance counters
Message-ID: <20091102130012.GA4878@nowhere>
References: <4AE55B1B.2030006@web.de> <1257109753-6464-2-git-send-email-fweisbec@gmail.com> <19182.22063.788927.708332@cargo.ozlabs.ibm.com> <20091101213839.28b4054a@infradead.org> <19182.47317.438053.553079@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19182.47317.438053.553079@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 09:47:49PM +1100, Paul Mackerras wrote:
> Arjan van de Ven writes:
> 
> > On Mon, 2 Nov 2009 14:46:55 +1100
> > Paul Mackerras <paulus@samba.org> wrote:
> > 
> > > Frederic Weisbecker writes:
> > > 
> > > >  /*
> > > > + * perf_event_create_kernel_counter
> > > > + * MUST be called from a kernel thread.
> > > 
> > > Why?  The reason for this requirement isn't obvious to me.  It would
> > > be good to have the reason documented in the comment for the sake of
> > > people modifying the code in future.
> > 
> > because if you call it from another context it will attach to that
> > context... and go away when that context goes away...
> 
> I don't think that's right.  When a task exits, that doesn't
> automatically kill all the perf_events it created.  The perf_events
> each have a reference to their owner's task_struct, so the task_struct
> will hang around until all of the perf_events get released.  Normally
> top-level perf_events have an associated filp and we use its reference
> count to control the perf_event lifetime, but with these new kernel
> perf_events there is no filp, so the caller will have to do any
> refcounting required.
> 
> Bottom line is that a perf_event created by
> perf_event_create_kernel_counter will exist until someone calls
> perf_event_release_kernel on it, whether or not the owner task exits
> (and whether or not that task is a kernel thread or a usermode
> process).  So I see no need to prohibit creating kernel perf_events in
> the context of a user task, though callers need to be aware that doing
> so could potentially mean the user task's task_struct has to hang
> around for a long time after the task exits.
> 
> Paul.


Yeah. For example while creating a breakpoint through ptrace,
the owner of an event created by perf_event_create_kernel_counter
is the user task that does the ptrace call.

But we need to explicitly release some disabled/pending ptrace
breakpoints using perf_event_release_kernel when the task exits.
I should simplify this part in the future.

That said, it's all fine to set the owner as a user task like in this
example.

Should I remove this comment?

