Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYHVKSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYHVKSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYHVKSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:18:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43341 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbYHVKSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:18:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: ftraced and suspend to ram
Date: Fri, 22 Aug 2008 12:22:02 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <200808212159.37678.rjw@sisk.pl> <20080822044649.GA356@elte.hu>
In-Reply-To: <20080822044649.GA356@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221222.03907.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of August 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > > The code in question is the ftraced() function in 
> > > > kernel/trace/ftrace.c
> > > 
> > > Thanks, I'll have a look in a while.
> > 
> > Can you try the appended patch, please?
> 
> makes sense - i've applied it to tip/tracing/urgent, see the tidied up 
> commit below.
> 
> It should be no big issue not being able to trace across suspend+resume 
> - and that restriction will go away with Steve's build-time based mcount 
> patching mechanism in v2.6.28.
> 
> 	Ingo
> 
> ------------->
> From 0e556695ddc8eebf6f6dd86bb0c4911b2b90c12a Mon Sep 17 00:00:00 2001
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Date: Thu, 21 Aug 2008 21:59:36 +0200
> Subject: [PATCH] ftrace: fix ftraced and suspend to ram
> 
> Steven Rostedt observed:
> 
> > In latest 2.6.27(git) enabling dynamic ftrace makes resume from a suspend
> > to ram reboot instead of resuming. Queued for 2.6.28 is a new method of
> > recording mcount callers at compile time that does not have this issue.
> >
> > But the new method is still too "green" to be pulled into 27, so the old
> > ftraced (daemon method) needs to be fixed for 27.
> >
> > The way dynamic ftrace works with the daemon method is this. On boot up
> > the mcount function simply returns. When ftrace is initialized, it calls
> > kstop_machine to modify the mcount function to call another function
> > called "ftrace_record_ip". This new function will record in a preallocated
> > hash (allocated by the ftrace initializer) all the callers of mcount. A
> > check is made to see if the caller has already been put into the hash, and
> > if so, it is not recorded again.
> >
> > Later on a kernel thread ftraced is created. This kernel thread wakes up
> > once a second and checks to see if any new functions were added to the
> > hash. If so, it then calls kstop_machine and modifies those callers to
> > mcount into nops.
> 
> It will suffice to make it freezable, so that it doesn't run while the
> system is suspending and resuming.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Well, you can add my sign-off too. ;-)

> ---
>  kernel/trace/ftrace.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 639e16c..49f4c3f 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -819,8 +819,13 @@ static int ftraced(void *ignore)
>  {
>  	unsigned long usecs;
>  
> +	set_freezable();
> +
>  	while (!kthread_should_stop()) {
>  
> +		if (try_to_freeze())
> +			continue;
> +
>  		set_current_state(TASK_INTERRUPTIBLE);
>  
>  		/* check once a second */
> 
> 


