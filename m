Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbZC0T0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbZC0T0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZC0T0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:26:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:22734 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbZC0T0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=emJkuk5B0W9nWUB1dkDOkGl0+68JmiK0fDB2RXs8KNsulgq/aUvg7CjOK0IylZhSuW
         bZ/aEbyDnAvzsvSKfuzkhOiBY9fOIL1WYT1f437dk0ghbC2+mXHWp81PaZtBv4/wf/b7
         OKL3A9shlOfG+GdE6/mJMohmGIBmBnnAxFRj0=
Subject: Re: [patch 3/14] x86, ptrace, bts: stop bts tracing early in
	do_exit
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
In-Reply-To: <20090327172413.GC25762@redhat.com>
References: <20090327095525.A11052@sedona.ch.intel.com>
	 <20090327143435.GD14504@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E9266B6D4@irsmsx504.ger.corp.intel.com>
	 <20090327172413.GC25762@redhat.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 20:25:51 +0100
Message-Id: <1238181951.6077.38.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 18:24 +0100, Oleg Nesterov wrote:
> On 03/27, Metzger, Markus T wrote:
> >
> > >-----Original Message-----
> > >From: Oleg Nesterov [mailto:oleg@redhat.com]
> > >Sent: Friday, March 27, 2009 3:35 PM
> >
> > >> +static void ptrace_bts_exit(void)
> > >> +{
> > >> +	if (unlikely(!list_empty(&current->ptraced)))
> > >> +		ptrace_bts_exit_tracer();
> > >> +
> > >> +	if (unlikely(current->bts))
> > >> +		ptrace_bts_exit_tracee();
> > >> +}
> > >
> > >Could you explain why do we need ptrace_bts_exit_tracee() ?
> > >
> > >If current is traced, the tracer should do ptrace_bts_release()
> > >eventually, no?
> >
> > If current is traced and exits, it may be reaped by another thread that is not
> > the tracer (that's actually your example you made in an earlier thread to
> > describe the race between a normal detach and an exiting tracee).
> >
> > The ptrace_unlink() call to detach the tracer is executed with irq's disabled.
> > I need irq's enabled (see the other discussion, to wait for the traced task).
> 
> OK,
> 
> > Therefore, I have the tracee disable bts tracing itself when it exits.
> >
> >
> > >And if we really need to do ptrace_bts_exit_tracee(), then
> > >"if (unlikely(current->bts))" check is racy. The tracer
> > >can do PTRACE_BTS_CONFIG right after the check.
> >
> > The ptrace system call to do this would require the tracee to be stopped.
> 
> Yes, but this doesn't matter.
> 
> The tracer starts ptrace(PTRACE_BTS_CONFIG) and stops the tracee.
> But when the tracer calls ptrace_bts_config() the tracee can be already
> killed, and it can exit and bypass ptrace_bts_exit_tracee().

Thanks for your review! This is really helpful.


This exit race is a nasty thing.
I think I need to either prevent a task from running while I change the
tracing configuration, or have the tracee execute all the setup/cleanup
code.

The former looks more attractive to me. I would expect that there is
some infrastructure for that. I asked for pointers in a previous email,
already.


thanks and regards,
markus.

