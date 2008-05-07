Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbYEGJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbYEGJWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYEGJWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:22:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47010 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYEGJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:21:58 -0400
Message-ID: <4821744C.9070805@oracle.com>
Date: Wed, 07 May 2008 17:20:12 +0800
From: wenji huang <wenji.huang@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: possible regression of ptrace on 2.6.26-rc1
References: <481FCE51.7060604@oracle.com> <20080506080159.0638E26FA20@magilla.localdomain>
In-Reply-To: <20080506080159.0638E26FA20@magilla.localdomain>
Content-Type: multipart/mixed;
 boundary="------------080400030702060601010501"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080400030702060601010501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

When I tried the test case (ptrace-syscall-ret) on 2.6.26-rc1 kernel, 
found it always fails, but could pass on previous ones.

Here is the result (both in x86 and x86_64 box):

[wjhuang@10-182-121-27 single-test]$ ./ptrace-syscall-ret
./ptrace-syscall-ret: PTRACE_CONT, pid 17315, retvalue -1: No such process

In the case, a child is created and kept in syscall loop. The parent 
will trace the syscall and kill the child at last. It seems the child
is early exited, but should stay in infinite loop. Is this my 
misunderstanding or actual regression of kernel?

The test case is attached to the mail.

Thanks,
Wenji


--------------080400030702060601010501
Content-Type: text/x-csrc;
 name="ptrace-syscall-ret.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ptrace-syscall-ret.c"

#include <signal.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <sys/user.h>
#include <unistd.h>
#include <sched.h>
#include <assert.h>
#include <asm/unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <error.h>
#include <errno.h>
	      
#if defined __x86_64__ || defined __i386__
#define LOOP 10

static pid_t child;      

static void
cleanup (void)
{
  if (child != 0)
    kill (child, SIGKILL);
}

static void
handler_fail (int signo)
{
  cleanup ();

  signal (SIGABRT, SIG_DFL);
  assert (0);
}


int main(int argc, char **argv) {
     int status, j;
     long l;	      
     pid_t pid;

     setbuf (stdout, NULL);
     atexit (cleanup);
     signal (SIGABRT, handler_fail);

     child = fork();
     switch (child) 
     {
	case -1:
		assert(0);
	case 0:  
	  {  l = ptrace(PTRACE_TRACEME, 0, 0, 0);
	     assert(l==0);
	     raise(SIGSTOP);
	     while (1) { 
		l = access(".",R_OK);
		assert(l==0);
	     }	
	     assert(0); //not reached
	   } //end child
	default:
	    break;
         }
    	
 	pid = waitpid(child, &status, 0); 
	assert(pid==child);

        assert(WIFSTOPPED(status));
        assert(WSTOPSIG(status) == SIGSTOP);

	l = ptrace(PTRACE_SYSCALL,child, 0, 0);
	assert(l==0);

       	j = 0;
	while (j < LOOP){

	      pid = waitpid(child, &status, 0);
	      assert(child==pid);
		
	      assert(WIFSTOPPED(status));
	      assert(WSTOPSIG(status) == SIGTRAP);

       	      l = ptrace(PTRACE_SYSCALL, child, 0, 0);
	      assert(l==0);
	      j++;
         } //end loop

	l = ptrace(PTRACE_CONT, child, 0, SIGKILL);
	//if the following statement, always successful
	//l = ptrace(PTRACE_KILL, child, 0,0); 
	if (l < 0) {
   	    error (0, errno,"PTRACE_CONT, pid %ld, retvalue %ld",(long)child,l);
  	    return 1;
	}	
	else
	    assert(l==0);

	pid = waitpid(child, &status, 0);
	assert(child==pid);

	if (WIFEXITED(status) && WTERMSIG(status)!=SIGKILL) 
	      return 1;
	return 0;
} //end main
	      
#else
int main(int argc, char **argv) {
	return 77;
}
#endif

--------------080400030702060601010501--
