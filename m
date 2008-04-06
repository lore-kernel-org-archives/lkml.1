Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYDFPLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYDFPLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 11:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYDFPLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 11:11:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:55510 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYDFPLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:11:38 -0400
Message-ID: <47F8E824.6090600@colorfullife.com>
Date: Sun, 06 Apr 2008 17:11:32 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [RFC, PATCH] fix SEM_UNDO with namespaces
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <m1od8tiom7.fsf@ebiederm.dsl.xmission.com> <20080403194418.GA11105@sergelap.austin.ibm.com> <20080404043902.GA14177@sergelap.austin.ibm.com>
In-Reply-To: <20080404043902.GA14177@sergelap.austin.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------080107060500050905010303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080107060500050905010303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Serge E. Hallyn wrote:
>> diff --git a/ipc/namespace.c b/ipc/namespace.c
>> index 9171d94..9044505 100644
>> --- a/ipc/namespace.c
>> +++ b/ipc/namespace.c
>> @@ -48,6 +48,16 @@ struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
>>  	if (!(flags & CLONE_NEWIPC))
>>  		return ns;
>>
>> +	if (!(flags & CLONE_SYSVSEM)) {
>>     
>
> Wait, this should be opposite, right?
>
> [snip]
> Manfred, I'm trying to test this, but can't get an error without this
> patch.  Do you have a testcase?

The patch is bogus, sorry that I didn't notice it immediately.
The problem is ipc/sem.c, function find_undo, lookup_undo:
lookup_undo doesn't check the namespace pointer, thus a simple single 
threaded app can trigger the problem.

Attached is a test app and a kernel patch that shows the problem.
Run the test app immediately after boot (or within a new ipc namespace), 
otherwise the ipc sequence counter will prevent the app from triggering 
the problem: The undo structure that was created before unshare() [i.e. 
with 1 semaphore in it] will be used after unshare() [i.e. semaphore 100 
will be accessed].

With kernel debugging (full slub debugging) enabled, I even got an oops 
when I tried to ipcrm the left over array after running undons, probably 
because the undo structure was freed at exit_sem() within the new 
namespace, but still used in the outer namespace.

--
    Manfred

--------------080107060500050905010303
Content-Type: text/plain;
 name="undons.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="undons.c"

/*
 * Copyright (C) 1999,2001 by Manfred Spraul.
 * 
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL)
 * $Header: /home/manfred/cvs-tree/manfred/ipcsem/undotest.c,v 1.2 2003/06/28 15:19:43 manfred Exp $
 */

#ifdef __LINUX__
	#define _GNU_SOURCE
	#include <sched.h>
	#include <wait.h>
	
	#define CLONE_NEWIPC		0x08000000	/* New ipcs */
#endif
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <assert.h>
#include <signal.h>
#include <time.h>
#include <unistd.h>
#include <pthread.h>

union semun {
	int val;
	struct semid_ds *buf;
	unsigned short int *array;
	struct seminfo* __buf;
};

int getval(char * str, int id)
{
	union semun arg;
	int res;

	res = semctl(id,0,GETVAL,arg);
	if(res==-1) {
		printf("GETVAL failed for %s.\n", str);
		exit(4);
	}
	printf("   %s: GETVAL now %d.\n",str, res);
	return res;
}

void setzero(int id)
{
	union semun arg;
	int res;

	arg.val = 0;
	res = semctl(id,0,SETVAL,arg);
	if(res==-1) {
		printf("SETVAL failed, errno %d.\n", errno);
		exit(4);
	}
	printf("   SETVAL succeeded.\n");
}


/* test1: verify that undo works at all. */
int main(int argc,char** argv)
{
	int res, id;

	printf("  ****************************************\n");

	/* create array */
	res = semget(IPC_PRIVATE, 1, 0700 | IPC_CREAT);
	printf(" got semaphore array %xh.\n",res);
	if(res == -1) {
		printf(" create failed.\n");
		return 1;
	}
	id = res;

	setzero(id);

	res = getval("test1 init", id);
	if (res != 0) {
		printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
		printf("Bad: got unexpected value.\n");
		exit(99);
	}

	/* create sub-process */
	res = fork();
	if (res < 0) {
		printf("Fork failed (errno=%d). Aborting.\n", errno);
		res = semctl(id,1,IPC_RMID,NULL);
		exit(1);
	}
	fflush(stdout);
	if (!res) {
		struct sembuf sop[1];
		int id2;

		sop[0].sem_num=0;
		sop[0].sem_op=1;
		sop[0].sem_flg=SEM_UNDO;

		res = semop(id,sop,1);
		if(res==-1) {
			printf("semop failed.\n");
			exit(1);
		}
		res = getval("before unshare()", id);
		if (res != 1) {
			printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
			printf("Bad: got unexpected value.\n");
			exit(99);
		}
		fflush(stdout);

		errno = 0;
		res = unshare(CLONE_NEWNS|CLONE_NEWIPC);
		printf("  unshare returned %d, errno now %d (expected: 0,0).\n", res, errno);
		fflush(stdout);

		/* create array */
		res = semget(IPC_PRIVATE, 101, 0700 | IPC_CREAT);
		printf("  got semaphore array %xh.\n",res);
		if(res == -1) {
			printf(" create failed.\n");
			return 1;
		}
		id2 = res;
		printf("Now operating on id1=%x, id2=%x. (if both are equal, there will be a memory corruption)\n", id, id2);

		/* child: */
		sop[0].sem_num=100;
		sop[0].sem_op=1;
		sop[0].sem_flg=SEM_UNDO;

		// This operation should trash kernel memory  (if id1==id2)
		res = semop(id2,sop,1);
		if(res==-1) {
			printf("semop failed.\n");
			exit(1);
		}
		exit(1);
	} else {
		int retval;
		retval = wait4(res, NULL, 0, NULL);
		if (retval != res) {
			printf("wait4 returned unexpeted value %d, errno now %d.\n", 
					retval, errno);
		}
		res = getval("after exit", id);
		if (res != 0) {
			printf("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n");
			printf("Bad: got unexpected value.\n");
			return 1;
		}
	}

	return 0;
}

--------------080107060500050905010303
Content-Type: text/plain;
 name="patch-help"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-help"

diff --git a/ipc/sem.c b/ipc/sem.c
index 0b45a4d..5c882f9 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1081,6 +1082,7 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
 	new->id_next = sma->undo;
 	sma->undo = new;
 	sem_unlock(sma);
+printk(KERN_ERR "find_undo(%p, %x) new undop %p (for %d sems).\n", ns, semid, new, nsems);
 	un = new;
 	spin_unlock(&ulp->lock);
 out:
@@ -1153,6 +1155,7 @@ retry_undos:
 		error = PTR_ERR(sma);
 		goto out_free;
 	}
+printk(KERN_ERR "find_undo(%p, %x) == %p, using %ld sems.\n", ns, semid, un, sma->sem_nsems);
 
 	/*
 	 * semid identifiers are not unique - find_undo may have

--------------080107060500050905010303--
