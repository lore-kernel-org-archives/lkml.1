Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZHRLuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZHRLuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZHRLuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:50:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53306 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZHRLue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:50:34 -0400
Date: Tue, 18 Aug 2009 13:45:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: stephane eranian <eranian@googlemail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: F_SETOWN_TID: F_SETOWN was thread-specific for a while
Message-ID: <20090818114533.GA32289@redhat.com>
References: <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com> <20090809054601.GA26152@shareable.org> <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com> <20090810170338.GA14223@redhat.com> <7c86c4470908101401k49f42788o25eb1efaa631f065@mail.gmail.com> <20090817171605.GB15907@redhat.com> <7c86c4470908171526j60add584qfc635ba91cd4df46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470908171526j60add584qfc635ba91cd4df46@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18, stephane eranian wrote:
>
> On Mon, Aug 17, 2009 at 7:16 PM, Oleg Nesterov<oleg@redhat.com> wrote:
> > Sorry for late reply...
> >
> > On 08/10, stephane eranian wrote:
> >>
> >> On Mon, Aug 10, 2009 at 7:03 PM, Oleg Nesterov<oleg@redhat.com> wrote:
> >> >
> >> > Not sure if it is safe to change the historical behaviour.
> >> >
> >> Don't need to change it.
> >
> > Good,
> >
> >> But for SIGIO, if you see SA_SIGINFO, then pass the si_fd.
> >
> > But this means we do change the behaviour ;) Confused.
> >
> I meant do not remove F_SETSIG and its side-effect on si_fd.

Ah, now I see what you meant.

> > In any case. We should not look at SA_SIGINFO at all. If sys_sigaction() was
> > called without SA_SIGINFO, then it doesn'matter if we send SEND_SIG_PRIV or
> > siginfo_t with the correct si_fd/etc.
> >
> What's the official role of SA_SIGINFO? Pass a siginfo struct?
>
> Does POSIX describe the rules governing the content of si_fd?
> Or is si_fd a Linux-ony extension in which case it goes with F_SETSIG.

Not sure I understand your concern...

OK. You suggest to pass siginfo_t with .si_fd/etc when we detect SA_SIGINFO.

But, in that case we can _always_ pass siginfo_t, regardless of SA_SIGINFO.
If the task has a signal handler and sigaction() was called without
SA_SIGINFO, then the handler must not look into *info (the second arg of
sigaction->sa_sigaction). And in fact, __setup_rt_frame() doesn't even
copy the info to the user-space:

	if (ka->sa.sa_flags & SA_SIGINFO) {
		if (copy_siginfo_to_user(&frame->info, info))
			return -EFAULT;
	}

OK? Or I missed something?

> > And again, this is even documented. The change is trivial but user-space
> > visible, it may confuse the (stupid) app which uses SIGIO + SA_SIGINFO
> > without F_SETSIG.
> >
> That would be an app that uses SIGINFO and fiddles with si_fd which has no
> defined content. What kind of app would that be?

The stupid app. But it is always unsafe to make the user-visible changes
without good reasons. Even when we fix the bug (and the current code is not
buggy) sometimes we have "this patch breaks my app or test-case!" reports.
If nothing else, we can break the test-case which simply does

	void sigio_handler(int sig, siginfo_t *info, void *u)
	{
		assert(info->si_code == 0 && info->si_code = 0x80);
	}

Once again: this is _documented_ !

And we can't set .si_fd = fd whithout changing .si_code, this will break
copy_siginfo_to_user().

Or. Suppose that some app does:

	void io_handler(int sig, siginfo_t *info, void *u)
	{
		if ((info->si_code & __SI_MASK) != SI_POLL) {
			// RT signal failed! sig MUST be == SIGIO
			recover();
		} else {
			do_something(info->si_fd);
		}
	}

	int main(void)
	{
		sigaction(SIGRTMIN, { SA_SIGINFO, io_handler });
		sigaction(SIGIO,    { SA_SIGINFO, io_handler });
		...
	}

This is correct. But if we change the current behaviour, this app won't
be able to detect the overflow.

> It would seem natural that in the siginfo passed to the handler of SIGIO, the
> file descriptor be passed by default. That is all I am trying to say here.

Completely agreed! I was always puzzled by send_sigio_to_task(). I was never
able to understand why it looks so strange.

So, I think it should be

	static void send_sigio_to_task(struct task_struct *p,
				       struct fown_struct *fown,
				       int fd,
				       int reason)
	{
		siginfo_t si;
		/*
		 * F_SETSIG can change ->signum lockless in parallel, make
		 * sure we read it once and use the same value throughout.
		 */
		int signum = ACCESS_ONCE(fown->signum) ?: SIGIO;

		if (!sigio_perm(p, fown, signum))
			return;

		si.si_signo = signum;
		si.si_errno = 0;
		si.si_code  = reason;
		si.si_fd    = fd;
		/* Make sure we are called with one of the POLL_*
		   reasons, otherwise we could leak kernel stack into
		   userspace.  */
		BUG_ON((reason & __SI_MASK) != __SI_POLL);
		if (reason - POLL_IN >= NSIGPOLL)
			si.si_band  = ~0L;
		else
			si.si_band = band_table[reason - POLL_IN];

		/* Failure to queue an rt signal must be reported as SIGIO */
		if (!group_send_sig_info(signum, &si, p))
			group_send_sig_info(SIGIO, SEND_SIG_PRIV, p);
	}

(except it should be on top of fcntl-add-f_etown_ex.patch).
This way, at least we don't break the "detect RT signal failed" above.

What do you think?

But let me repeat: I just can't convince myself we have a good reason
to change the strange, but carefully documented behaviour.

In case you agree with the code above, I can send the patch. But only
if I have a "good" changelog from you + your Signed-of-by in advance ;)

Otherwise, please feel free to send this/similar change yourself.

Oleg.

