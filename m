Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZKELYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZKELYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZKELX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:23:59 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:42205 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZKELX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:23:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BsxQk60OpgsUT37J0596DDgCXCFmzpSEXgAN4PwPTFD74x/KP7Yz21RTvBVAlFuK1D
         aQrDempQnXd8WdG6LWcbvw25DbGMGXsL6RfgBozjguCdoGKOyZyku4+UoSGu3Q0VXsmb
         YK7EQx64SS5yphLgzdMp0GnHf3G4RtfAGAs6o=
Date: Thu, 5 Nov 2009 12:24:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 5/6] hw-breakpoints: Arbitrate access to pmu following
	registers constraints
Message-ID: <20091105112359.GD4877@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-6-git-send-email-fweisbec@gmail.com> <19186.45014.502448.698606@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19186.45014.502448.698606@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 09:58:30PM +1100, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > Allow or refuse to build a counter using the breakpoints pmu following
> > given constraints.
> 
> As far as I can see, you assume each CPU has HBP_NUM breakpoint
> registers which are all interchangeable and can all be used either for
> data breakpoints or instruction breakpoints.  Is that accurate?



Yes, they are interchangeable at runtime while calling
enable/disable callbacks of the pmu.

I'm not sure instruction breakpoints are supported though.

 
> If so, we'll need to extend it a bit for Power since we have some CPUs
> that have one data breakpoint register and one instruction breakpoint
> register.  In general on powerpc the instruction and data breakpoint
> facilities are separate, i.e. we have no registers that can be used
> for either.



Sure. I would be glad to help in that area. That said I won't be
able to test anything as I don't have a PowerPc box.



> > +static void toggle_bp_slot(struct perf_event *bp, bool enable)
> > +{
> > +	int cpu = bp->cpu;
> > +	unsigned int *nr;
> > +	struct task_struct *tsk = bp->ctx->task;
> > +
> > +	/* Flexible */
> > +	if (!bp->attr.pinned) {
> > +		if (cpu >= 0) {
> > +			nr = &per_cpu(nr_bp_flexible, cpu);
> > +			goto toggle;
> > +		}
> > +
> > +		for_each_online_cpu(cpu) {
> > +			nr = &per_cpu(nr_bp_flexible, cpu);
> > +			goto toggle;
> 
> ...
> 
> > +toggle:
> > +	*nr = enable ? *nr + 1 : *nr - 1;
> > +}
> 
> This won't do what I think you want.  In the case where
> !bp->attr.pinned and cpu == -1, it will only update the count for the
> first online cpu, not all of them.
> 
> Paul.


Oh right! That's really idiotic. Will fix.

Thanks!



