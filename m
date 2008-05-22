Return-Path: <linux-kernel-owner+w=401wt.eu-S934184AbYEVIri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184AbYEVIri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbYEVIr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:47:28 -0400
Received: from styx.suse.cz ([82.119.242.94]:57125 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756578AbYEVIr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:47:27 -0400
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a
	race
From: Petr Tesarik <ptesarik@suse.cz>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Thu, 22 May 2008 10:47:25 +0200
Message-Id: <1211446045.5610.33.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 10:47 +0800, Luming Yu wrote:
> Hello list,
> 
> The following patch is to fixed a race in ptrace_stop handling which
> causes "strace" hang if the target process blocks SIGTRAP with the
> test case filed at
> https://bugzilla.redhat.com/show_bug.cgi?id=446200#c16.
> Please note this is just IA64 problem because just IA64 has
> arch_ptrace_stop_needed defined, and has arch_ptrace_stop defined that
> would set notify_resume flags for syncing rbs...but it also opens the
> door to invoke ia64_do_signal->get_signal_to_deliver before setting
> current PTRACED flag. Please help review.
> 
> **The patch is enclosed in text attachment*
> **I'm using web client to send the patch* *

I'm inlining the patch for sake of convenience:

> 
> Signed-off-by: Yu Luming <luming.yu@intel.com>
> --------------------------------------
>  signal.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- 0/kernel/signal.c	2008-05-14 02:24:51.000000000 +0800
> +++ 1/kernel/signal.c	2008-05-22 13:54:42.000000000 +0800
> @@ -1488,6 +1488,9 @@
>  {
>  	int killed = 0;
>  
> +	/* Let the debugger run.  */
> +	__set_current_state(TASK_TRACED);
> +

That's probably not what we want. What happens if the task then sleeps
during the user-space access? Unless I forgot something obvious, it will
never get scheduled again...

Petr Tesarik

>  	if (arch_ptrace_stop_needed(exit_code, info)) {
>  		/*
>  		 * The arch code has something special to do before a
> @@ -1516,8 +1519,6 @@
>  	current->last_siginfo = info;
>  	current->exit_code = exit_code;
>  
> -	/* Let the debugger run.  */
> -	__set_current_state(TASK_TRACED);
>  	spin_unlock_irq(&current->sighand->siglock);
>  	read_lock(&tasklist_lock);
>  	if (!unlikely(killed) && may_ptrace_stop()) {

