Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZC0R2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZC0R2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZC0R14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:27:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55173 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbZC0R14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:27:56 -0400
Date: Fri, 27 Mar 2009 18:24:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 3/14] x86, ptrace, bts: stop bts tracing early in do_exit
Message-ID: <20090327172413.GC25762@redhat.com>
References: <20090327095525.A11052@sedona.ch.intel.com> <20090327143435.GD14504@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E9266B6D4@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9266B6D4@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Metzger, Markus T wrote:
>
> >-----Original Message-----
> >From: Oleg Nesterov [mailto:oleg@redhat.com]
> >Sent: Friday, March 27, 2009 3:35 PM
>
> >> +static void ptrace_bts_exit(void)
> >> +{
> >> +	if (unlikely(!list_empty(&current->ptraced)))
> >> +		ptrace_bts_exit_tracer();
> >> +
> >> +	if (unlikely(current->bts))
> >> +		ptrace_bts_exit_tracee();
> >> +}
> >
> >Could you explain why do we need ptrace_bts_exit_tracee() ?
> >
> >If current is traced, the tracer should do ptrace_bts_release()
> >eventually, no?
>
> If current is traced and exits, it may be reaped by another thread that is not
> the tracer (that's actually your example you made in an earlier thread to
> describe the race between a normal detach and an exiting tracee).
>
> The ptrace_unlink() call to detach the tracer is executed with irq's disabled.
> I need irq's enabled (see the other discussion, to wait for the traced task).

OK,

> Therefore, I have the tracee disable bts tracing itself when it exits.
>
>
> >And if we really need to do ptrace_bts_exit_tracee(), then
> >"if (unlikely(current->bts))" check is racy. The tracer
> >can do PTRACE_BTS_CONFIG right after the check.
>
> The ptrace system call to do this would require the tracee to be stopped.

Yes, but this doesn't matter.

The tracer starts ptrace(PTRACE_BTS_CONFIG) and stops the tracee.
But when the tracer calls ptrace_bts_config() the tracee can be already
killed, and it can exit and bypass ptrace_bts_exit_tracee().

Oleg.

