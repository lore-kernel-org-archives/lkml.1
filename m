Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbZINVgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbZINVgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623AbZINVgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:36:06 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:33439 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZINVgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b9ufOdcUq7tr0GdQfM84lShYPBCVBUfStDjf9q/wU3A1A0TnPpqpVcDPJc9J+4KMpO
         OcA3IhcWzODVtaJCLv27pvQHAozADort+7lp30OZYOpnbn1hYOILCRGEfJ74yyCJ7AtN
         7HNGgMVOCe2/A0SLO18Mg1SgdaQRRc2n0heDs=
Date: Mon, 14 Sep 2009 23:36:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf counters
Message-ID: <20090914213601.GL6045@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com> <20090914172835.GB29531@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914172835.GB29531@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 10:58:35PM +0530, K.Prasad wrote:
> On Thu, Sep 10, 2009 at 10:29:25AM +0200, Frederic Weisbecker wrote:
> > This patch rebase the implementation of the breakpoints API on top of
> > perf counters instances.
> > 
> > The core breakpoint API has changed a bit:
> > 
> > - register_kernel_hw_breakpoint() now takes a cpu as a parameter. For
> >   now it doesn't support all cpu wide breakpoints but this may be
> >   implemented soon.
> > 
> > - unregister_kernel_hw_breakpoint() and unregister_user_hw_breakpoint()
> >   have been unified in a single unregister_hw_breakpoint()
> > 
> > Each breakpoints now match a perf counter which now handles the
> > register scheduling, thread/cpu attachment, etc..
> > 
> [edited]
> > 
> > -/*
> > - * Load the debug registers during startup of a CPU.
> > - */
> > -void load_debug_registers(void)
> 
> It does not appear that perf handles CPUs that come up new (if else,
> blame my understanding of find_get_context():-)) and hence post breakpoint
> integration, the new CPUs wouldn't contain any breakpoint values (meant
> for all CPUs). As mentioned in my previous mail, this could be
> non-trivial lapse in debugging scenarios and even for users like
> ksym_tracer in ftrace. Your patch would want to retain the
> functionality of load_debug_registers().
> 
> Thanks,
> K.Prasad
> 


Ah it seems it can.
Look at:

static void __perf_counter_exit_cpu(void *info)
static void perf_counter_exit_cpu(int cpu)

