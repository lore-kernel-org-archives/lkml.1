Return-Path: <linux-kernel-owner+w=401wt.eu-S965143AbXBYVkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965143AbXBYVkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 16:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965146AbXBYVkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 16:40:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40912 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965143AbXBYVkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 16:40:31 -0500
Date: Sun, 25 Feb 2007 22:34:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: threadlets as 'naive pool of threads', epoll, some measurements
Message-ID: <20070225213420.GA10195@elte.hu>
References: <20070225172337.GB4998@elte.hu> <20070225174438.GA13647@2ka.mipt.ru> <20070225175437.GA9480@elte.hu> <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > i dont understand - this confuses the client because there's no 
> > Content-Length field. Did you insert a Content-Length field 
> > manually? What i'm trying to figure out, are you relying on a 
> > keepalive client or not? I.e. is there a -k option to 'ab' as well, 
> > besides the ones you mentioned?
> 
> You don't need a Content-Length if you're closing the connection ;)

yeah. But there's apparently a bug in the code because it doesnt close 
's'.

> In any case, Evgeniy test "servers" so not handle properly the 
> delivery of the content, where it is assumed that an open+sendfile is 
> a continuos non-blocking operation. [...]

i have tried the one Evgeniy provided in the URL:

  http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c

and 'ab -k -c8000 -n80000' almost always aborts with:

  apr_socket_recv: Connection reset by peer (104)

in the few cases it finishes, i got the following epoll result, over 
gigabit ethernet, on an UP Athlon64 box:

   eserver_epoll:     7800 reqs/sec

the same with the most naive implementation of the same, using 
threadlets:

   eserver_threadlet: 5800 reqs/sec

Extrapolating from Evgeniy's numbers i'd expect kevents to do around 
14000 reqs/sec.

i've attached eserver_threadlet.c [compile it in the async-test/ 
directory of the syslet userspace testcode, and change MAX_PENDING to 
9000 in sys.h] - it uses the request handling function from 
eserver_epoll - no tuning or anything.

while keeping in mind that these are raw, preliminary numbers with 
little analysis of them, i'm surprised that 8000 async threads perform 
so well. Obviously this testcase and implementation just degrades 
threadlets down to a pool of 8000 user-space threads, so there's no win 
at all from context caching, no intelligent queueing back to the head 
context, etc.

	Ingo

---------{ eserver_threadlet.c }--------------->
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>
#include <linux/futex.h>
#include <sys/time.h>
#include <sys/types.h>
#include <linux/unistd.h>
#include <netinet/tcp.h>
#include <stdio.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sched.h>
#include <sys/time.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

#include <sys/poll.h>
#include <sys/sendfile.h>
#include <sys/epoll.h>

#define DEBUG           0

#include "syslet.h"
#include "sys.h"
#include "threadlet.h"

struct request {
	struct request *next_free;
	/*
	 * The threadlet stack is part of the request structure
	 * and is thus reused as threadlets complete:
	 */
	unsigned long threadlet_stack;

	/*
	 * These are all the request-specific parameters:
	 */
	long sock;
};

//#define ulog(f, a...) fprintf(stderr, f, ##a)
#define ulog(f, a...)
#define ulog_err(f, a...) printf(f ": %s [%d].\n", ##a, strerror(errno), errno)

static long handle_request(void *__req)
{
	struct request *req = __req;
	int s = req->sock, err, fd;
	off_t offset;
	int count;
	char path[] = "/tmp/index.html";
	char buf[4096];
	struct timeval tm;

read_again:	
	count = 40960;
	offset = 0;

	err = recv(s, buf, sizeof(buf), 0);
	if (err < 0) {
		ulog_err("Failed to read data from s=%d", s);
		goto err_out_remove;
	}
	if (err == 0) {
		gettimeofday(&tm, NULL);
		ulog("%08lu:%06lu: Client exited: fd=%d.\n", tm.tv_sec, tm.tv_usec, s);
		goto err_out_remove;
	}

	fd = open(path, O_RDONLY);
	if (fd == -1) {
		ulog_err("Failed to open '%s'", path);
		err = -1;
		goto err_out_remove;
	}
#if 0
	do {
		err = read(fd, buf, sizeof(buf));
		if (err <= 0)
			break;
		err = send(s, buf, err, 0);
		if (err <= 0)
			break;
	} while (1);
#endif
	err = sendfile(s, fd, &offset, count);
	{
		int on = 0;
		setsockopt(s, SOL_TCP, TCP_CORK, &on, sizeof(on));
	}

	close(fd);
	if (err < 0) {
		ulog_err("Failed send %d bytes: fd=%d.\n", count, s);
		goto err_out_remove;
	}

	gettimeofday(&tm, NULL);
	ulog("%08lu:%06lu: %d bytes has been sent to client fd=%d.\n", tm.tv_sec, tm.tv_usec, err, s);

	goto read_again;

err_out_remove:
	printf("blah\n");
	close(s);
	return complete_threadlet_fn(req, &async_head);
}

/*
 * Freelist to recycle requests:
 */
static struct request *freelist;

/*
 * Allocate a request and set up its syslet atoms:
 */
static struct request *alloc_req(void)
{
	struct request *req;

	/*
	 * Occasionally we have to refill the new-thread stack
	 * entry:
	 */
	if (!async_head.new_thread_stack) {
		async_head.new_thread_stack = thread_stack_alloc();
		pr("allocated new thread stack: %08lx\n",
			async_head.new_thread_stack);
	}

	if (freelist) {
		req = freelist;
		pr("reusing req %p, threadlet stack %08lx\n",
			req, req->threadlet_stack);
		freelist = freelist->next_free;
		req->next_free = NULL;
		return req;
	}

	req = calloc(1, sizeof(struct request));
	pr("allocated req %p\n", req);
	req->threadlet_stack = thread_stack_alloc();
	pr("allocated thread stack %08lx\n", req->threadlet_stack);

	return req;
}

/*
 * Check whether there are any completions queued for user-space
 * to finish up:
 */
static unsigned long complete(void)
{
	unsigned long completed = 0;
	struct request *req;

	for (;;) {
		req = (void *)completion_ring[async_head.user_ring_idx];
		if (!req)
			return completed;
		completed++;
		pr("completed req %p (threadlet stack %08lx)\n",
			req, req->threadlet_stack);

		req->next_free = freelist;
		freelist = req;

		/*
		 * Clear the completion pointer. To make sure the
		 * kernel never stomps upon still unhandled completions
		 * in the ring the kernel only writes to a NULL entry,
		 * so user-space has to clear it explicitly:
		 */
		completion_ring[async_head.user_ring_idx] = NULL;
		async_head.user_ring_idx++;
		if (async_head.user_ring_idx == MAX_PENDING)
			async_head.user_ring_idx = 0;
	}
}

static unsigned int pending_requests;

/*
 * Handle a request that has just been submitted (either it has
 * already been executed, or we have to account it as pending):
 */
static void handle_submitted_request(struct request *req, long done)
{
	unsigned int nr;

	if (done) {
		/*
		 * This is the cached case - free the request:
		 */
		pr("cache completed req %p (threadlet stack %08lx)\n",
			req, req->threadlet_stack);
		req->next_free = freelist;
		freelist = req;
		return;
	}
	/*
	 * 'cachemiss' case - the syslet is not finished
	 * yet. We will be notified about its completion
	 * via the completion ring:
	 */
	assert(pending_requests < MAX_PENDING-1);

	pending_requests++;
	pr("req %p is pending. %d reqs pending.\n", req, pending_requests);
	/*
	 * Attempt to complete requests - this is a fast
	 * check if there's no completions:
	 */
	nr = complete();
	pending_requests -= nr;

	/*
	 * If the ring is full then wait a bit:
	 */
	while (pending_requests == MAX_PENDING-1) {
		pr("sys_async_wait()");
		/*
		 * Wait for 4 events - to batch things a bit:
		 */
		sys_async_wait(4, async_head.user_ring_idx, &async_head);
		nr = complete();
		pending_requests -= nr;
		pr("after wait: completed %d requests - still pending: %d\n",
			nr, pending_requests);
	}
}

static void webserver(int l_sock)
{
        struct sockaddr addr;
	struct request *req;
        socklen_t addrlen;
	long done;
	int sock;

	async_head_init();

	/*
	 * We dont use syslets for the first request (or for oversized
	 * and/or erroneous requests):
	 */
	for (;;) {
		req = alloc_req();
		if (!req)
			break;

		sock = accept(l_sock, &addr, &addrlen);

		if (sock < 0)
			break;

		req->sock = sock;
		done = threadlet_exec(handle_request, req,
				req->threadlet_stack, &async_head);

		handle_submitted_request(req, done);
	}
}

static int tcp_listen_socket(int *l_socket)
{
	int ret;
	int one = 1;
	struct sockaddr_in ad;

	/*
	 * Setup for server socket
	 */
	memset(&ad, 0, sizeof(ad));
	ad.sin_family = AF_INET;
	ad.sin_addr.s_addr = htonl(INADDR_ANY);
	ad.sin_port = htons(2222);

	*l_socket = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (*l_socket < 0) {
		perror("socket (server)");
		return *l_socket;
	}

	ret = setsockopt(*l_socket, SOL_SOCKET, SO_REUSEADDR, (char *)&one,
			sizeof(int));
	if (ret < 0) {
		perror("setsockopt");
		return ret;
	}

	ret = bind(*l_socket, (struct sockaddr *)&ad, sizeof(ad));
	if (ret < 0) {
		perror("bind");
		return ret;
	}

	ret = listen(*l_socket, 1000);
	if (ret < 0) {
		perror("listen");
		return ret;
	}

	return 0;
}

int main(int argc, char *argv[])
{
	int ret;
	int l_sock;
	struct sched_param p = { sched_priority: 0 };

	sched_setscheduler(getpid(), 3 /* SCHED_BATCH */, &p);

	ret = tcp_listen_socket(&l_sock);
	if (ret)
		exit(ret);
	printf("listening on port 2222\n");
	printf("using threadlets\n");

	webserver(l_sock);
	async_head_exit();

	exit(0);
}
