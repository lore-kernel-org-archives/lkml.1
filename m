Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZDNRyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZDNRyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZDNRxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:53:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48588 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZDNRxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:53:48 -0400
Date: Tue, 14 Apr 2009 19:51:24 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Zach Brown <zach.brown@oracle.com>,
       Andy Grover <andy.grover@oracle.com>
Subject: Re: [RFC][PATCH v3 2/6] mm, directio: fix fork vs direct-io race
	(read(2) side IOW gup(write) side)
Message-ID: <20090414175124.GC9809@random.random>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com> <20090414151652.C64D.A69D9226@jp.fujitsu.com> <20090414152500.C65F.A69D9226@jp.fujitsu.com> <x49ab6jyyiy.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ab6jyyiy.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 12:45:41PM -0400, Jeff Moyer wrote:
> So, if you're continuously submitting async read I/O, you will starve
> out the fork() call indefinitely.  I agree that you want to allow

IIRC rwsem good enough to stop the down_read when a down_write is
blocked. Otherwise page fault flood in threads would also starve any
mmap or similar call. Still with this approach fork will start to hang
indefinitely waiting for I/O, making it an I/O bound call, and not a
CPU call anymore, which may severely impact interactive-ness of
applications.

As long as fork is useful in the first place to provide memory
protection of different code with different
memory-corruption-trust-levels (otherwise nobody should use fork at
all, and vfork [or better spawn] should become the only option), then
fork from a thread pool is also reasonable. Either fork is totally
useless as a whole (which I wouldn't argue too much about), or if you
agree fork makes any sense, it can also make sense if intermixed with
clone(CLONE_VM) and hopefully it should behave CPU bound like CLONE_VM.
