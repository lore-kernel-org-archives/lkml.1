Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYBKPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYBKPiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYBKPiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:38:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbYBKPim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:38:42 -0500
Message-ID: <47B06B4E.1010704@redhat.com>
Date: Mon, 11 Feb 2008 10:35:42 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>
Subject: Re: [17/19] ftrace: dynamic enabling/disabling of function calls
References: <20080210072109.GR4100@elte.hu>
In-Reply-To: <20080210072109.GR4100@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Steven,

Ingo Molnar wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch adds a feature to dynamically replace the ftrace code
> with the jmps to allow a kernel with ftrace configured to run
> as fast as it can without it configured.
> 
> The way this works, is on bootup, a ftrace function is registered
> to record the instruction pointer of all places that call the
> function.
> 
> Later, a kthread is awoken once a second that performs a stop_machine,
> and replaces all the code that was called with a jmp over the call
> to ftrace. It only replaces what was found the previous time.
> 
> e.g.
> 
>   call ftrace  /* 5 bytes */
> 
> is replaced with
> 
>   jmp 3f  /* jmp is 2 bytes and we jump 3 forward */
> 3:
> 
> When we want to enable ftrace for function tracing, the IP recording
> is removed, and stop_machine is called again to replace all the locations
> of that were recorded back to the call of ftrace.  When it is disabled,
> we replace the code back to the jmp.
> 
> Allocation is done by the kthread. If the ftrace recording function is
> called, and we don't have any record slots available, then we simply
> skip that call. Once a second a new page (if needed) is allocated for
> recording new ftrace function calls.  A large batch is allocated at
> boot up to get most of the calls there.
> 
> Because we do this via stop_machine, we don't have to worry about another
> CPU executing a ftrace call as we modify it. But we do need to worry
> about NMI's so all functions that might be called via nmi must be
> annotated with notrace_nmi. When this code is configured in, the NMI code
> will not call notrace.

I'd like to suggest that you can use djprobe-like solution here to eliminate
stop_machine.
The djprobe makes a bypass over that call instruction by using a kprobe,
and after replacing the call instruction, you can safely remove the bypass.
Here is an ols paper about djprobe.
http://www.kernel.org/doc/ols/2007/ols2007v1-pages-189-200.pdf

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

