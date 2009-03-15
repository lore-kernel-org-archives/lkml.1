Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZCOPZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZCOPZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZCOPZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:25:40 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:58409 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZCOPZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yab3gGKtcxOuxkV5n8+fLAOFgiXhAUVs74hk80CwgAV+81Q08Rv3GawerRsCPguJ0H
         u9qEGt/RVvm/llXmjfa/VESgWad8VsWiJLpjAx+k5KEQ+U4O1eNjY5y6h6np2Wxr+148
         Gd8m7AOi9CSzyIBSJOqwJLDQzhG85awbzx0X0=
Date: Sun, 15 Mar 2009 16:25:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 0/2 v2] Syscalls tracing
Message-ID: <20090315152532.GC5105@nowhere>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <20090313151632.GB9867@nowhere> <20090313155541.GA15481@elte.hu> <20090313161749.GA3203@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313161749.GA3203@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 05:17:49PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Fri, Mar 13, 2009 at 03:42:10PM +0100, Frederic Weisbecker wrote:
> > > > tracing/syscalls: core infrastructure to trace syscalls
> > > > 
> > > > This new iteration addresses a good part of the previous reviews.
> > > 
> > > 
> > > Ah I just discovered that you applied the previous version 
> > > today. But the v2 is not a delta :-s
> > > 
> > > I can rebase them but not until Sunday.
> > 
> > No problem, i'll deltify them and will have a look.
> 
> Ok, i did the deltas, tidied them up and put them into 
> tip:tracing/syscalls.
> 
> Nice stuff! Here's some sample output:
> 
> aldebaran:/debug/tracing> head trace
> # tracer: syscall
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>            <...>-4405  [003]   188.452934: sys_dup2(oldfd: a, newfd: 1) 
>            <...>-4405  [003]   188.452939: sys_dup2 -> 0x1
>            <...>-4405  [003]   188.452940: sys_fcntl(fd: a, cmd: 1, arg: 0) 
>            <...>-4405  [003]   188.452941: sys_fcntl -> 0x1
>            <...>-4405  [003]   188.452942: sys_close(fd: a) 
>            <...>-4405  [003]   188.452943: sys_close -> 0x0
> 
> A suggestion:
> 
>  - Would be nice for all the registered syscalls to show up
>    under /debug/events/syscalls/, one directory per syscall,
>    with an 'enable' and a 'format' file as well.


Nice idea.
It is somehow planned since I want to let the user export the traces
through their binary values (so they will need the format).

 
> And a bugreport:
> 
>  - when using function_graph (after having used the syscall 
>    tracer) i dont see graph traces anymore - only the syscall 
>    trace entries:


Ah exact, it seems I forgot to reset the buffer while switching the tracer.


> # tracer: function_graph
> #
> # CPU  DURATION                  FUNCTION CALLS
> # |     |   |                     |   |   |   |
> ##### CPU 9 buffer started ####
>  at-spi-registry-3063  [009]   322.915058: sys_read -> 0x5a8
>  at-spi-registry-3063  [009]   322.915059: sys_write(fd: 6, buf: 632840, count: 5a8) 
>  at-spi-registry-3063  [009]   322.915062: sys_write -> 0x5a8
>  at-spi-registry-3063  [009]   322.915062: sys_read(fd: 4, buf: 632840, count: 40000) 
> 
> That's not intended, right?


Indeed it's not. I'm cooking the fix.

Thanks.


> 	Ingo

