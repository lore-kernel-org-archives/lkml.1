Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYDNVKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYDNVKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYDNVKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:10:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37814 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbYDNVKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:10:33 -0400
Date: Mon, 14 Apr 2008 16:10:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
Message-ID: <20080414211030.GA28378@sergelap.austin.ibm.com>
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <m1od8tiom7.fsf@ebiederm.dsl.xmission.com> <20080403194418.GA11105@sergelap.austin.ibm.com> <20080404043902.GA14177@sergelap.austin.ibm.com> <47F8E824.6090600@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F8E824.6090600@colorfullife.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Manfred Spraul (manfred@colorfullife.com):
> Serge E. Hallyn wrote:
>>> diff --git a/ipc/namespace.c b/ipc/namespace.c
>>> index 9171d94..9044505 100644
>>> --- a/ipc/namespace.c
>>> +++ b/ipc/namespace.c
>>> @@ -48,6 +48,16 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, 
>>> struct ipc_namespace *ns)
>>>  	if (!(flags & CLONE_NEWIPC))
>>>  		return ns;
>>>
>>> +	if (!(flags & CLONE_SYSVSEM)) {
>>>     
>>
>> Wait, this should be opposite, right?
>>
>> [snip]
>> Manfred, I'm trying to test this, but can't get an error without this
>> patch.  Do you have a testcase?
>
> The patch is bogus, sorry that I didn't notice it immediately.
> The problem is ipc/sem.c, function find_undo, lookup_undo:
> lookup_undo doesn't check the namespace pointer, thus a simple single 
> threaded app can trigger the problem.
>
> Attached is a test app and a kernel patch that shows the problem.
> Run the test app immediately after boot (or within a new ipc namespace), 

Thanks, Manfred.  Basically what I was trying to do, except this appears
to actually work :)

So now when I replace fork+unshare(CLONE_NEWNS|CLONE_NEWIPC) with
clone(CLONE_NEWNS|CLONE_NEWIPC|CLONE_SYSVSEM) (moving the first semop
to before the clone), I do in fact manage to get an oops with the mmotm
I fetched this morning.  So I maintain that you do also need to ensure at
copy_namespaces() that if CLONE_NEWIPC is specified, then CLONE_SYSVSEM
is *not* specified (since, this being clone, specifying it means that
the semundo is shared with the parent).

thanks,
-serge

> otherwise the ipc sequence counter will prevent the app from triggering the 
> problem: The undo structure that was created before unshare() [i.e. with 1 
> semaphore in it] will be used after unshare() [i.e. semaphore 100 will be 
> accessed].
>
> With kernel debugging (full slub debugging) enabled, I even got an oops 
> when I tried to ipcrm the left over array after running undons, probably 
> because the undo structure was freed at exit_sem() within the new 
> namespace, but still used in the outer namespace.
>
> --
>    Manfred

> /*
>  * Copyright (C) 1999,2001 by Manfred Spraul.
>  * 
>  * Redistribution of this file is permitted under the terms of the GNU 
>  * General Public License (GPL)
>  * $Header: /home/manfred/cvs-tree/manfred/ipcsem/undotest.c,v 1.2 2003/06/28 15:19:43 manfred Exp $
>  */
> 
> #ifdef __LINUX__
> 	#define _GNU_SOURCE
> 	#include <sched.h>
> 	#include <wait.h>
> 	
> 	#define CLONE_NEWIPC		0x08000000	/* New ipcs */
> #endif
> #include <sys/types.h>
> #include <sys/ipc.h>
> #include <sys/sem.h>
> #include <stdlib.h>
> #include <stdio.h>
> #include <errno.h>
> #include <string.h>
> #include <assert.h>
> #include <signal.h>
> #include <time.h>
> #include <unistd.h>
> #include <pthread.h>
> 
> union semun {
> 	int val;
> 	struct semid_ds *buf;
> 	unsigned short int *array;
> 	struct seminfo* __buf;
> };
> 
> int getval(char * str, int id)
> {
> 	union semun arg;
> 	int res;
> 
> 	res = semctl(id,0,GETVAL,arg);
> 	if(res==-1) {
> 		printf("GETVAL failed for %s.\n", str);
> 		exit(4);
> 	}
> 	printf("   %s: GETVAL now %d.\n",str, res);
> 	return res;
> }
> 
> void setzero(int id)
> {
> 	union semun arg;
> 	int res;
> 
> 	arg.val = 0;
> 	res = semctl(id,0,SETVAL,arg);
> 	if(res==-1) {
> 		printf("SETVAL failed, errno %d.\n", errno);
> 		exit(4);
> 	}
> 	printf("   SETVAL succeeded.\n");
> }
> 
> 
> /* test1: verify that undo works at all. */
> int main(int argc,char** argv)
> {
> 	int res, id;
> 
> 	printf("  ****************************************\n");
> 
> 	/* create array */
> 	res = semget(IPC_PRIVATE, 1, 0700 | IPC_CREAT);
> 	printf(" got semaphore array %xh.\n",res);
> 	if(res == -1) {
> 		printf(" create failed.\n");
> 		return 1;
> 	}
> 	id = res;
> 
> 	setzero(id);
> 
> 	res = getval("test1 init", id);
> 	if (res != 0) {
> 		printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
> 		printf("Bad: got unexpected value.\n");
> 		exit(99);
> 	}
> 
> 	/* create sub-process */
> 	res = fork();
> 	if (res < 0) {
> 		printf("Fork failed (errno=%d). Aborting.\n", errno);
> 		res = semctl(id,1,IPC_RMID,NULL);
> 		exit(1);
> 	}
> 	fflush(stdout);
> 	if (!res) {
> 		struct sembuf sop[1];
> 		int id2;
> 
> 		sop[0].sem_num=0;
> 		sop[0].sem_op=1;
> 		sop[0].sem_flg=SEM_UNDO;
> 
> 		res = semop(id,sop,1);
> 		if(res==-1) {
> 			printf("semop failed.\n");
> 			exit(1);
> 		}
> 		res = getval("before unshare()", id);
> 		if (res != 1) {
> 			printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
> 			printf("Bad: got unexpected value.\n");
> 			exit(99);
> 		}
> 		fflush(stdout);
> 
> 		errno = 0;
> 		res = unshare(CLONE_NEWNS|CLONE_NEWIPC);
> 		printf("  unshare returned %d, errno now %d (expected: 0,0).\n", res, errno);
> 		fflush(stdout);
> 
> 		/* create array */
> 		res = semget(IPC_PRIVATE, 101, 0700 | IPC_CREAT);
> 		printf("  got semaphore array %xh.\n",res);
> 		if(res == -1) {
> 			printf(" create failed.\n");
> 			return 1;
> 		}
> 		id2 = res;
> 		printf("Now operating on id1=%x, id2=%x. (if both are equal, there will be a memory corruption)\n", id, id2);
> 
> 		/* child: */
> 		sop[0].sem_num=100;
> 		sop[0].sem_op=1;
> 		sop[0].sem_flg=SEM_UNDO;
> 
> 		// This operation should trash kernel memory  (if id1==id2)
> 		res = semop(id2,sop,1);
> 		if(res==-1) {
> 			printf("semop failed.\n");
> 			exit(1);
> 		}
> 		exit(1);
> 	} else {
> 		int retval;
> 		retval = wait4(res, NULL, 0, NULL);
> 		if (retval != res) {
> 			printf("wait4 returned unexpeted value %d, errno now %d.\n", 
> 					retval, errno);
> 		}
> 		res = getval("after exit", id);
> 		if (res != 0) {
> 			printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
> 			printf("Bad: got unexpected value.\n");
> 			return 1;
> 		}
> 	}
> 
> 	return 0;
> }

> diff --git a/ipc/sem.c b/ipc/sem.c
> index 0b45a4d..5c882f9 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1081,6 +1082,7 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
>  	new->id_next = sma->undo;
>  	sma->undo = new;
>  	sem_unlock(sma);
> +printk(KERN_ERR "find_undo(%p, %x) new undop %p (for %d sems).\n", ns, semid, new, nsems);
>  	un = new;
>  	spin_unlock(&ulp->lock);
>  out:
> @@ -1153,6 +1155,7 @@ retry_undos:
>  		error = PTR_ERR(sma);
>  		goto out_free;
>  	}
> +printk(KERN_ERR "find_undo(%p, %x) == %p, using %ld sems.\n", ns, semid, un, sma->sem_nsems);
> 
>  	/*
>  	 * semid identifiers are not unique - find_undo may have

