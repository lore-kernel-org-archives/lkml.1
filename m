Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbZCNQvA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 14 Mar 2009 12:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZCNQuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:50:50 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:42078 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZCNQut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:mime-version:content-type
         :message-id;
        b=nQI80w/PiAQ45/31+WM9lbQ4pMaiiJArFNmMv+Uym0JEtnieNDdqpm0yQFfm/sCdQH
         2h1ogwwpQim6+VYIzy4zzl3XkxtoVf18PVQHxowJzPMiBX2Nvq7qai6jmGNmkfSNHXIQ
         9WtH1QcANVqo9ylT7gRZ1N8X+21oHCd9QYbEg=
From: =?iso-8859-1?q?G=E1bor_Melis?= <mega@retes.hu>
To: linux-kernel@vger.kernel.org
Subject: Signal delivery order
Date: Sat, 14 Mar 2009 17:50:37 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dB+uJoQfxvmV3b5"
Message-Id: <200903141750.37238.mega@retes.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_dB+uJoQfxvmV3b5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

(Please CC me, I'm not subscribed.)

Attached is a test program that tests the order in which synchronously 
triggered sigsegvs and pthread_kill() generated signals get delivered.

The test program triggers sigsegvs from a thread and tests whether the 
the sigsegv handler is invoked when the sigusr1 handler is already 
running. If that happens it exits with exit code 27. It seems that if 
the signal is sent by pthread_kill() and its signum is lower than that 
of sigsegv then it can be delivered before sigsegv. A normal kill does 
not seem to do this.

I would expect that no asynchronously generated signal (and here I 
include those sent by pthread_kill()) can overtake a sigsegv even if 
its signum is lower.

Reaching this diagnosis led me to an identical looking issue documented 
at: http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4355769 .

Cheers,
Gabor Melis

PS: tested on x86 linux Debian Lenny, kernel: 2.6.26-1-686, glibc: 
2.7-18

--Boundary-00=_dB+uJoQfxvmV3b5
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

void test_handler(int signal, siginfo_t *info, void *context)
{
}

void sigsegv_handler(int signal, siginfo_t *info, void *context)
{
    /* The test signal is blocked only in test_handler. */
    if (is_signal_blocked(test_signal)) {
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
    test_with_pthread_kill();
    /* Forking and kill()ing works as expected: */
    /* test_with_kill(); */
}

--Boundary-00=_dB+uJoQfxvmV3b5--
