Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXHGXJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXHGXJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765176AbXHGXJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:09:26 -0400
Received: from webmail.nxs.nl ([217.115.197.26]:43978 "EHLO webmail.nxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764800AbXHGXJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:09:25 -0400
X-Greylist: delayed 1541 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 19:09:24 EDT
Message-ID: <50598.213.84.80.149.1186526621.squirrel@webmail.nxs.nl>
Date: Wed, 8 Aug 2007 00:43:41 +0200 (CEST)
Subject: Inconsistent execve SIGTRAP-ing after ptraced child's 
     PTRACE_TRACEME.
From: "Eelis van der Weegen" <lkml@contacts.eelis.net>
To: linux-kernel@vger.kernel.org
Reply-To: lkml@contacts.eelis.net
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20070808004341_63024"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20070808004341_63024
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

How can a parent process intercepting a ptraced child's system calls using
PTRACE_SYSCALL know which SIGTRAP's are system call entries and which are system
call exits?

Since there does not seem to be a way for the parent to get this information
from the system, ptrace examples floating around on the web generally use a
boolean in_syscall flag that they toggle at each SIGTRAP. This mechanism seems
perfectly adequate, but for it to work correctly the flag must obviously be
appropriately initialized, and that is where things get vague.

Let's assume that the child's ptrace-ing begins after it first does
PTRACE_TRACEME and then calls execve. According to the ptrace man page, after
doing PTRACE_TRACEME "all subsequent calls to exec() by this process will cause
a SIGTRAP to be sent to it, giving the parent a chance to gain control before
the new program begins execution". The problem is that this does not specify
whether the parent will see SIGTRAP's for both entry to and exit from execve, or
only for exit from it. To my great surprise, I observed both behaviors on actual
machines (in particular, I observed the former on an x86_64 dual core machine).

This inconsistency foils the in_syscall flag approach, as there is no way to
know whether the parent should initialize that flag to true or false (since
apparently both can occur). Hence, my question is: is this behavior intentional?
Should there not be a guarantee that /either/ only the execve exit, /or/ both
entry and exit, are SIGTRAPed?

I have attached a testcase program. On some machines (2.6.18.8-0.5-default #1
SMP x86_64, and a 2.6.18.8-0.3-default #1 SMP i686) it shows only one initial
execve occurence, while on another (2.6.18-8.1.8.el5 #1 SMP x86_64, dual core)
it shows two.

Regards,

Eelis

------=_20070808004341_63024
Content-Type: text/x-csrc; name="ptracetest.c"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="ptracetest.c"


#include <assert.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <syscall.h>
#include <sys/reg.h>
#include <stdio.h>

#ifdef __x86_64__
#define SYSCALL_OFF (ORIG_RAX * 8)
#else
#define SYSCALL_OFF (ORIG_EAX * 4)
#endif

int main()
{
  pid_t const child = fork();

  if (child == -1) perror("fork failed");

  if(child == 0)
  {
    ptrace(PTRACE_TRACEME, 0, NULL, NULL);
    execl("/usr/bin/whoami", "whoami", NULL);
    perror("execl failed");
  }
  
  for(;;)
  {
    int status;
    wait(&status);

    if(WIFEXITED(status)) break;

    assert(WIFSTOPPED(status) && WSTOPSIG(status) == SIGTRAP);

    long const syscall = ptrace(PTRACE_PEEKUSER, child, SYSCALL_OFF, NULL);
    printf("%ld ", syscall);

    ptrace(PTRACE_SYSCALL, child, NULL, NULL);
  }

  printf("\n");

  return 0;
}
------=_20070808004341_63024--


