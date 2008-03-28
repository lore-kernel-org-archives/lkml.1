Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbYC1Jt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbYC1Jt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYC1JtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:49:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:16192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYC1JtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:49:20 -0400
Message-ID: <47ECBF1A.2080300@colorfullife.com>
Date: Fri, 28 Mar 2008 10:49:14 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Mike Galbraith <efault@gmx.de>, paulmck@linux.vnet.ibm.com,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scalability requirements for sysv ipc
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>	 <47E3B924.3000304@colorfullife.com>	 <20080321141339.GB9618@linux.vnet.ibm.com>	 <47E3DD8C.4000904@colorfullife.com> <1206164608.3659.11.camel@marge.simson.net> <47EC1FC0.7040405@tmr.com>
In-Reply-To: <47EC1FC0.7040405@tmr.com>
Content-Type: multipart/mixed;
 boundary="------------030102090009040709030602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030102090009040709030602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bill Davidsen wrote:
>
> I never tried binding the process to a CPU, in general the affinity 
> code puts one process per CPU under light load, and limits the context 
> switch overhead. It looks as if you are testing only the single CPU 
> (or core) case.
>
Attached is a patch that I wrote that adds cpu binding. Feel free to add 
it to your sources. It's not that usefull, recent linux distros include 
a "taskset" command that can bind a task to a given cpu. I needed it for 
an older distro.

With regards to the multi-core case: I've always ignored them, I 
couldn't find a good/realistic test case.
Thundering herds (i.e.: one task wakes up lots of waiting tasks) is at 
least for sysv msg and sysv sem lockless: the woken up tasks do not take 
any locks, they return immediately to user space.
Additionally, I don't know if the test case is realistic: at least 
postgres uses one semaphore for each process/thread, thus waking up 
multiple tasks never happens.

Another case would be to bind both tasks to different cpus. I'm not sure 
if this happens in real life. Anyone around who knows how other 
databases implement locking? Is sysv sem still used?

--
    Manfred


--------------030102090009040709030602
Content-Type: text/plain;
 name="patch-cpubind"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-cpubind"

diff -ur ctxbench-1.9.orig/ctxbench.c ctxbench-1.9/ctxbench.c
--- ctxbench-1.9.orig/ctxbench.c	2002-12-09 22:41:59.000000000 +0100
+++ ctxbench-1.9/ctxbench.c	2008-03-28 10:30:55.000000000 +0100
@@ -1,19 +1,28 @@
+#include <sched.h>
 #include <time.h>
 #include <errno.h>
 #include <stdio.h>
 #include <signal.h>
 #include <unistd.h>
-#include <sched.h>
 #include <sys/types.h>
 #include <sys/time.h>
 #include <sys/shm.h>
 #include <sys/sem.h>
 #include <sys/msg.h>
 #include <sys/stat.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
 
 /* this should be in unistd.h!! */
 /* #include <getopt.h> */
 
+/**************** Prototypes */
+
+void shmchild(int shm, int semid);
+void shmparent(int shm, int semid, pid_t child);
+void do_cpubind(int cpu);
+
 /**************** General internal procs and flags here */
 /*		help/usage */
 static void usage(void);
@@ -25,7 +34,6 @@
 int Niter = 0;
 /*		Use signals rather than semiphores */
 static void sig_NOP();
-static void wait_sig();
 int OkayToRun = 0;
 int ParentPID, ChildPID;
 /*		pipe vectors for -p option */
@@ -79,19 +87,20 @@
 
 int msgqid;
 int do_yield = 0;
-
-main(int argc, char *argv[])
+
+int main(int argc, char *argv[])
 {
 	int shm;
 	struct shmid_ds buf;
 	int semid = -1;
-	int child, stat;
+	int cpubind = -1;
+	int child;
 	int RunTime = 10;
 	union semun pvt_semun;
 
 	pvt_semun.val = 0;
 
-	while ((shm = getopt(argc, argv, "sSLYmpn:t:")) != EOF) {
+	while ((shm = getopt(argc, argv, "sSLYmpn:t:c:")) != EOF) {
 		switch (shm) {
 		/* these are IPC types */
 		case 's':	/* use semiphore */
@@ -124,11 +133,14 @@
 		case 't':	/* give time to run */
 			RunTime = atoi(optarg);
 			break;
+		case 'c':	/* bind to a specific cpu */
+			cpubind = atoi(optarg);
+			break;
 		default:	/* typo */
 			usage();
 		}
 	}
-
+
 	signal(SIGALRM, timeout);
 	if (RunTime) alarm(RunTime);
 
@@ -164,7 +176,7 @@
 	}
 
 	/* identify version and method */
-	printf("\n\nContext switching benchmark v1.17\n");
+	printf("\n\nContext switching benchmark v1.17-cpubind\n");
 	printf("  Using %s for IPC control\n", IPCname[IPCtype]);
 
 	printf("   Max iterations: %8d (zero = no limit)\n", Iterations);
@@ -174,13 +186,14 @@
 
 	ParentPID = getpid();
 	if ((child = fork()) == 0) {
+		do_cpubind(cpubind);
 		ChildPID = getpid();
 		shmchild(shm, semid);
 	} else {
+		do_cpubind(cpubind);
 		ChildPID = child;
 		shmparent(shm, semid, child);
 	}
-
 	wait(NULL);
 	if (shmctl(shm, IPC_RMID, &buf) != 0) {
 		perror("Error removing shared memory");
@@ -215,14 +228,13 @@
 		break;
 	}
 
-	exit(0);
+	return 0;
 }
-
 
 /*******************************/
 /*  child using IPC method */
 
-int shmchild(int shm, int semid)
+void shmchild(int shm, int semid)
 {
 	volatile char *mem;
 	int num = 0;
@@ -313,7 +325,7 @@
 /********************************/
 /*  parent using shared memory  */
 
-int shmparent(int shm, int semid, pid_t child)
+void shmparent(int shm, int semid, pid_t child)
 {
 	volatile char *mem;
 	int num = 0;
@@ -328,7 +340,7 @@
 
 
 	if (!(mem = shmat(shm, 0, 0))) {
-		perror("shmchild: Error attaching shared memory");
+		perror("shmparent: Error attaching shared memory");
 		exit(2);
 	}
 
@@ -439,7 +451,7 @@
 		exit(3);
 	}
 }
-
+
 /*****************************************************************
  | usage - give the user a clue
  ****************************************************************/
@@ -458,6 +470,7 @@
 		" -p   use pipes for IPC\n"
 		" -L   spinLock in shared memory\n"
 		" -Y   spinlock with sched_yield (for UP)\n"
+		" -cN  bind to cpu N\n"
 		"\nRun limit options:\n"
 		" -nN  limit loops to N (default via timeout)\n"
 		" -tN  run for N sec, default 10\n\n"
@@ -490,3 +503,22 @@
 	signal(SIGUSR1, sig_NOP);
 	return;
 }
+
+/*****************************************************************
+ | cpu_bind - bind all tasks to a given cpu
+ ****************************************************************/
+
+void do_cpubind(int cpubind)
+{
+	if (cpubind >= 0) {
+		cpu_set_t d;
+		int ret;
+
+		CPU_ZERO(&d);
+		CPU_SET(cpubind, &d);
+		ret = sched_setaffinity(0, sizeof(d), &d);
+		printf("%d: sched_setaffinity %d: %lxh\n",getpid(), ret, *((int*)&d));
+		ret = sched_getaffinity(0, sizeof(d), &d);
+		printf("%d: sched_getaffinity %d: %lxh\n",getpid(), ret, *((int*)&d));
+	}
+}

--------------030102090009040709030602--
