Return-Path: <linux-kernel-owner+w=401wt.eu-S1030517AbXBGBPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517AbXBGBPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030518AbXBGBPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:15:08 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1253 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030517AbXBGBPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:15:06 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Feb 2007 17:15:02 -0800 (PST)
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
In-Reply-To: <20070207004443.GE32307@ca-server1.us.oracle.com>
Message-ID: <Pine.LNX.4.64.0702061658370.19136@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
 <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
 <20070206233907.GW32307@ca-server1.us.oracle.com>
 <Pine.LNX.4.64.0702061541590.19136@alien.or.mcafeemobile.com>
 <20070207000626.GC32307@ca-server1.us.oracle.com>
 <Pine.LNX.4.64.0702061612220.19136@alien.or.mcafeemobile.com>
 <20070207004443.GE32307@ca-server1.us.oracle.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, Joel Becker wrote:

> > - Is it more expensive to forcibly have to wait and fetch a result even 
> >   for in-cache syscalls, or it's faster to walk the submission array?
> 
> 	Not everything is in-cache.  Databases will be doing O_DIRECT
> and will expect that 90% of their I/O calls will block.  Why should they
> have to iterate this list every time?  If this is the API, they *have*
> to.  If there's an efficient way to get "just the ones that didn't
> block", then it's not a problem.

If that's what is wanted, then the async_submit() API can detect the 
syncronous completion soon, and drop a result inside the result-queue 
immediately. It means that an immediately following async_wait() will find 
some completions soon. Or:

struct async_submit {
        void *cookie;
        int sysc_nbr;
        int nargs;
        long args[ASYNC_MAX_ARGS];
};
struct async_result {
        void *cookie;
	long result:
};

int async_submit(struct async_submit *a, struct async_result *r, int n);

Where "r" will store the ones that completed syncronously. I mean, there 
are really many ways to do this.
I think ATM the core kernel implementation should be the focus, because 
IMO we just scratched the surface of the potential problems that something 
like this can arise (scheduling, signaling, cleanup, cancel - just to 
name a few).



- Davide


