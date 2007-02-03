Return-Path: <linux-kernel-owner+w=401wt.eu-S1946181AbXBCACP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946181AbXBCACP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 19:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946179AbXBCACP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 19:02:15 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2827 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946181AbXBCACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 19:02:14 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Feb 2007 16:02:11 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702021548000.5219@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007, Davide Libenzi wrote:

> On Fri, 2 Feb 2007, Ingo Molnar wrote:
> 
> > in fact an app could also /trigger/ the execution of a syscall in a 
> > different context - to create parallelism artificially - without any 
> > blocking event. So we could do:
> > 
> >   cookie1 = sys_async(sys_read, params);
> >   cookie2 = sys_async(sys_write, params);
> > 
> >   [ ... calculation loop ... ]
> > 
> >   wait_on_async_syscall(cookie1);
> >   wait_on_async_syscall(cookie2);
> > 
> > or something like that. Without user-space having to create threads 
> > itself, etc. So basically, we'd make kernel threads more useful, and 
> > we'd make threading safer - by only letting syscalls thread.
> 
> Since I still think that the many-thousands potential async operations 
> coming from network sockets are better handled with a classical event 
> machanism [1], and since smooth integration of new async syscall into the 
> standard POSIX infrastructure is IMO a huge win, I think we need to have a 
> "bridge" to allow async completions being detectable through a pollable 
> (by the mean of select/poll/epoll whatever) device.
> In that way you can handle async operations with the best mechanism that 
> is fit for them, and gather them in a single async scheduler.

To clarify further, below are the API and the use case of my userspace 
implementation. The guasi_fd() gives you back a pollable (POLLIN) fd to be 
integrated in your prefered event retrieval interface. Once it fd is 
signaled, you can fetch your completed requests using guasi_fetch() and 
schedule work based on that.
The GUASI implementation uses pthreads, but it is clear that an in-kernel 
async syscall implementation can take wiser decisions, and optimize the 
heck out of it (locks, queues, ...).




- Davide



/*
 * Example of async pread using GUASI
 */
static long guasi_wrap__pread(void *priv, long const *params) {

        return (long) pread((int) params[0], (void *) params[1],
                            (size_t) params[2], (off_t) params[3]);
}
 
guasi_req_t guasi__pread(guasi_t hctx, void *priv, void *asid, int prio,
                         int fd, void *buf, size_t size, off_t off) {

        return guasi_submit(hctx, priv, asid, prio, guasi_wrap__pread, 4,
                            (long) fd, (long) buf, (long) size, (long) off);
}


---
/*
 *  guasi by Davide Libenzi (generic userspace async syscall implementation)
 *  Copyright (C) 2003  Davide Libenzi
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *  Davide Libenzi <davidel@xmailserver.org>
 *
 */

#if !defined(_GUASI_H)
#define _GUASI_H


#define GUASI_MAX_PARAMS 16

#define GUASI_STATUS_PENDING 1
#define GUASI_STATUS_ACTIVE 2
#define GUASI_STATUS_COMPLETE 3


typedef long (*guasi_syscall_t)(void *, long const *);

typedef struct s_guasi { } *guasi_t;
typedef struct s_guasi_req { } *guasi_req_t;

struct guasi_reqinfo {
	void *priv;   /* Call private data. Passed to guasi_submit */
	void *asid;   /* Async request ID. Passed to guasi_submit */
	long result;  /* Return code of "proc" passed to guasi_submit */
	long error;   /* errno */
	int status;   /* GUASI_STATUS_* */
};



guasi_t guasi_create(int min_threads, int max_threads, int max_priority);
void guasi_free(guasi_t hctx);
int guasi_fd(guasi_t hctx);
guasi_req_t guasi_submit(guasi_t hctx, void *priv, void *asid, int prio,
			 guasi_syscall_t proc, int nparams, ...);
int guasi_fetch(guasi_t hctx, guasi_req_t *reqs, int nreqs);
int guasi_req_info(guasi_req_t hreq, struct guasi_reqinfo *rinf);
void guasi_req_free(guasi_req_t hreq);

#endif


