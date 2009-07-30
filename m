Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbZG3TZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbZG3TZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZG3TZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:25:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48260 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZG3TZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:25:29 -0400
Date: Thu, 30 Jul 2009 21:20:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       roland <roland@redhat.com>
Subject: Re: perf_counters issue with self-sampling threads
Message-ID: <20090730192040.GA9503@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com> <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com> <1248953485.6391.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1248953485.6391.41.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Peter Zijlstra wrote:
>
> On Thu, 2009-07-30 at 00:17 +0200, Oleg Nesterov wrote:
> > (add Roland)
>
> but you seem to have forgotten to actually edit the CC line, fixed
> that ;-)

Yes, thanks ;)

> > On 07/29, Peter Zijlstra wrote:
> > >
> > > On Mon, 2009-07-27 at 18:51 +0200, stephane eranian wrote:
> > > >
> > > > POSIX does not mandate that asynchronous signals be delivered
> > > > to the thread in which they originated. Any thread in the process
> > > > may process the signal, assuming it does not have the signal
> > > > blocked.
> >
> > Yes. I now nothing about POSIX, but this is what Linux does at least.
> > I don't think we can/should change this behaviour.
>
> Well, we have plenty exceptions to that rule already, we have itimer
> extentions, tkill sys_rt_tgsigqueueinfo and plenty more..

Yes, yes, I meant the behaviour of kill(2), group_send_sig_info(), etc.

> > > fcntl(2) for F_SETOWN says:
> > >
> > > If a non-zero value is given to F_SETSIG  in  a  multi‐ threaded
> > > process running with a threading library that supports thread groups
> > > (e.g., NPTL),  then  a  positive value  given  to  F_SETOWN  has  a
> > > different  meaning: instead of being a process ID identifying a whole
> > > pro‐ cess,  it  is a thread ID identifying a specific thread within a
> > > process.
> >
> > Heh. Definitely this is not what Linux does ;)
>
> Right, so the question is, did we ever? Why does the man page say this.
>
> Looking at the .12 source (git start) we did:
>
>   440 			if (!send_sig_info(fown->signum, &si, p))
>   441 				break;
>   442 		/* fall-through: fall back on the old plain SIGIO signal */
>   443 		case 0:
>   444 			send_group_sig_info(SIGIO, SEND_SIG_PRIV, p);

Yes, the send_sig_info() above seems to match the manpage.

Another thing I can't understand, group_send_sig_info() calls
check_kill_permission(). But check_kill_permission() uses current, which
can be a "random" task if kill_fasync() is called from interrupt. Even
if not interrupt, I don't understand why (say) pipe_read() can't send a
signal here. sigio_perm() has already checked permissions, and it correctly
uses fown->cred.

> Which was 'corrected' in:
>
> commit fc9c9ab22d5650977c417ef2032d02f455011b23
> Author: Bharath Ramesh <bramesh@vt.edu>
> Date:   Sat Apr 16 15:25:41 2005 -0700
>
>     [PATCH] AYSNC IO using singals other than SIGIO
>
>     A question on sigwaitinfo based IO mechanism in multithreaded applications.
>
>     I am trying to use RT signals to notify me of IO events using RT signals
>     instead of SIGIO in a multithreaded applications.  I noticed that there was
>     some discussion on lkml during november 1999 with the subject of the
>     discussion as "Signal driven IO".  In the thread I noticed that RT signals
>     were being delivered to the worker thread.  I am running 2.6.10 kernel and
>     I am trying to use the very same mechanism and I find that only SIGIO being
>     propogated to the worker threads and RT signals only being propogated to
>     the main thread and not the worker threads where I actually want them to be
>     propogated too.  On further inspection I found that the following patch
>     which I have attached solves the problem.

So, some people want shared signals here.

> > I am not sure I understand the man above... But to me it looks like we
> > should always send a private signal when fown->signum != 0 ?
> >
> > The change should be simple, but as you pointed out we can break things.
>
> Right, so the change I had in mind is like the below (except I don't
> know if we can compare struct pid things by pointer value or if we
> should look at the content).

(yes, we can compare the pointers)

> In any case, we should either do something like the below (yay!), or
> amend the manpage (Michael?) and introduce something like F_SETOWN2
> which does have the below semantics :-(.
>
> ---
> Index: linux-2.6/fs/fcntl.c
> ===================================================================
> --- linux-2.6.orig/fs/fcntl.c
> +++ linux-2.6/fs/fcntl.c
> @@ -431,6 +431,16 @@ static void send_sigio_to_task(struct ta
>  			       int fd,
>  			       int reason)
>  {
> +	int (*send_sig)(int, struct siginfo *, struct task_struct *);
> +
> +	send_sig = group_send_sig_info;
> +	/*
> +	 * If the fown points to a specific TID instead of to a PID
> +	 * we'll send the signal to the thread only.
> +	 */
> +	if (fown->pid_type == PIDTYPE_PID && fown->pid != task_tgid(p))
> +		send_sig = send_sig_info;

Yes, this allows to send a private signal to sub-thread.

But this is a bit strange, because the user can't specify it wants
a thread-specific signal to the main thread, its tid == pid.

I don't know what should we do. Perhaps we can just add
"bool is_group_signal" to fown_struct as another Linux extension.

Oleg.

