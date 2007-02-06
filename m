Return-Path: <linux-kernel-owner+w=401wt.eu-S965609AbXBFX4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609AbXBFX4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965614AbXBFX4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:56:18 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1217 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609AbXBFX4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:56:17 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Feb 2007 15:56:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Joel Becker <Joel.Becker@oracle.com>
cc: Kent Overstreet <kent.overstreet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070206233907.GW32307@ca-server1.us.oracle.com>
Message-ID: <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com>
References: <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
 <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
 <20070206233907.GW32307@ca-server1.us.oracle.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, Joel Becker wrote:

> On Tue, Feb 06, 2007 at 03:23:47PM -0800, Davide Libenzi wrote:
> > struct async_submit {
> > 	void *cookie;
> > 	int sysc_nbr;
> > 	int nargs;
> > 	long args[ASYNC_MAX_ARGS];
> > 	int async_result;
> > };
> > 
> > int async_submit(struct async_submit *a, int n);
> > 
> > And async_submit() can mark each one ->async_result with -EASYNC (syscall 
> > has been batched), or another code (syscall completed w/out schedule).
> > IMO, once you get a -EASYNC for a syscall, you *have* to retire the result.
> 
> 	There are pains here, though.  On every submit, you have to walk
> the entire vector just to know what did or did not complete.  I've seen
> this in other APIs (eg, async_result would be -EAGAIN for lack of
> resources to start this particular fibril).  Userspace submit ends up
> always walking the array of submissions twice - once to prep them, and
> once to check if they actually went async.  For longer lists of I/Os,
> this is expensive.

Async syscall submissions are a _one time_ things. It's not like a live fd 
that you can push inside epoll and avoid the multiple O(N) passes.
First of all, the amount of syscalls that you'd submit in a vectored way 
are limited. They do not depend on the total number of connections, but on 
the number of syscalls that you are actualy able to submit in parallel.
Note that it's not a trivial tasks to extract a long enough level of 
parallelism, that would make you feel pain in having to walk through the 
submission array. Think about the trivial web server case. Remote HTTP 
client asks one page, and you may think to batch a few ops together (like 
a stat, open, send headers, and sendfile for example), but those cannot be 
vectored since they have to complete in order. The stat would even trigger 
different response to the HTTP client. You need the open() fd to submit 
the send-headers and sendfile.
IMO there are no scalability problems in a multiple submission/retrieval 
API like the above (or any variation of it).



- Davide


