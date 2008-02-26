Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbYBZQ2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbYBZQ2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762137AbYBZQ2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:28:38 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759903AbYBZQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:28:36 -0500
Date: Tue, 26 Feb 2008 08:27:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: =?ISO-8859-1?B?SvZybg==?= Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-Id: <20080226082725.b65365f0.akpm@linux-foundation.org>
In-Reply-To: <20080226150745.GA18118@shareable.org>
References: <20080226072649.GB30238@shareable.org>
	<20080225234319.f4589ae4.akpm@linux-foundation.org>
	<20080226075921.GG30238@shareable.org>
	<200802262016.11297.nickpiggin@yahoo.com.au>
	<20080226140925.GB20428@lazybastard.org>
	<20080226150745.GA18118@shareable.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 15:07:45 +0000 Jamie Lokier <jamie@shareable.org> wrote:

> SYNC_FILE_RANGE_WRITE scans all pages in the range, looking for dirty
> pages which aren't already queued for write-out.  It marks those with
> a "write-out" flag, and starts write I/Os at some unspecified time in
> the near future; it can be assumed writes for all the pages will
> complete eventually if there's no errors.  When I/O completes on a
> page, it cleans the page and also clears the write-out flag.
> 
> SYNC_FILE_RANGE_WAIT_AFTER waits until all pages in the range don't
> have the "write-out" flag set.
> 
> SYNC_FILE_RANGE_WAIT_BEFORE does the same wait, but before marking
> pages for write-out.  I don't actually see the point in this.  Isn't a
> preceding call with SYNC_FILE_RANGE_WAIT_AFTER equivalent, making
> BEFORE a redundant flag?

Consider the case of pages which are dirty but are already under writeout. 
ie: someone redirtied the page after someone started writing the page out. 
For these pages the kernel needs to

a) wait for the current writeout to complete

b) start new writeout

c) wait for that writeout to complete.

those are the three stages of sync_file_range().  They are independently
selectable and various combinations provide various results.

The reason for providing b) only (SYNC_FILE_RANGE_WRITE) is so that
userspace can get as much data into the queue as possible, to permit the
kernel to optimise IO scheduling better.

If you perform a) and b) together
(SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE) then you are guaranteed
that all data which was dirty when sync_file_range() executed will be sent
into the queue, but you won't get as much data into the queue if the kernel
encounters dirty, under-writeout pages.  This is especially hurtful if
you're trying to feed a lot of little segments into the queue.  In that
case perhaps userspace should do an asynchrnous pass
(SYNC_FILE_RANGE_WRITE) to stuff as much data as poss into the queue, then
a SYNC_FILE_RANGE_WAIT_AFTER pass then a
SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER
pass to clean up any stragglers.  WHich mode is best very much depends on
the application's file dirtying patterns.  One would have to experiment
with it, and tuning of sync_file_range() usage would occur alongside tuning
of the application's write() design.

It's an interesting problem, with potentially high payback.
