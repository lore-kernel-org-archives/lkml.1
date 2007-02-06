Return-Path: <linux-kernel-owner+w=401wt.eu-S1030585AbXBFXjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030585AbXBFXjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030588AbXBFXjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:39:37 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:24074 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030585AbXBFXjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:39:36 -0500
Date: Tue, 6 Feb 2007 15:39:07 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070206233907.GW32307@ca-server1.us.oracle.com>
Mail-Followup-To: Davide Libenzi <davidel@xmailserver.org>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com> <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com> <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com> <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org> <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com> <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com> <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org> <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com> <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever come to perfection.
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 03:23:47PM -0800, Davide Libenzi wrote:
> struct async_submit {
> 	void *cookie;
> 	int sysc_nbr;
> 	int nargs;
> 	long args[ASYNC_MAX_ARGS];
> 	int async_result;
> };
> 
> int async_submit(struct async_submit *a, int n);
> 
> And async_submit() can mark each one ->async_result with -EASYNC (syscall 
> has been batched), or another code (syscall completed w/out schedule).
> IMO, once you get a -EASYNC for a syscall, you *have* to retire the result.

	There are pains here, though.  On every submit, you have to walk
the entire vector just to know what did or did not complete.  I've seen
this in other APIs (eg, async_result would be -EAGAIN for lack of
resources to start this particular fibril).  Userspace submit ends up
always walking the array of submissions twice - once to prep them, and
once to check if they actually went async.  For longer lists of I/Os,
this is expensive.

Joel

-- 

"Too much walking shoes worn thin.
 Too much trippin' and my soul's worn thin.
 Time to catch a ride it leaves today
 Her name is what it means.
 Too much walking shoes worn thin."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
