Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZHTKAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZHTKAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZHTKAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:00:41 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:34242 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZHTKAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Qyk7prGMxnIeMZMpD+zTjmUUvUPOMFLsGNwg8sMTkSHMxdoR+XOq7r/h2YffghkbRL
         TALRAT/5rRYjfO/imf8g5dlOwg+aUkPJRBJW+FGlnhzxHyH8Ne7wEIi+3JJ0GgzHxDZJ
         yZh4a0cZ/95YWZIexbJ3/ZmAIcxeLfKLTRglQ=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090818114533.GA32289@redhat.com>
References: <20090730202804.GA13675@redhat.com>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com>
	 <20090809054601.GA26152@shareable.org>
	 <7c86c4470908100522q44dc1228i315b29d69fc98da3@mail.gmail.com>
	 <20090810170338.GA14223@redhat.com>
	 <7c86c4470908101401k49f42788o25eb1efaa631f065@mail.gmail.com>
	 <20090817171605.GB15907@redhat.com>
	 <7c86c4470908171526j60add584qfc635ba91cd4df46@mail.gmail.com>
	 <20090818114533.GA32289@redhat.com>
Date: Thu, 20 Aug 2009 12:00:40 +0200
Message-ID: <7c86c4470908200300y2f4a22f3re09ea49ccf0d81d5@mail.gmail.com>
Subject: Re: F_SETOWN_TID: F_SETOWN was thread-specific for a while
From: stephane eranian <eranian@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg,

On Tue, Aug 18, 2009 at 1:45 PM, Oleg Nesterov<oleg@redhat.com> wrote:
> On 08/18, stephane eranian wrote:
>> > In any case. We should not look at SA_SIGINFO at all. If sys_sigaction() was
>> > called without SA_SIGINFO, then it doesn'matter if we send SEND_SIG_PRIV or
>> > siginfo_t with the correct si_fd/etc.
>> >
>> What's the official role of SA_SIGINFO? Pass a siginfo struct?
>>
>> Does POSIX describe the rules governing the content of si_fd?
>> Or is si_fd a Linux-ony extension in which case it goes with F_SETSIG.
>
> Not sure I understand your concern...
>
> OK. You suggest to pass siginfo_t with .si_fd/etc when we detect SA_SIGINFO.
>
The reason I refer to SA_SIGINFO is simply because of the excerpt from the
sigaction man page:

       If  SA_SIGINFO  is specified in sa_flags, then sa_sigaction (instead of
       sa_handler) specifies the signal-handling function  for  signum.   This
       function receives the signal number as its first argument, a pointer to
       a siginfo_t as its second argument and a pointer to a ucontext_t  (cast
       to void *) as its third argument.

In other words, I use this to emphasize the fact that to get a siginfo
struct, you need to pass SA_SIGINFO and use sa_sigaction instead of
sa_handler. That's all I am saying.


> But, in that case we can _always_ pass siginfo_t, regardless of SA_SIGINFO.
> If the task has a signal handler and sigaction() was called without
> SA_SIGINFO, then the handler must not look into *info (the second arg of
> sigaction->sa_sigaction). And in fact, __setup_rt_frame() doesn't even
> copy the info to the user-space:
>
>        if (ka->sa.sa_flags & SA_SIGINFO) {
>                if (copy_siginfo_to_user(&frame->info, info))
>                        return -EFAULT;
>        }
>
> OK? Or I missed something?
>
No, I think we are in agreement. To get meaningful siginfo use SA_SIGINFO.

> Or. Suppose that some app does:
>
>       void io_handler(int sig, siginfo_t *info, void *u)
>       {
>               if ((info->si_code & __SI_MASK) != SI_POLL) {
>                      // RT signal failed! sig MUST be == SIGIO
>                       recover();
>               } else {
>                      do_something(info->si_fd);
>               }
>       }
>
>       int main(void)
>       {
>               sigaction(SIGRTMIN, { SA_SIGINFO, io_handler });
>               sigaction(SIGIO,    { SA_SIGINFO, io_handler });
>               ...
>       }
>
I don't think you can check si_code without first checking which
signal it is in si_signo. The values for si_code overlap between
the different struct in siginfo->_sifields.

>> It would seem natural that in the siginfo passed to the handler of SIGIO, the
>> file descriptor be passed by default. That is all I am trying to say here.
>
> Completely agreed! I was always puzzled by send_sigio_to_task(). I was never
> able to understand why it looks so strange.
>
> So, I think it should be
>
>        static void send_sigio_to_task(struct task_struct *p,
>                                       struct fown_struct *fown,
>                                       int fd,
>                                       int reason)
>        {
>                siginfo_t si;
>                /*
>                 * F_SETSIG can change ->signum lockless in parallel, make
>                 * sure we read it once and use the same value throughout.
>                 */
>                int signum = ACCESS_ONCE(fown->signum) ?: SIGIO;
>
>                if (!sigio_perm(p, fown, signum))
>                        return;
>
>                si.si_signo = signum;
>                si.si_errno = 0;
>                si.si_code  = reason;
>                si.si_fd    = fd;
>                /* Make sure we are called with one of the POLL_*
>                   reasons, otherwise we could leak kernel stack into
>                   userspace.  */
>                BUG_ON((reason & __SI_MASK) != __SI_POLL);
>                if (reason - POLL_IN >= NSIGPOLL)
>                        si.si_band  = ~0L;
>                else
>                        si.si_band = band_table[reason - POLL_IN];
>
>                /* Failure to queue an rt signal must be reported as SIGIO */
>                if (!group_send_sig_info(signum, &si, p))
>                        group_send_sig_info(SIGIO, SEND_SIG_PRIV, p);
>        }
>
> (except it should be on top of fcntl-add-f_etown_ex.patch).
> This way, at least we don't break the "detect RT signal failed" above.
>
> What do you think?
>
> But let me repeat: I just can't convince myself we have a good reason
> to change the strange, but carefully documented behaviour.
>
I agree with you. Given the existing documentation in the man page
of fcntl() and the various code examples. I think it is possible for
developers to figure out how to get the si_fd in the handler. This
problem is not specific to perf_counters nor perfmon. Any SIGIO-based
program may be interested in getting si_fd, therefore I am assuming the
solution is well understood at this point.
