Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZCRJCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZCRJCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbZCRJCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:02:17 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61609 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbZCRJCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=ig3S5Y/MgzRvBL4+vU7UoIPXtKz7dEsxJYqv0NwZwIYBu4krFww5uz/B2+aZ7K1Xs0
         fmRkxEVThtNHex3md80FeoTWNhPnkYIDwU/zhrA0mr3RbQkHG2N+j/hl7qTcSeRsqY5k
         s7Exl6R5m/poRIREP2P5IuIY2zAbXjBy7sV/M=
From: =?iso-8859-1?q?G=E1bor_Melis?= <mega@retes.hu>
To: Roland McGrath <roland@redhat.com>
Subject: Re: RT signal queue overflow (Was: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order))
Date: Wed, 18 Mar 2009 10:02:07 +0100
User-Agent: KMail/1.9.9
Cc: Oleg Nesterov <oleg@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
References: <200903141750.37238.mega@retes.hu> <20090317041337.GA29740@redhat.com> <20090318075901.4FA19FC3AB@magilla.sf.frob.com>
In-Reply-To: <20090318075901.4FA19FC3AB@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PiLwJbADa4yKtbp"
Message-Id: <200903181002.07584.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_PiLwJbADa4yKtbp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mi=E9rcoles 18 Marzo 2009, Roland McGrath wrote:
> > First of all, perhaps I missed somethings and this is solvable
> > without kernel changes, but I can't see how.
>
> It depends what kind of "solved" you mean.
>
> Signals pending for the thread are always delivered before signals
> pending for the process.  POSIX does not guarantee this to the
> application, but it has always been so in Linux and it's fine enough
> to rely on that.  Truly externally-generated and asynchronous signals
> go to the process, so it's really only pthread_kill use within your
> own program that raises the issue.
>
> Among signals pending for the thread, signals < SIGRTMIN are always
> delivered before ones >=3D SIGRTMIN.  POSIX does not guarantee this to
> the application, but it has always been so in Linux and it's fine
> enough to rely on that.  The most sensible thing to use with
> pthread_kill is some SIGRTMIN+n signal anyway, since they are never
> confused with any other use. If your program is doing that, you don't
> have a problem.

It was just a month or so ago when I finally made to change to use a=20
non-real-time signal for signalling stop-for-gc. It was motivated by=20
the fact that even with rt signals there needs to be a fallback=20
mechanism for when the rt signal queue overflows. Another reason was=20
that _different processes_ could interfere with each other: if one=20
filled the queue the other processes would hang too (there was no=20
fallback mechanism implemented). From this behaviour, it seemed that=20
the rt signal queue was global. Attached is a test program that=20
reproduces this.=20

$ gcc -lpthread rt-signal-queue-overflow.c
$ (./a.out &); sleep 1; ./a.out
pthread_kill returned EAGAIN, errno=3D0, count=3D24566
pthread_kill returned EAGAIN, errno=3D0, count=3D0

There are two notable things here. The first is that pthread_kill=20
returns EAGAIN that's not mentioned on the man page, but does not set=20
errno. The other is that the first process filled the rt signal queue=20
and the second one could not send a single signal successfully.

Granted, without a fallback mechanism my app deserved to lose. However,=20
it seemed to me that there were other programs lacking in this regard=20
on my desktop as I managed to hang a few of them.

Even though within my app I could have guarenteed that the number of=20
pending rt signals is below a reasonable limit, there was no way to=20
defend against other processes filling up the queue so I had to=20
implement fallback mechanism that used non-rt signals (changing a few=20
other things as well) and when that was done, there was no reason to=20
keep the rt signal based one around.

Consider this another quality-of-implementation report.

> So on the one hand it seems pretty reasonable to say it's "solved" by
> accepting it when we say, "Welcome to Unix, these things should have
> stopped surprising you in the 1980s."  It's a strange pitfall of how
> everything fits together, granted.  But you do sort of have to make
> an effort to do things screwily before you can fall into it.
>
> All that said, it's actually probably a pretty easy hack to arrange
> that the signal posted by force_sig_info is the first one dequeued in
> all but the most utterly strange situations.
>
>
> Thanks,
> Roland

--Boundary-00=_PiLwJbADa4yKtbp
Content-Type: text/x-csrc;
  charset="iso 8859-15";
  name="rt-signal-queue-overflow.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rt-signal-queue-overflow.c"

#include <signal.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/ucontext.h>
#include <unistd.h>
#include <errno.h>

int test_signal;

void test_handler(int signal, siginfo_t *info, void *context)
{
}

void install_handlers(void)
{
    struct sigaction sa;
    sa.sa_flags = SA_SIGINFO;
    sigemptyset(&sa.sa_mask);
    sa.sa_sigaction = test_handler;
    sigaction(test_signal, &sa, 0);
}

int main(void)
{
    sigset_t sigset;
    test_signal = SIGRTMIN;
    install_handlers();
    sigemptyset(&sigset);
    sigaddset(&sigset, SIGRTMIN);
    sigprocmask(SIG_BLOCK, &sigset, 0);
    {
        int r;
        int count = 0;
        do {
            r = pthread_kill(pthread_self(), test_signal);
            if (r == EAGAIN) {
                printf("pthread_kill returned EAGAIN, errno=%d, count=%d\n",
                       errno, count);
                sleep(2);
                exit(27);
            }
            if (!r)
                count++;
        } while (!r);
    }
}

--Boundary-00=_PiLwJbADa4yKtbp--
