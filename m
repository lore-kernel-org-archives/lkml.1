Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbXEWMZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbXEWMZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758454AbXEWMZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:25:40 -0400
Received: from [198.99.130.12] ([198.99.130.12]:34192 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbXEWMZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:25:39 -0400
Date: Wed, 23 May 2007 08:19:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Roland McGrath <roland@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current utrace breaks UML
Message-ID: <20070523121902.GA4365@c2.user-mode-linux.org>
References: <20070522213831.GB10293@c2.user-mode-linux.org> <20070523064611.3BD151F8510@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523064611.3BD151F8510@magilla.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 11:46:11PM -0700, Roland McGrath wrote:
> Do you have a test case for PTRACE_SYSEMU that does not work right?

UML, obviously.  Below is a smaller test.  orig_eax is wrong, so you
can't read the system call number from the process.

With kernel-2.6.20-1.2948, it prints out a bunch of -1's.  On FC5
kernels, you get more reasonable numbers.

				Jeff

-- 
Work email - jdike at linux dot intel dot com


#include <stdlib.h>
#include <stdio.h>
#include <asm/unistd.h>
#include <sys/mman.h>
#include <sys/ptrace.h>
#include <asm/ptrace.h>
#include <sys/wait.h>

#define PTRACE_SYSEMU		  31
#define PAGE_SIZE 4096

static inline long stub_syscall0(long syscall)
{
	long ret;

	__asm__ volatile ("int $0x80" : "=a" (ret) : "0" (syscall));

	return ret;
}

static void child(void)
{
	if(ptrace(PTRACE_TRACEME, 0, 0, 0) < 0){
		perror("traceme");
		exit(1);
	}

	kill(getpid(), SIGUSR1);
	stub_syscall0(__NR_getpid);
}

int main(void)
{
	void *stack;
	unsigned long sp, regs[FRAME_SIZE];
	int pid, n, status;

	stack = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC,
		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if(stack == MAP_FAILED){
		perror("mmap");
		exit(1);
	}

	sp = (unsigned long) stack + PAGE_SIZE - sizeof(void *);
	pid = fork();
	if(pid < 0)
		perror("fork");
	else if(pid == 0){
		child();
	}
	else {
		while(1){
			n = waitpid(pid, &status, WUNTRACED);
			if(n < 0){
				perror("waitpid");
				exit(1);
			}

			n = ptrace(PTRACE_GETREGS, pid, 0, regs);
			if(n < 0){
				perror("PTRACE_GETREGS");
				exit(1);
			}

			printf("Status 0x%x orig_eax 0x%x\n", status,
			       regs[ORIG_EAX]);

			if(ptrace(PTRACE_SYSEMU, pid, 0, 0)){
				perror("PTRACE_SYSEMU");
				exit(1);
			}
		}
	}

	return 0;
}
