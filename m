Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYK0TMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYK0TMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 14:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYK0TMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 14:12:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:54590 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYK0TMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 14:12:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iH9GtkIf7Pt5nn9PkX1+Q0N++HeTAUu4RCQvUVE1iVbEXpOgx954SKgnY4jER/qC0s
         yKQ4x/P1ZohluTChCfonPjDUf943BUgAhqOU74sZ2lIzhLhEqkxkmLFPI03pAGd8/ihM
         K+ERshNQNUjnXBDh9YBIgB5mXNbRndzLcN7s4=
Date: Thu, 27 Nov 2008 22:12:35 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [PATCH 2/5] x86: ret_from_fork - get rid of jump back
Message-ID: <20081127191234.GD23593@localhost>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com> <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com> <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com> <874p1u45ke.fsf@basil.nowhere.org> <20081126201054.GB2624@localhost> <20081127134121.GA22736@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081127134121.GA22736@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Thu, Nov 27, 2008 at 02:41:21PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
...
| 
| Could you test something like the patch attached below, which cleans 
| up this code and applies the code reduction and speedup? Warning: 
| completely untested! Please check that things like strace -f and gdb 
| attaching to forked tasks still works fine. (it should by all means)
| 
| Thanks,
| 
| 	Ingo

Ingo, I found 2.6.26 test machine where I've patched the entry_64.S
in a manner you pointed. So here is a test program and strace output.
Seems all works fine. Didn't check "audit" code which I simply don't
know how to be done.
 
		- Cyrill -
---

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int pid;

	pid = fork();

	if (pid < 0) {
		fprintf(stderr, "Fork failed!\n");
		exit(-1);
	}

	else if (pid == 0) {
		printf("I am the child, return from fork=%d\n", pid);
	} else {
	  printf("I am the parent, return from fork, child pid=%d\n", pid);
	  printf("Parent exiting!\n");
	  exit(0);
	}
}
---

5897  execve("./main", ["./main"], [/* 18 vars */]) = 0
5897  brk(0)                            = 0x2514000
5897  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa0e517f000
5897  access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
5897  mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa0e517d000
5897  access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
5897  open("/etc/ld.so.cache", O_RDONLY) = 3
5897  fstat(3, {st_mode=S_IFREG|0644, st_size=48530, ...}) = 0
5897  mmap(NULL, 48530, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fa0e5171000
5897  close(3)                          = 0
5897  access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
5897  open("/lib/libc.so.6", O_RDONLY)  = 3
5897  read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\220\345"..., 832) = 832
5897  fstat(3, {st_mode=S_IFREG|0755, st_size=1502520, ...}) = 0
5897  mmap(NULL, 3609304, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7fa0e4bf0000
5897  mprotect(0x7fa0e4d59000, 2093056, PROT_NONE) = 0
5897  mmap(0x7fa0e4f58000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x168000) = 0x7fa0e4f58000
5897  mmap(0x7fa0e4f5d000, 17112, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fa0e4f5d000
5897  close(3)                          = 0
5897  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa0e5170000
5897  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fa0e516f000
5897  arch_prctl(ARCH_SET_FS, 0x7fa0e516f6e0) = 0
5897  mprotect(0x7fa0e4f58000, 16384, PROT_READ) = 0
5897  mprotect(0x7fa0e5180000, 4096, PROT_READ) = 0
5897  munmap(0x7fa0e5171000, 48530)     = 0
5897  clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fa0e516f770) = 5898
5897  fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(5, 1), ...}) = 0
5898  fstat(1,  <unfinished ...>
5897  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS <unfinished ...>
5898  <... fstat resumed> {st_mode=S_IFCHR|0600, st_rdev=makedev(5, 1), ...}) = 0
5897  <... ioctl resumed> , {B38400 opost isig icanon echo ...}) = 0
5897  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
5898  ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS <unfinished ...>
5897  <... mmap resumed> )              = 0x7fa0e517c000
5898  <... ioctl resumed> , {B38400 opost isig icanon echo ...}) = 0
5897  write(1, "I am the parent, return from for"..., 50 <unfinished ...>
5898  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
5897  <... write resumed> )             = 50
5898  <... mmap resumed> )              = 0x7fa0e517c000
5897  write(1, "Parent exiting!\n", 16 <unfinished ...>
5898  write(1, "I am the child, return from fork"..., 35 <unfinished ...>
5897  <... write resumed> )             = 16
5898  <... write resumed> )             = 35
5897  exit_group(0)                     = ?
5898  exit_group(0)                     = ?
---
