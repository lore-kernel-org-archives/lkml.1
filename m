Return-Path: <linux-kernel-owner+w=401wt.eu-S1030740AbXAZE6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030740AbXAZE6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030743AbXAZE6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:58:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:8277 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030740AbXAZE6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pUEkgk/nH7e6PIlIlEj2ey3VJR0K35NrbF85BRJBcoLst+3lTBvjpvIBGF+0oDFCtVPsgLYWy6diD2TR3UfrtpjRaUVXL80SS3mtNSN2pn84U5kZ0IzSwiKl7FwYC5swxZYI6e+DPEtFjWs3dpttS7Mc07e64DTjDzbksynfvLw=
Message-ID: <4df04b840701252058t1cffb8cdw15a2eee3cdc5913@mail.gmail.com>
Date: Fri, 26 Jan 2007 12:58:22 +0800
From: "yunfeng zhang" <zyf.zeroos@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20-rc5 1/1] MM: enhance Linux swap subsystem
Cc: "Hugh Dickins" <hugh@veritas.com>, "Al Boldi" <a1426z@gawab.com>
In-Reply-To: <Pine.LNX.4.64.0701242015090.1770@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4df04b840701212309l2a283357jbdaa88794e5208a7@mail.gmail.com>
	 <200701222300.41960.a1426z@gawab.com>
	 <4df04b840701222021w5e1aaab2if2ba7fc38d06d64b@mail.gmail.com>
	 <4df04b840701222108o6992933bied5fff8a525413@mail.gmail.com>
	 <Pine.LNX.4.64.0701242015090.1770@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current test based on the fact below in my previous mail

> Current Linux page allocation fairly provides pages for every process, since
> swap daemon only is started when memory is low, so when it starts to scan
> active_list, the private pages of processes are messed up with each other,
> vmscan.c:shrink_list() is the only approach to attach disk swap page to page on
> active_list, as the result, all private pages lost their affinity on swap
> partition. I will give a testlater...
>

Three testcases are imitated here
1) matrix: Some softwares do a lots of matrix arithmetic in their PrivateVMA,
   in fact, the type is much better to pps than Linux.
2) c: C malloc uses an arithmetic just like slab, so when an application resume
   from swap partition, let's supposed it touches three variables whose sizes
   are different, in the result, it should touch three pages and the three
   pages are closed with each other but aren't continual, I also imitate a case
   that if the application starts full-speed running later (touch more pages).
3) destruction: Typically, if an application resumes due to user clicks the
   close button, it totally visits all its private data to execute object
   destruction.

Test stepping
1) run ./entry and say y to it, maybe need root right.
2) wait a moment until echo 'primarywait'.
3) swapoff -a && swapon -a.
4) ./hog until count = 10.
5) 'cat primary entry secondary > /dev/null'
6) 'cat /proc/vmstat' several times and record 'pswpin' field when it's stable.
7) type `1', `2' or `3' to 3 testcases, answer `2' to start fullspeed testcase.
8) record new 'pswpin' field.
9) which is better? see the 'pswpin' increment.
pswpin is increased in mm/page_io.c:swap_readpage.

Test stepping purposes
1) Step 1, 'entry' wakes up 'primary' and 'secondary' simultaneously, every time
   'primary' allocates a page, 'secondary' inserts some pages into active_list
   closed to it.
1) Step 3, we should re-allocate swap pages.
2) Step 4, flush 'entry primary secondary' to swap partition.
3) Step 5, make file content 'entry primary secondary' present in memory.

Testcases are done in vmware virtual machine 5.5, 32M memory. If you argue my
circumstance, do your testcases following the steps advised
1) Run multiple memory-consumer together, make them pause at a point.
   (So mess up all private pages in pg_active list).
2) Flush them to swap partition.
3) Wake up one of them, let it run full-speed for a while, record pswpin of
   /proc/vmstat.
4) Invalidate all readaheaded pages.
5) Wake up another, repeat the test.
6) It's also good if you can record hard LED twinking:)
Maybe your test resumes all memory-consumers together, so Linux readaheads some
pages close to page-fault page but are belong to other processes, I think.

By the way, what's linux-mm mail, it ins't in Documentation/SubmitPatches.

In fact, you will find Linux column makes hard LED twinking per 5 seconds.
-----------------------------
			Linux		pps
matrix		5241		1597
			5322		1620
			(81)		(23)

c			8028		1937
			8095		1954
fullspeed	8313		1964
			(67)		(17)
			(218)		(10)

destruction	9461		4445
			9825		4484
			(364)		(39)

Comment secondary.c:memset clause, so 'secondary' won't interrupt
page-allocation in 'primary'.
-----------------------------
			Linux		pps
matrix		207			38
			256			59
			(49)		(21)

c			1273		347
			1341		383
fullspeed	1362		386
			(68)		(36)
			(21)		(3)

destruction	2435		1178
			2513		1246
			(78)		(68)

entry.c
-----------------------------
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

pid_t pids[4];
int sem_set;
siginfo_t si;

int main(int argc, char **argv)
{
	int i, data;
	unsigned short init_data[4] = { 1, 1, 1, 1 };
	if ((sem_set = semget(123321, 4, IPC_CREAT)) == -1)
		goto failed;
	if (semctl(sem_set, 0, SETALL, &init_data) == -1)
		goto failed;
	pid_t pid = vfork();
	if (pid == -1) {
		goto failed;
	} else if (pid == 0) {
		if (execlp("./primary", NULL) == -1)
			goto failed;
	} else {
		pids[0] = pid;
	}
	pid = vfork();
	if (pid == -1) {
		goto failed;
	} else if (pid == 0) {
		if (execlp("./secondary", NULL) == -1)
			goto failed;
	} else {
		pids[1] = pid;
	}
	printf("entry:continue?\n");
	getchar();
	init_data[0] = init_data[1] = 0;
	if (semctl(sem_set, 0, SETALL, &init_data) == -1)
		goto failed;
	sleep(30000);
	exit(EXIT_SUCCESS);
failed:
	perror("entry errno:");
	exit(EXIT_FAILURE);
}

primary.c
-----------------------------
#include <sys/mman.h>
#include <signal.h>
#include <sys/sem.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int cont = 0;
void* addr;
int VMA_SIZE = 32;

void init_mmap()
{
	int i, j, a, b;
	addr = mmap(NULL, 4096 * VMA_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE
		| MAP_ANON, 0, 0);
	printf("primary:addr:%x\n", (unsigned long) addr);
	if (addr == MAP_FAILED)
		goto failed;
	for (i = 0; i < VMA_SIZE; i++) {
		memset((unsigned char*) addr + i * 4096, i, 1);
		sleep(2);
	}
	return;
failed:
	perror("primary errno:");
	exit(EXIT_FAILURE);
}

#define TOUCH_IT(value) \
	if (*((unsigned char*) addr + value * 4096) != value) \
		printf("BUG, memory corrupt!%d\n", value);
#define WEAK_RANDOM(from, to) \
	range = to - from; \
	range_temp = rand() % range; \
	TOUCH_IT(range_temp)
#define STRONG_RANDOM \
	WEAK_RANDOM(0, VMA_SIZE)

void fullspeed_case()
{
	int i, a;
	for (i = 0; i < VMA_SIZE / 2; i++) {
		a = rand() % VMA_SIZE;
		TOUCH_IT(i)
		sleep(5);
	}
}

void c_case()
{
	int from, to, i, a, range, range_temp;
	for (i = 0; i < 3; i++) {
		from = rand() % VMA_SIZE;
		if (from + 8 >= VMA_SIZE)
			from = VMA_SIZE - 8;
		to = from + 8;
		WEAK_RANDOM(from, to)
		sleep(5);
	}
	STRONG_RANDOM
	sleep(5);
	STRONG_RANDOM
}

void destruction_case()
{
	int i, a;
	for (i = 0; i < VMA_SIZE; i++) {
		a = rand() % VMA_SIZE;
		TOUCH_IT(i)
		sleep(5);
	}
}

void matrix_case()
{
	int base, index, i, a, range, range_temp, temp;
	for (i = 0; i < 3; i++) {
		base = rand() % VMA_SIZE;
		if (base + 8 >= VMA_SIZE)
			base = VMA_SIZE - 8;
		index = rand() % 8;
		index = (index == 7 ? index-- : index);
		temp = base + index;
		TOUCH_IT(temp)
		sleep(5);
		temp++;
		TOUCH_IT(temp)
		sleep(5);
	}
	STRONG_RANDOM
	sleep(5);
	STRONG_RANDOM
}

int main(int argc, char **argv)
{
	int a;

	int sem_set;
	struct sembuf sem_buf;
	if ((sem_set = semget(123321, 4, 0)) == -1)
		goto failed;
	sem_buf.sem_num = 0;
	sem_buf.sem_op = 0;
	sem_buf.sem_flg = 0;
	if (semop(sem_set, &sem_buf, 1) == -1)
		goto failed;

	init_mmap();
	printf("primarywait\n");
	scanf("%d", &a);
	printf("primaryresume\n");
	switch (a) {
		case 1:
			printf("matrix_case\n");
			matrix_case();
			break;
		case 2:
			printf("c_case\n");
			c_case();
			break;
		case 3:
			printf("destruction_case\n");
			destruction_case();
			break;
	}
	if (a == 2) {
		printf("primaryfullspeed\n");
		scanf("%d", &a);
		fullspeed_case();
	}
	printf("primarydone\n");
	sleep(30000);
	exit(EXIT_SUCCESS);
failed:
	perror("primary errno:");
	exit(EXIT_FAILURE);
}

secondary.c
-----------------------------
#include <sys/mman.h>
#include <sys/sem.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
	char c; int i, j, sem_set;
	int a, b;
	void* addr;
	struct sembuf sem_buf;
	if ((sem_set = semget(123321, 4, 0)) == -1)
		goto failed;
	sem_buf.sem_num = 1;
	sem_buf.sem_op = 0;
	sem_buf.sem_flg = 0;
	if (semop(sem_set, &sem_buf, 1) == -1)
		goto failed;
	addr = mmap(NULL, 4096 * 32 * 66, PROT_READ | PROT_WRITE, MAP_PRIVATE
		| MAP_ANON, 0, 0);
	printf("secondaryaddr%x\n", addr);
	if (addr == MAP_FAILED)
		goto failed;
	for (i = 0; i < 32 * 66; i++) {
		memset((unsigned char*) addr + i * 4096, i, 1);
		if (i % 32 == 31)
			sleep(1);
	}
	sleep(30000);
	exit(EXIT_SUCCESS);
failed:
	perror("secondary errno:");
	exit(EXIT_FAILURE);
}
