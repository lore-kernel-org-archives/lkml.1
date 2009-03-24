Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbZCXUOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbZCXUOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZCXUOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:14:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:17317 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZCXUOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bJpsijyyBch1p3RP9ve/pnoTVOk406Fm1+x0c3FMKwX0+X+91z1+Bau2eivnyQKaGq
         REIRdin8hbEf1HO1Cd+jr7sbl3+X7btuH5VF5voYzkwqphiR/s9LtcxgQhMRnHmO2/gD
         WQj1smbPgPsByC7zJfWmRYTKI8A7bsnkLs9/Q=
Date: Tue, 24 Mar 2009 21:13:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       rusty@rustcorp.com.au, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ftrace not working?
Message-ID: <20090324201357.GB5975@nowhere>
References: <20090323083533.GE18837@elte.hu> <20090323200057.9027.A69D9226@jp.fujitsu.com> <20090323143226.GA18439@elte.hu> <200903242253.36794.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903242253.36794.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:53:35PM +0530, Nikanth Karthikesan wrote:
> On Monday 23 March 2009 20:02:26 Ingo Molnar wrote:
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > > On Monday 23 March 2009 14:05:33 Ingo Molnar wrote:
> > > > > one thing to note:
> > > > > | CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
> > > > > | Testing tracer nop: PASSED
> > > > >
> > > > > so it's a Qemu session, right?
> > > >
> > > > Yes. qemu-kvm.
> > >
> > > Ah, sorry. I don't know qemu and kvm at all ;)
> >
> > In terms of tracing it should just look like some weird old CPU with
> > few capabilities and long delays. Nothing in ftrace depends on CPU
> > capabilities (that wasnt present in pentia) so this is weird.
> > Perhaps some timestamping problem? Virtual machines tend to have
> > trouble with the TSC. Or code patching problems? But that does not
> > explain the lack of explicit scheduler events.
> >
> > Or perhaps the fact that qemu sessions tend to boot with barely any
> > RAM. Maybe the ringbuffer size is very low?
> >
> 
> Nope, it is not a qemu problem, but ftrace. Most probably, it shouldn't work on
> real hardware as well with my config. i.e., CONFIG_CPUMASK_OFFSTACK = y
> and NR_CPUS = 4096 via CONFIG_MAXSMP.
> 
> The tracing_buffer_mask was getting freed and the bitmask was all zeros. And
> for_each_tracing_cpu() never looped. Here is the patch that fixes the issue
> for me. Tested only on qemu-kvm. ;)
> 
> Steve, Can you merge this.
> 
> Thanks
> Nikanth
> 
> In tracer_alloc_buffers(), do not free tracing_cpumask and tracing_buffer_mask
> on success.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 17bb88d..98f609d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3887,6 +3887,7 @@ __init static int tracer_alloc_buffers(void)
>  
>  	register_die_notifier(&trace_die_notifier);
>  	ret = 0;
> +	goto out;


Ah I see.
I've sent a fix for that already, it's on latest -tip
http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=2fc1dfbe17e7705c55b7a99da995fa565e26f151


  
>  out_free_cpumask:
>  	free_cpumask_var(tracing_cpumask);
> 
> 

