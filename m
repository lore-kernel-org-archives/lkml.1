Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXBJVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXBJVAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXBJVAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:00:06 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3188 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXBJVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:00:03 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Feb 2007 12:59:54 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0702101054250.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702101219200.11928@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702091458180.2786@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702091519330.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702101034220.11630@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702101054250.8424@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007, Linus Torvalds wrote:

> On Sat, 10 Feb 2007, Davide Libenzi wrote:
> > 
> > For the queue approach, I meant the async_submit() to simply add the 
> > request (cookie, syscall number and params) inside queue, and not trying 
> > to execute the syscall. Once you're inside schedule, "stuff" has already 
> > partially happened, and you cannot have the same request re-initiated by a 
> > different thread.
> 
> But that makes it impossible to do things synchronously, which I think is 
> a *major* mistake.

Yes! That's what I said when I described the method. No synco fast-paths. 
At that point you could implement the full-queued method in userspace.



> The whole (and really _only_) point of my patch was really the whole 
> "synchronous call" part. I'm personally of the opinion that if you cannot 
> handle the cached case as fast as just doing the system call directly, 
> then the whole thing is almost pointless.
> 
> Things that take a long time we already have good methods for. "epoll" and 
> "kevent" are always going to be the best way to handle the "we have ten 
> thousand events outstanding". There simply isn't any question about it. 
> You can *never* handle ten thousand long-running events efficiently with 
> threads - even if you ignore all the CPU overhead, you're going to have a 
> much bigger memory (and thus *cache*) footprint.

Think about the old-fashioned web server, using epoll to handle thousands 
of connections. You'll be hosting an epoll_wait() over an async 
thread/fibril. Now a burst of 500 connections becomes suddendly "hot", and 
you start looping through those 500 hot connections trying to handle them. 
You'll need to stat/open/read (let's assume a trivial, non-cached HTTP 
server) from the file pointed by the URL's doc, and those better be 
handled in async fashion otherwise you'll starve the others and pay huge 
time in performance. You can multiplex using a state machine or coroutines 
for example. Using coroutines your epoll dispatching loop end up doing 
something like:

	struct conn {
		coroutine_t co;
		int res;
		int skfd;
		...
	};

	void events_dispatch(struct epoll_event *events, int n) {

		for (i = 0; i < n; i++) {
			struct conn *c = (struct conn *) events[i].data;
			co_call(c->co);
		}
	}

Note that co_call() will make the coroutine to re-emerge from the last 
co_resume() they issued.
Your code doesn't not need to be coroutine/async aware, once you wrap the 
possibly-blocking calls with like:

	int my_stat(struct conn *c, const char *path, struct stat *buf) {
		/* "c" is the cookie */
		if ((c->res = async_submit(c, __NR_stat, path, buf)) == EASYNC)
			/* co_resume() will bounce back to the scheduler loop */
			co_resume();
		return c->res;
	}

Now, the *main* loop will be the async_wait() driven one:

	struct async_result {
		void *cookie;
		long result;
	};

	n = async_wait(ares, nares);
	for (i = 0; i < n; i++) {
		if (ares[i].cookie == epoll_special_cookie)
			events_dispatch(...);
		else {
			struct conn *c = (struct conn *) ares[i].cookie;
			c->res = ares[i].result;
			co_call(c->co);
		}
	}

Many of the async submission will complete in a synco way, but many of 
them will require reschedule and service-thread attention. Of these 500 
burst, you can expect 100 or more to require async service. Right away, 
not sometime later. According to Oracle, 1000 or more requests, 90% of 
which can be expected to block, can be fired at a time.
It is true that we need to have a fast synco path, but it is also true 
that we must not suck in the non-synco path, because the submitting thread 
has something else to do then simply issue one async request (it like 
have *many* of them to push).
There we go, I broke my "No more than 20 lines" rule again :)




- Davide


