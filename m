Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZBVQWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZBVQWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 11:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZBVQWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 11:22:40 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:46657 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZBVQWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 11:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CV57kos7Y4EFNYB348L5MQwz1xIL1Jk9vDobD8LHhOvJOjiyLeyHRx8C3scvjFl1FJ
         ShbJMnA09GkjRpLQ9XeNXYSDoMSBbXiDoiVfQwnRAiU1uj/oG6AROlk3HUmwf2gBpaql
         pPk8TwkR8qP3M+hfi1WlhLew4H6JN2JZ407aM=
Date: Sun, 22 Feb 2009 17:22:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, markus.t.metzger@gmail.com
Subject: Re: [PATCH -mm] tracing: Fix section mismatch in
	trace_hw_branches.c
Message-ID: <20090222162234.GA6003@nowhere>
References: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com> <20090221152251.GA6807@nowhere> <b9df5fa10902220533rb625291k135b3218151e12e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10902220533rb625291k135b3218151e12e5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 07:33:08PM +0600, Rakib Mullick wrote:
> On 2/21/09, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Hi,
> >
> >  When I saw this patch, I searched the real purpose of __cpuinit and its
> >  real impact.
> >  But I didn't find any comments about it inside the kernel.
> >
> >  But today, by looking at the discussion around latest git pull for x86
> >  to mainline, I discover that __cpuinit becomes __init on UP.
> >
> >  So, unless I missed something, this patch seems to me very dangerous.
> >  The init and reset callbacks of a tracer can be called at any time, not only
> >  on initcalls time (__init functions are freed from memory after the middle stage
> >  of the boot).
> >  With this patch, on UP we will dereference freed memory while activating this tracer.
> If the init and reset callbacks of a tracer can be called regardless
> of cpu hotpluging then it is. If the tracer's init or reset doesn't
> rely on cpuhotplug then it shouldn't use it.
> There's a another way to fix the warning is by remove __cpuinitdata
> from bts_hotcpu_notifier.


Yes, they can be called on UP, on SMP with or without cpu hotplug,
and everytime (boot, runtime).

init() is called when you switch to a tracer:

echo tracer_name > /debug/tracing/current_tracer

and reset() is called when you switch to another one.

But removing __cpuinitdata will mean a kind of waste of memory (though it's only
a little struct).

 
> Thanks,

