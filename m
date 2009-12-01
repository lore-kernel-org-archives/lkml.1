Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZLAHMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZLAHMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZLAHMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:12:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:63219 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZLAHMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:12:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=otdLvCIYjS2TwWbbFnIxpWjvz5virSIJdN/xHPTGP80qBDnyE3b77J8PIHUGsJk3Je
         kWw09n6ZF5WXRL6SVzShV2JzfXq6Di6daYEzOY0pE87q4u110PpoQfierZvw2kCxHWHZ
         MsnGvwDNTffOT+aSwFaRyG8xLfwl63QU1fWwA=
Date: Tue, 1 Dec 2009 08:12:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] hw-breakpoints: Use struct perf_event_attr to
	define user breakpoints
Message-ID: <20091201071208.GC5063@nowhere>
References: <1259294154-5197-1-git-send-regression-fweisbec@gmail.com> <20091127180310.GA18408@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091127180310.GA18408@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 11:33:10PM +0530, K.Prasad wrote:
> I suspect this further needs cleanup. Taking a quick look at all the
> exported interfaces:
> 
> struct perf_event *
> register_user_hw_breakpoint(struct perf_event_attr *attr,
>                             perf_callback_t triggered,
>                             struct task_struct *tsk);
> struct perf_event *
> modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr,
>                           perf_callback_t triggered,
>                           struct task_struct *tsk);
> 
> void unregister_hw_breakpoint(struct perf_event *bp);
> 
> struct perf_event **
> register_wide_hw_breakpoint(struct perf_event_attr *attr,
>                             perf_callback_t triggered);
> 
> void unregister_wide_hw_breakpoint(struct perf_event **cpu_events);
> 
> It could be further improved to make them more intuitive and
> symmetrical, for instance:
> 
> - Merge 'perf_callback_t triggered' with 'struct perf_event_attr' (it is
>   very much an attribute of the breakpoint) (you may also want to rename
>   'triggered' to something else...which is a pending suggestion from the
>   community - 'triggered' indicates a boolean datatype and not a
>   callback).


The perf attributes need to be a user and kernel interface (it is
a syscall parameter).
I don't we should expose what is supposed to be a kernel internal-only
address to such user interface, while it's not needed for the user.

But yeah I can rename trigger to "callback" simply.

Note: it's nice to have reviews and suggestions like you do, it makes
the things evolving, and I'll happily fix everything you reported (if
I agreed with the idea) but feel free to also send patches, it will
make it evolve faster :)

 
> - Make register_<> always return 'struct perf_event *' (just like how
>   unregister_<> always returns 'void').


That's a bit hard in the case of wide breakpoints as we are maintaining
a cpu array of breakpoints.


> - Both unregister_hw_breakpoint() and unregister_wide_hw_breakpoint()
>   can accept 'struct perf_event *' as parameters.


Same thing here.


> Would you also like to rename register_wide_hw_breakpoint() to
> register_kernel_hw_breakpoint() since a) It is used only for
> kernel-space requests b) If a per-cpu kernel-space counter is desired in
> future, register_wide_hw_breakpoint() name would shrink to
> register_hw_breakpoint() causing ambiguity (user or kernel?) and
> name-space collision.


Sure, I can rename it, unless you send a patch for that :)

