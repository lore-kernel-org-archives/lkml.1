Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbZCOWHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbZCOWHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 18:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759189AbZCOWHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 18:07:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:49099 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZCOWHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 18:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:message-id;
        b=vp4/6IBlCmYhVzrTUed1YVUg6S4DhbCopA+sUEU+Q6p+rIXvYmVcx6WSfuVbkRvE+J
         hdzt/00IGGnazm5N8cjSvqBASe54GSRt1G+CX1jRb+T1Akr2WGgRctYp6XGJiNzyW5ES
         1mRB06+vHV7tisWlMrMl95pO0BDXf+KXQo+r8=
From: =?iso-8859-1?q?G=E1bor_Melis?= <mega@retes.hu>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: Signal delivery order
Date: Sun, 15 Mar 2009 23:06:52 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200903141750.37238.mega@retes.hu> <200903151540.00542.mega@retes.hu> <20090315172926.GA21095@redhat.com>
In-Reply-To: <20090315172926.GA21095@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9vXvJTXwTWsroo3"
Message-Id: <200903152306.53031.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9vXvJTXwTWsroo3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Domingo 15 Marzo 2009, Oleg Nesterov wrote:
> On 03/15, G=E1bor Melis wrote:
> > On Domingo 15 Marzo 2009, Oleg Nesterov wrote:
> > > If test_signal (SIGUSR1) is blocked, this means it is already
> > > delivered, and the handler will be invoked when we return from
> > > sigsegv_handler(), please see below.
> >
> > SIGUSR1 is delivered, its sigmask is added to the current mask but
> > the handler is not yet invoked and in this instant synchronous
> > sigsegv is delivered, its handler invoked?
>
> Can't understand the question. Could you reiterate?

No need, my question was answered below.

> > > When sigprocmask(SIG_UNBLOCK) returns, both signals are
> > > delivered. The kernel deques 1 first, then 2. This means that the
> > > handler for "2" will be called first.
> >
> > My mental model that matches what I quickly glean from the sources
> > (from kernel/signal.c, arch/x86/kernel/signal_32.c) goes like this:
> >
> > - signal 1 and signal 2 are generated and made pending
> > - they are unblocked by sigprocmask
> > - signal 1 is delivered: signals in its mask (only itself here) are
> > blocked
>
> yes.
>
> the kernel changes ip (instruction pointer) to sig_1.
>
> > its handler is invoked
>
> no.
>
> We never return to user-space with a pending signal. We dequeue
> signal 2 too, and change ip to sig_2.
>
> Now, since there are no more pending signals, we return to the user
> space, and start sig_2().

I see. I guess in addition to changing the ip, the stack frobbing magic=20
arranges that sig_2 returns to sig_1 or some code that calls sig_1.

=46rom the point of view of sig_2 it seems that sig_1 is already invoked=20
because it has its sigmask in effect and the ip in the ucontext of=20
sig_2 points to sig_1 as the attached signal-test.c shows:

sig_1=3D80485a7
sig_2=3D80485ed
2 1
eip: 80485a7
1 0
eip: b7fab424

The revised signal-delivery-order.c (also attached) outputs:

test_handler=3D8048727
sigsegv_handler=3D804872c
eip: 8048727
esp: b7d94cb8

which shows that sigsegv_handler also has incorrect eip in the context.

--Boundary-00=_9vXvJTXwTWsroo3
Content-Type: text/x-csrc;
  charset="iso 8859-15";
  name="signal-delivery-order.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="signal-delivery-order.c"

#include <signal.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/ucontext.h>
#include <unistd.h>

int test_signal;
int *page_address;
pthread_t tid;

int is_signal_blocked(int signum)
{
    sigset_t set;
    pthread_sigmask(SIG_BLOCK, 0, &set);
    return (sigismember(&set, signum));
}

void *eip(struct ucontext *context)
{
    return (void *)context->uc_mcontext.gregs[14];
}

void test_handler(int signal, siginfo_t *info, void *context)
{
}

void sigsegv_handler(int signal, siginfo_t *info, void *context)
{
    /* The test signal is blocked only in test_handler. */
    if (is_signal_blocked(test_signal)) {
        printf("eip: %x\n", eip(context));
        _exit(27);
    }
    mprotect(page_address, 4096, PROT_READ | PROT_WRITE);
}

void *make_faults(void *arg)
{
    while (1) {
        mprotect(page_address, 4096, PROT_NONE);
        *page_address = 1;
    }
}

void *reserve_page(void)
{
    int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
    void *actual = mmap(0, 4096, PROT_NONE, flags, -1, 0);
    if (actual == MAP_FAILED) {
        perror("mmap");
        return 0;
    }
    return actual;
}

void install_handlers(void)
{
    struct sigaction sa;
    sa.sa_flags = SA_SIGINFO;
    sigemptyset(&sa.sa_mask);
    sa.sa_sigaction = test_handler;
    sigaction(test_signal, &sa, 0);
    sa.sa_sigaction = sigsegv_handler;
    sigaction(SIGSEGV, &sa, 0);
}

void test_with_pthread_kill()
{
    page_address = (int *)reserve_page();
    install_handlers();
    if (pthread_create(&tid, 0, make_faults, 0) < 0)
        perror("pthread_create");
    while(1) {
        pthread_kill(tid, test_signal);
    }
}

void test_with_kill()
{
    pid_t pid = fork();
    if (pid == 0) {
        page_address = (int *)reserve_page();
        install_handlers();
        make_faults(0);
    } else {
        while (1) {
            kill(pid, test_signal);
        }
    }
}

int main(void)
{
    test_signal = SIGUSR1;
    printf("test_handler=%x\n", test_handler);
    printf("sigsegv_handler=%x\n", sigsegv_handler);
    test_with_pthread_kill();
    /* Forking and kill()ing works as expected: */
    /* test_with_kill(); */
}

--Boundary-00=_9vXvJTXwTWsroo3
Content-Type: text/x-csrc;
  charset="iso 8859-15";
  name="signal-test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="signal-test.c"

#include <syscall.h>
#include <signal.h>
#include <stdio.h>
#include <ucontext.h>

int is_blocked(int sig)
{
    sigset_t set;
    sigprocmask(SIG_BLOCK, NULL, &set);
    return sigismember(&set, sig);
}

void *eip(struct ucontext *context)
{
    return (void *)context->uc_mcontext.gregs[14];
}

void sig_1(int sig, siginfo_t *info, struct ucontext *context)
{
    printf("%d %d\n", sig, is_blocked(2));
    printf("eip: %x\n", eip(context));
}

void sig_2(int sig, siginfo_t *info, struct ucontext *context)
{
    printf("%d %d\n", sig, is_blocked(1));
    printf("eip: %x\n", eip(context));
}

int tkill(int tid, int sig)
{
    syscall(SYS_tkill, tid, sig);
}

int main(void)
{
    sigset_t set;

    struct sigaction sa;
    sa.sa_flags = SA_SIGINFO;
    sigemptyset(&sa.sa_mask);
    sa.sa_sigaction = sig_1;
    sigaction(1, &sa, 0);
    sa.sa_sigaction = sig_2;
    sigaction(2, &sa, 0);

    sigemptyset(&set);
    sigaddset(&set, 1);
    sigaddset(&set, 2);
    printf("sig_1=%x\n", sig_1);
    printf("sig_2=%x\n", sig_2);
    sigprocmask(SIG_BLOCK, &set, NULL);

    kill(getpid(), 1);
    kill(getpid(), 2);

    sigprocmask(SIG_UNBLOCK, &set, NULL);

    return 0;
}

--Boundary-00=_9vXvJTXwTWsroo3--
