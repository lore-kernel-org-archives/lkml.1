Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYJCDPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYJCDPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbYJCDPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:15:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbYJCDPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:15:08 -0400
Date: Thu, 2 Oct 2008 20:14:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: Re: [PATCH] Memory management livelock
Message-Id: <20081002201410.07afff73.akpm@linux-foundation.org>
In-Reply-To: <200810031259.17527.nickpiggin@yahoo.com.au>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<200810031232.23836.nickpiggin@yahoo.com.au>
	<20081002194034.7957bccb.akpm@linux-foundation.org>
	<200810031259.17527.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 12:59:17 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Friday 03 October 2008 12:40, Andrew Morton wrote:
> > On Fri, 3 Oct 2008 12:32:23 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
> > > > yup, that's pretty much unfixable, really, unless new locks are added
> > > > which block threads which are writing to unrelated sections of the
> > > > file, and that could hurt some workloads quite a lot, I expect.
> > >
> > > Why is it unfixable? Just ignore nr_to_write, and write out everything
> > > properly, I would have thought.
> >
> > That can cause fsync to wait arbitrarily long if some other process is
> > writing the file.
> 
> It can be fixed without touching non-fsync paths (see my next email for
> the way to fix it without touching fastpaths).
> 

yup.

> 
> > This happens. 
> 
> What does such a thing?

I forget.  People do all sorts of weird stuff.

> It would have been nicer to ask them to not do
> that then, or get them to use range syncs or something. Now that's much
> harder because we've accepted the crappy workaround for so long.
> 
> It's far far worse to just ignore data integrity of fsync because of the
> problem. Should at least have returned an error from fsync in that case,
> or make it interruptible or something.

If a file has one dirty page at offset 1000000000000000 then someone
does an fsync() and someone else gets in first and starts madly writing
pages at offset 0, we want to write that page at 1000000000000000. 
Somehow.

I expect there's no solution which avoids blocking the writers at some
stage.
