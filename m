Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZBUPXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZBUPXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 10:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZBUPW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 10:22:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:54991 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbZBUPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 10:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iQx1yJSeS1VeLvgWPgQeCdSkiez73C3Yh98zkIBnckwMjiSuXv+QPLg8p64dQOF2lH
         O2s5WPcQf6wGDNfMMCalIqkqwr+hH6VfTwukGMpz1RvoCob/Fq2eC00a/trlkIoVY5X9
         0Y/5oFsPc4VckAxn2VM+hpVBZy/qO053Pm5xo=
Date: Sat, 21 Feb 2009 16:22:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, markus.t.metzger@gmail.com
Subject: Re: [PATCH -mm] tracing: Fix section mismatch in
	trace_hw_branches.c
Message-ID: <20090221152251.GA6807@nowhere>
References: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 09:36:00AM +0600, Rakib Mullick wrote:
>   Impact: Fix section mismatch
> 
> The function bts_trace_init() references a variable
> bts_hotcpu_notifier which is marked
> as __cpuinitdata. Thus causes section mismatch. This patch fixes it.
> 
>   LD      kernel/trace/built-in.o
> WARNING: kernel/trace/built-in.o(.text+0xc90c): Section mismatch in
> reference from the function bts_trace_init() to the variable
> .cpuinit.data:bts_hotcpu_notifier
> The function bts_trace_init() references
> the variable __cpuinitdata bts_hotcpu_notifier.
> This is often because bts_trace_init lacks a __cpuinitdata
> annotation or the annotation of bts_hotcpu_notifier is wrong.
> 
> WARNING: kernel/trace/built-in.o(.text+0xc92a): Section mismatch in
> reference from the function bts_trace_reset() to the variable
> .cpuinit.data:bts_hotcpu_notifier
> The function bts_trace_reset() references
> the variable __cpuinitdata bts_hotcpu_notifier.
> This is often because bts_trace_reset lacks a __cpuinitdata
> annotation or the annotation of bts_hotcpu_notifier is wrong.
> 
> Thanks.
> 
> ---
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linus/kernel/trace/trace_hw_branches.c	2009-02-13 11:23:55.000000000 +0600
> +++ rakib/kernel/trace/trace_hw_branches.c	2009-02-13 22:12:30.000000000 +0600
> @@ -127,7 +127,7 @@ static struct notifier_block bts_hotcpu_
>  	.notifier_call = bts_hotcpu_handler
>  };
> 
> -static int bts_trace_init(struct trace_array *tr)
> +static int __cpuinit bts_trace_init(struct trace_array *tr)
>  {
>  	hw_branch_trace = tr;
> 
> @@ -137,7 +137,7 @@ static int bts_trace_init(struct trace_a
>  	return 0;
>  }
> 
> -static void bts_trace_reset(struct trace_array *tr)
> +static void __cpuinit bts_trace_reset(struct trace_array *tr)
>  {
>  	bts_trace_stop(tr);
>  	unregister_hotcpu_notifier(&bts_hotcpu_notifier);


Hi,

When I saw this patch, I searched the real purpose of __cpuinit and its
real impact.
But I didn't find any comments about it inside the kernel.

But today, by looking at the discussion around latest git pull for x86
to mainline, I discover that __cpuinit becomes __init on UP.

So, unless I missed something, this patch seems to me very dangerous.
The init and reset callbacks of a tracer can be called at any time, not only
on initcalls time (__init functions are freed from memory after the middle stage
of the boot).
With this patch, on UP we will dereference freed memory while activating this tracer.

The old code was fine because register_hotplug_cpu does nothing on UP.
Unfortunately the warning still existed though this was a kind of false positive.
This is a section mismatch, but harmless.

So instead I would suggest to:

- call register_hotcpu_notifier(&bts_hotcpu_notifier) from init_bts_trace() which
  is called only one time on boot.

- never unregister this notifier

- inside bts_hotcpu_handler(), only call bts_trace_{start,stop}_cpu() on the given
  cpu if trace_hw_branches_enabled == 1
  Ok, now the handler will be called on each cpu hotplug event but this is fine since
  this is a rare path.

Hm?


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

