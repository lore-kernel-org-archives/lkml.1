Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbZLKPyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbZLKPyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932866AbZLKPyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:54:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbZLKPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:54:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=7U3hwN5JcxgA:10 a=D19gQVrFAAAA:8 a=meVymXHHAAAA:8 a=nFW2ZkBrfcvSfeYJKNsA:9 a=WkETIPhlB4liu8LRvWZU28nkKdYA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: dynamic ftrace - graph
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: monstr@monstr.eu
Cc: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
In-Reply-To: <4B226507.4080407@monstr.eu>
References: <4AF848C0.7010807@monstr.eu>
	 <1260506225.2146.347.camel@gandalf.stny.rr.com>
	 <4B21F4F6.5080600@monstr.eu>
	 <1260542255.2146.350.camel@gandalf.stny.rr.com> <4B2259EB.80605@monstr.eu>
	 <1260543272.2146.355.camel@gandalf.stny.rr.com>
	 <4B226507.4080407@monstr.eu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Dec 2009 10:54:22 -0500
Message-ID: <1260546862.2146.367.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 16:28 +0100, Michal Simek wrote:
> Steven Rostedt wrote:
> > On Fri, 2009-12-11 at 15:40 +0100, Michal Simek wrote:
> >> Steven Rostedt wrote:
> > 
> >>> Hey, if they work and they are only in your arch, then I'm fine with
> >>> them ;-)
> >> yeah. There is one just small hook to recordmcount.pl. :-)
> > 
> > I may need to give an acked-by. If I did not yet, could you send me that
> > specific patch.
> 
> I sent that patches to LKML last month - you were cc'd.
> http://lkml.org/lkml/2009/11/23/48

They are probably still in the "todo" pile ;-)

> 
> You should get it in your mailbox
> 
> That part is pretty easy. :-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 090d300..b30dabd 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -245,6 +245,9 @@ if ($arch eq "x86_64") {
>       $ld .= " -m elf64_sparc";
>       $cc .= " -m64";
>       $objcopy .= " -O elf64-sparc";
> +} elsif ($arch eq "microblaze") {
> +    # Microblaze calls '_mcount' instead of plain 'mcount'.
> +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
>   } else {
>       die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
>   }

If that's all it is, then here:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

> 
> 
> > 
> > 
> >> we will see. Currently I have small problem only with irqsoff but I 
> >> think this don't have connection with ftrace - only with lockdep I 
> >> think. :-)
> > 
> > You have lockdep working?  If you get lockdep working you should get the
> > irqsoff tracer for free.
> 
> I have some problems when I turn on lockdep debug (CONFIG_DEBUG_LOCKDEP) 
> - kernel freeze for currently unknown reason.
> I saw that some arch has some part of code in entry.S but I haven't had 
> a time to look at them - maybe needs some changes there too.

Yeah, anytime you disable interrupts or enable them (including when the
hardware does it from entering an exception), you need to call into the
lockdep infrastructure (trace_hardiqs_on/off){_caller}.


> 
> As you can see below locking testsuite output looks fine but irqsoff 
> tracer freeze the kernel. Function tracer is ok.
> 
> There could be a problem with some arch specific functions which 
> shouldn't be compiled with -pg.

Does it still freeze if you don't enable the function tracer?

> 
> Any suggestions? :-)
> 


> # cd /
> # mkdir debug
> # mount -t debugfs none /debug
> # cat /debug/tracing/available_tracers
> irqsoff function sched_switch nop
> # echo irqsoff > /debug/tracing/current_tracer
> 
> and kernel freeze. :-(

Try it without configuring function tracer, or you could also do:

echo 0 > /proc/sys/ftrace_enabled

That will also disable the function tracer.

-- Steve


