Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZKBKrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZKBKrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZKBKrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:47:52 -0500
Received: from ozlabs.org ([203.10.76.45]:60201 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbZKBKrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:47:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19182.47317.438053.553079@cargo.ozlabs.ibm.com>
Date: Mon, 2 Nov 2009 21:47:49 +1100
From: Paul Mackerras <paulus@samba.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20091101213839.28b4054a@infradead.org>
References: <4AE55B1B.2030006@web.de>
	<1257109753-6464-2-git-send-email-fweisbec@gmail.com>
	<19182.22063.788927.708332@cargo.ozlabs.ibm.com>
	<20091101213839.28b4054a@infradead.org>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven writes:

> On Mon, 2 Nov 2009 14:46:55 +1100
> Paul Mackerras <paulus@samba.org> wrote:
> 
> > Frederic Weisbecker writes:
> > 
> > >  /*
> > > + * perf_event_create_kernel_counter
> > > + * MUST be called from a kernel thread.
> > 
> > Why?  The reason for this requirement isn't obvious to me.  It would
> > be good to have the reason documented in the comment for the sake of
> > people modifying the code in future.
> 
> because if you call it from another context it will attach to that
> context... and go away when that context goes away...

I don't think that's right.  When a task exits, that doesn't
automatically kill all the perf_events it created.  The perf_events
each have a reference to their owner's task_struct, so the task_struct
will hang around until all of the perf_events get released.  Normally
top-level perf_events have an associated filp and we use its reference
count to control the perf_event lifetime, but with these new kernel
perf_events there is no filp, so the caller will have to do any
refcounting required.

Bottom line is that a perf_event created by
perf_event_create_kernel_counter will exist until someone calls
perf_event_release_kernel on it, whether or not the owner task exits
(and whether or not that task is a kernel thread or a usermode
process).  So I see no need to prohibit creating kernel perf_events in
the context of a user task, though callers need to be aware that doing
so could potentially mean the user task's task_struct has to hang
around for a long time after the task exits.

Paul.
