Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZJJGkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZJJGkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 02:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZJJGkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 02:40:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZJJGkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 02:40:46 -0400
Date: Fri, 9 Oct 2009 23:39:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org,
       Timo Sirainen <tss@iki.fi>
Subject: Re: [resend][PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Message-Id: <20091009233935.1be0edf9.akpm@linux-foundation.org>
In-Reply-To: <2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com>
References: <20091009134354.12A7.A69D9226@jp.fujitsu.com>
	<20091009171344.3fc5f28b.akpm@linux-foundation.org>
	<3e8340490910091922g7891b31al649e91f15ffae687@mail.gmail.com>
	<20091009194250.eb76e338.akpm@linux-foundation.org>
	<3e8340490910091957t21eb16e0r63eba2314ddb83a8@mail.gmail.com>
	<2f11576a0910092332s6e0e3dcs35864e3a2164be0@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009 15:32:35 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> >>> The solution is to use the seqlock to detect this, and prevent the
> >>> secret information from ever making it back to process B's userspace.
> >>> Note that it's not enough to just recheck arg_start, as process A may
> >>> reassign the proctitle area back to its original position after having
> >>> it somewhere else for a while.
> >>
> >> Well seqlock is _a_ solution. __Another is to use a mutex or an rwsem
> >> around the whole operation.
> >>
> >> With the code as you propose it, what happens if a process sits in a
> >> tight loop running setproctitle? __Do other processes running `ps' get
> >> stuck in a livelock until the offending process gets scheduled out?
> >
> > It does seem like a maximum spin count should be put in there - and
> > maybe a timeout as well (since with FUSE etc it's possible to engineer
> > page faults that take arbitrarily long).
> > Also, it occurs to me that:
> 
> makes sense.
> I like maximum spin rather than timeout.

Start simple.  What's wrong with mutex_lock() on the reader and writer
sides?  rwsems might be OK too.

In both cases we should think about whether persistent readers can
block the writer excessively though.
