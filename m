Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbXJQXla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbXJQXla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbXJQXlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:41:22 -0400
Received: from homer.mvista.com ([63.81.120.158]:10191 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbXJQXlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:41:21 -0400
Date: Wed, 17 Oct 2007 19:41:20 -0400
From: "George G. Davis" <gdavis@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix hang in posix_locks_deadlock()
Message-ID: <20071017234120.GH3785@mvista.com>
References: <20071017185157.GC3785@mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20071017185157.GC3785@mvista.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 17, 2007 at 02:51:57PM -0400, George G. Davis wrote:
> Not sure if this is the correct fix but it does resolve the hangs we're
> observing in posix_locks_deadlock().  Comments greatly appreciated...

Attached is a test case which exhibits the hang on an F7 host with all
updates applied.  Also occurs on linux-2.6.git latest.

-- 
Regards,
George

--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="posix_locks_deadlock-hang.c"

// gcc -o fcntltest -pthread posix_locks_deadlock-hang.c

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#define __USE_GNU 1
#include <fcntl.h>
#include <pthread.h>
#include <sys/types.h>
#include <unistd.h>

#define NUM_THREADS 100
#define NUM_PROCS 5
#define NUM_FILES 64

pthread_mutex_t locks[NUM_FILES];
pthread_mutex_t gross_lock = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP;

static void *thread_routine(int number)
{
	const char *fname = NULL;
	int f, rc;
	struct flock lock_it;
	pthread_mutex_t *lock = NULL;

	// get the gross lock
	pthread_mutex_lock(&gross_lock);

	lock_it.l_whence = SEEK_SET;	/* from current point */
	lock_it.l_start = 0;		/* -"- */
	lock_it.l_len = 0;		/* until end of file */
	lock_it.l_type = F_WRLCK;	/* set exclusive/write lock */
	lock_it.l_pid = 0;		/* pid not actually interesting */

	fname = calloc(1, 500);

	snprintf(fname, 499, "%i.txt", number);
	lock = &locks[number];

	if (pthread_mutex_trylock(lock) != 0) {
		pthread_mutex_unlock(&gross_lock);
		pthread_mutex_lock(lock);
		pthread_mutex_unlock(&gross_lock);
	}

	int randm = (rand() % 32768) * 10;
	printf("Opening %s...\n", fname);
	f = open(fname, O_TRUNC | O_CREAT | O_WRONLY, 0644);
	if (f < 0) {
		perror(fname);
		exit(1);
	}
	printf("Locking %s...\n", fname);
	// release the gross lock before attempting the fcntl
	pthread_mutex_unlock(&gross_lock);
	rc = fcntl(f, F_SETLKW, &lock_it);
	sleep(5);
	// gain the gross lock again
	pthread_mutex_lock(&gross_lock);
	if (rc < 0) {
		perror(fname);
		usleep(randm);
		pthread_mutex_unlock(lock);
		pthread_mutex_unlock(&gross_lock);
		exit(1);
	}

	usleep(randm);
	// unlocks the file
	close(rc);
	pthread_mutex_unlock(lock);
	pthread_mutex_unlock(&gross_lock);
	return NULL;
}

int main(int argc, char **argv)
{
	int i, rc;
	pthread_t tids[NUM_THREADS];
	memset(tids, 0, sizeof(tids));
	memset(locks, 0, sizeof(locks));

	for (i = 0; i < NUM_PROCS; i++) {
		pid_t mypid = fork();
		if (mypid == 0)
			break;
	}

	for (i = 0; i < NUM_THREADS; i++) {
		rc = pthread_create(&tids[i], NULL, thread_routine,
				    (rand() % NUM_FILES));
		if (rc != 0) {
			tids[i] = 0;
		}
	}

	for (i = 0; i < 500; i++) {
		if (tids[i] != 0) {
			pthread_join(tids[i], NULL);
		}
	}

	return 0;
}

--MW5yreqqjyrRcusr--
