Return-Path: <linux-kernel-owner+w=401wt.eu-S1764806AbYD2PBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764806AbYD2PBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYD2PBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:01:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:62716 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbYD2PBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:01:33 -0400
Message-ID: <48173852.8080107@windriver.com>
Date: Tue, 29 Apr 2008 10:01:38 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: kgdb with sw single-step...
References: <20080429.010221.268320653.davem@davemloft.net>
In-Reply-To: <20080429.010221.268320653.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2008 15:01:31.0660 (UTC) FILETIME=[E8C34CC0:01C8AA09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> While working on the sparc port of the new kgdb code in the tree I ran
> across a fundamental issue with this stuff on cpus that do
> single-stepping in software.
>
> The short story is that since such sw single-stepping is using
> globally visible state (the temporary breakpoint used), it does not
> fare well in the presence of cpus other than the current one hitting
> the single-step breakpoint.
>
> This actually limits my ability to test using kgdbts fully, the
> parallel tests often fail because the sw single-step emulation
> in kgdbts runs into several issues including the one I'm
> mentioning here.
>
> The good news is that there is a mostly working solution possible.
>
> When GDB is handling a normal threaded process, it handles other
> threads tripping over the temporary single-step breakpoint by simply
> holding them stopped until the thread that should have hit the
> breakpoint, does hit it.
>
> The kernel could do something similar, but this would require
> something like:
>
> 1) The architecture kgdb support code implements the sw single
> step breakpoint logic, this is necessary in order to
> handle single stepping over branches, calls, and things
> of this nature. (this is something the single-step
> emulation code in kgdbts doesn't even try to get right).
>

The existing kgdb core will already allow you to do this. You can
implement the response to the 's' gdb serial packet to be different
per arch and execute arch specific single step routines. While there
are no examples in the mainline sources, I do have some examples which
I could possibly send you for the ARM and MIPS arch. The reason these
are out of the consideration to merge at this time is that A) gdb does
the single stepping B) the kgdb arch specific implementation for ARM
and MIPS have not been merged to the mainline C) there should probably
be something a bit more generic in the kernel for such
activities... perhaps utrace or something else.

Lets just rule out "C)" for the purpose of this thread though. The
kgdbts single step emulation code was something very simple aimed at a
single processor. I would absolutely expect this to fail in the SMP
case.

> 2) The kgdb stub implements the single-stepping command using
> the support code in #1. When this happens, foreign cpus
> which have been captured are kept captured until the
> single-step breakpoint it hit by the primary kgdb cpu.
>
> Of course, this means we'll need changes to how gdb talks over the
> stub on these processors (mips, arm, sparc, etc.) since currently gdb
> will do all of the sw single-step breakpoint work.
>

I don't think you have to actually change gdb, because for sparc64 gdb
is set to "set_gdbarch_software_single_step (gdbarch, NULL);" This
means it is always going to ask the stub to perform the single
stepping.

> Some architectures, like Alpha, do the single-stepping in the
> ptrace implementation. Basically it's doing all of the sw
> single-step breakpoint work on the kernel side, instead of
> in gdb. Platforms like Alpha would therefore be readily adaptable
> to the above scheme without any gdb changes.


As mentioned earlier all the plumbing exists such that you can
implement the architecture specific end of things in the architecture
specific kgdb portion.

Jason.
