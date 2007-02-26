Return-Path: <linux-kernel-owner+w=401wt.eu-S1030185AbXBZKiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbXBZKiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030193AbXBZKiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:38:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030185AbXBZKiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:38:10 -0500
Date: Mon, 26 Feb 2007 11:31:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Davide Libenzi <davidel@xmailserver.org>,
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
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226103117.GA16101@elte.hu>
References: <20070225182135.GB29821@2ka.mipt.ru> <20070225182230.GA3622@elte.hu> <20070225183743.GD29821@2ka.mipt.ru> <20070225192112.GA15681@elte.hu> <20070225194645.GB1353@2ka.mipt.ru> <20070225195308.GC15681@elte.hu> <Pine.LNX.4.64.0702251232350.6011@alien.or.mcafeemobile.com> <20070226081655.GA25280@elte.hu> <20070226092545.GA4110@2ka.mipt.ru> <20070226095547.GA9485@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226095547.GA9485@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> please also try evserver_epoll_threadlet.c that i've attached below - 
> it uses epoll as the main event mechanism but does threadlets for 
> request handling.

find updated code below - your evserver_epoll.c spuriously missed event 
edges - so i changed it back to level-triggered. While that is not as 
fast as edge-triggered, it does not result in spurious hangs and 
workflow 'hickups' during the test.

Could this be the reason why in your testing kevents outperformed epoll?

Also, i have removed the set-nonblocking calls because they are not 
needed under threadlets.

[ to build this code, copy it into the async-test/ directory and build
  it there - or copy the *.h files from async-test/ directory into your
  build directory. ]

	Ingo

-------{ evserver_epoll_threadlet.c }-------------->
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/poll.h>
#include <sys/sendfile.h>
#include <sys/epoll.h>

#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <time.h>
#include <ctype.h>
#include <netdb.h>

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

#include <linux/types.h>

//#define ulog(f, a...) fprintf(stderr, f, ##a)
#define ulog(f, a...)
#define ulog_err(f, a...) printf(f ": %s [%d].\n", ##a, strerror(errno), errno)


static int kevent_ctl_fd, main_server_s;

static void usage(char *p)
{
	ulog("Usage: %s -a addr -p port -f kevent_path -t timeout -w wait_num\n", p);
}

static int evtest_server_init(char *addr, unsigned short port)
{
	struct hostent *h;
	int s, on;
	struct sockaddr_in sa;

	if (!addr) {
		ulog("%s: Bind address cannot be NULL.\n", __func__);
		return -1;
	}

	h = gethostbyname(addr);
	if (!h) {
		ulog_err("%s: Failed to get address of %s.\n", __func__, addr);
		return -1;
	}

	s = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (s == -1) {
		ulog_err("%s: Failed to create server socket", __func__);
		return -1;
	}
//	fcntl(s, F_SETFL, O_NONBLOCK);

	memcpy(&(sa.sin_addr.s_addr), h->h_addr_list[0], 4);
	sa.sin_port = htons(port);
	sa.sin_family = AF_INET;

	on = 1;
	setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &on, 4);

	if (bind(s, (struct sockaddr *)&sa, sizeof(struct sockaddr_in)) == -1) {
		ulog_err("%s: Failed to bind to %s", __func__, addr);
		close(s);
		return -1;
	}

	if (listen(s, 30000) == -1) {
		ulog_err("%s: Failed to listen on %s", __func__, addr);
		close(s);
		return -1;
	}

	return s;
}

#define EPOLL_EVENT_MASK (EPOLLIN | EPOLLERR | EPOLLPRI)

static int evtest_kevent_remove(int fd)
{
	int err;
	struct epoll_event event;

	event.events = EPOLL_EVENT_MASK;
	event.data.fd = fd;

	err = epoll_ctl(kevent_ctl_fd, EPOLL_CTL_DEL, fd, &event);
	if (err < 0) {
		ulog_err("Failed to perform control REMOVE operation");
		return err;
	}

	return err;
}

static int evtest_kevent_init(int fd)
{
	int err;
	struct timeval tm;
	struct epoll_event event;

	event.events = EPOLL_EVENT_MASK;
	event.data.fd = fd;

	err = epoll_ctl(kevent_ctl_fd, EPOLL_CTL_ADD, fd, &event);
	gettimeofday(&tm, NULL);
	ulog("%08lu:%06lu: fd=%3d, err=%1d.\n", tm.tv_sec, tm.tv_usec, fd, err);
	if (err < 0) {
		ulog_err("Failed to perform control ADD operation: fd=%d, events=%08x", fd, event.events);
		return err;
	}

	return err;
}

#define MAX_FILES 1000000

/*
 * Debug check:
 */
static struct request *fd_to_req[MAX_FILES];

static long handle_request(void *__req)
{
	struct request *req = __req;
	int s = req->sock, err, fd;
	off_t offset;
	int count;
	char path[] = "/tmp/index.html";
	char buf[4096];
	struct timeval tm;

	if (!fd_to_req[s])
		ulog_err("Bad: no request to fd?");

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

	close(s);
	fd_to_req[s] = NULL;

	return complete_threadlet_fn(req, &async_head);

err_out_remove:
	evtest_kevent_remove(s);
	close(s);
	fd_to_req[s] = NULL;

	return complete_threadlet_fn(req, &async_head);
}

static int evtest_callback_client(int sock)
{
	struct request *req;
	long done;

	if (fd_to_req[sock]) {
		ulog_err("Bad: request overlap?");
		return 0;
	}

	req = alloc_req();
	if (!req) {
		ulog_err("Bad: no req\n");
		evtest_kevent_remove(sock);
		return -ENOMEM;
	}

	req->sock = sock;
	fd_to_req[sock] = req;
	done = threadlet_exec(handle_request, req,
			req->threadlet_stack, &async_head);

	handle_submitted_request(req, done);

	return 0;
}

static int evtest_callback_main(int s)
{
	int cs, err;
	struct sockaddr_in csa;
	socklen_t addrlen = sizeof(struct sockaddr_in);
	struct timeval tm;

	memset(&csa, 0, sizeof(csa));

	if ((cs = accept(s, (struct sockaddr *)&csa, &addrlen)) == -1) {
		ulog_err("Failed to accept client");
		return -1;
	}
//	fcntl(cs, F_SETFL, O_NONBLOCK);

	gettimeofday(&tm, NULL);

	ulog("%08lu:%06lu: Accepted connect from %s:%d.\n",
		tm.tv_sec, tm.tv_usec,
		inet_ntoa(csa.sin_addr), ntohs(csa.sin_port));

	err = evtest_kevent_init(cs);
	if (err < 0) {
		close(cs);
		return -1;
	}

	return 0;
}

static int evtest_kevent_wait(unsigned int timeout, unsigned int wait_num)
{
	int num, err;
	struct timeval tm;
	struct epoll_event event[256];
	int i;

	err = epoll_wait(kevent_ctl_fd, event, 256, -1);
	if (err < 0) {
		ulog_err("Failed to perform control operation");
		return num;
	}

	gettimeofday(&tm, NULL);

	num = err;
	ulog("%08lu.%06lu: Wait: num=%d.\n", tm.tv_sec, tm.tv_usec, num);
	for (i=0; i<num; ++i) {
		if (event[i].data.fd == main_server_s)
			err = evtest_callback_main(event[i].data.fd);
		else
			err = evtest_callback_client(event[i].data.fd);
	}

	return err;
}

int main(int argc, char *argv[])
{
	int ch, err;
	char *addr;
	unsigned short port;
	unsigned int timeout, wait_num;

	addr = "0.0.0.0";
	port = 8080;
	timeout = 1000;
	wait_num = 1;

	async_head_init();

	while ((ch = getopt(argc, argv, "f:n:t:a:p:h")) > 0) {
		switch (ch) {
			case 't':
				timeout = atoi(optarg);
				break;
			case 'n':
				wait_num = atoi(optarg);
				break;
			case 'a':
				addr = optarg;
				break;
			case 'p':
				port = atoi(optarg);
				break;
			case 'f':
				break;
			default:
				usage(argv[0]);
				return -1;
		}
	}

	kevent_ctl_fd = epoll_create(10);
	if (kevent_ctl_fd == -1) {
		ulog_err("Failed to epoll descriptor");
		return -1;
	}

	main_server_s = evtest_server_init(addr, port);
	if (main_server_s < 0)
		return main_server_s;

	err = evtest_kevent_init(main_server_s);
	if (err < 0)
		goto err_out_exit;

	while (1) {
		err = evtest_kevent_wait(timeout, wait_num);
	}

err_out_exit:
	close(kevent_ctl_fd);

	async_head_exit();

	return 0;
}
