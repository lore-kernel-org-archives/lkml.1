Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbZEKV0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbZEKV0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZEKV0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:26:09 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:62072 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbZEKV0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=qo2VAUSPrh1rG/U+pNRHNU0jmw/DA8DUeMbf/XhO5pSQ4ymILzqe5hg/tJPJzhkKby
         1SM/zKRV0liEShKAp1UB7dEjSAmS6xZAoEUjeiWplbUnBLsoIldSKQwU+YkWjOHhId6q
         uv9uzLjO0QxRd8hPVZkPX6GpJT4XkRhieDJKU=
Date: Mon, 11 May 2009 23:26:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip v5 4/7] tracing: add kprobe-based event tracer
Message-ID: <20090511212602.GA5965@nowhere>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004859.5505.18729.stgit@localhost.localdomain> <c62985530905090936v22f6ab1s867d8f8d6a74b95a@mail.gmail.com> <4A05BE81.8070306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A05BE81.8070306@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 01:33:53PM -0400, Masami Hiramatsu wrote:
> Frédéric Weisbecker wrote:
> > Hi,
> > 
> > 2009/5/9 Masami Hiramatsu <mhiramat@redhat.com>:
> [...]
> >> +
> >> +/* event recording functions */
> >> +static void kprobe_trace_record(unsigned long ip, struct trace_probe *tp,
> >> +                               struct pt_regs *regs)
> >> +{
> >> +       __trace_bprintk(ip, "%s%s%+ld\n",
> >> +                       probe_is_return(tp) ? "<-" : "@",
> >> +                       probe_symbol(tp), probe_offset(tp));
> >> +}
> > 
> > 
> > 
> > What happens here if you have:
> > 
> > kprobe_trace_record() {
> >       probe_symbol() {
> >             ....                         probes_open() {
> >                                               cleanup_all_probes() {
> >                                                          free_trace_probe();
> >      return tp->symbol ? ....; //crack!
> >
> > I wonder if you shouldn't use a per_cpu list of probes,
> > spinlocked/irqsaved  accessed
> > and also a kind of prevention against nmi.
> 
> Sure, cleanup_all_probes() invokes unregister_kprobe() via
> unregister_trace_probe(), which waits running probe-handlers by
> using synchronize_sched()(because kprobes disables preemption
> around its handlers), before free_trace_probe().
> 
> So you don't need any locks there :-)
> 
> Thank you,
> 
> 


Aah, ok :)
So this patch looks sane.

Thanks.

