Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbYFQNlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbYFQNlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 09:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYFQNkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 09:40:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545AbYFQNkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 09:40:52 -0400
Date: Tue, 17 Jun 2008 09:38:25 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Jens Axboe <jens.axboe@oracle.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Pavel Machek <pavel@suse.cz>, mtk.manpages@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080617093825.7a245f7f@bree.surriel.com>
In-Reply-To: <20080616215406.8f09e519.akpm@linux-foundation.org>
References: <20080530102619.GA2468@elf.ucw.cz>
	<Pine.LNX.4.64.0805301451020.19914@blonde.site>
	<20080530204307.GA4978@ucw.cz>
	<Pine.LNX.4.64.0805311925190.27293@blonde.site>
	<20080531173950.c4f04028.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806010752510.24919@blonde.site>
	<20080601011501.199af80c.akpm@linux-foundation.org>
	<20080601114008.GC16843@elf.ucw.cz>
	<20080601133727.4e62ae55.akpm@linux-foundation.org>
	<20080602114319.GI5757@kernel.dk>
	<Pine.LNX.4.64.0806021319250.16157@blonde.site>
	<20080616165351.1b2ff397@bree.surriel.com>
	<20080616215406.8f09e519.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 21:54:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > The problem with lots of CFQ requests is simpler.
> > 
> > If you look at balance_dirty_pages() you will see that it only
> > takes dirty and NFS unstable pages into account when checking
> > the dirty limit.  The pages that are in flight (under IO) are
> > not counted at all.
> 
> That would be totally busted.  All that nr_writeback logic in there is very
> much supposed to handle under-writeback pages?

Mmm, you are right.   It is counting the number of writeback
pages.

It just isn't waiting on them.  After moving enough pages from
dirty state to writeback state, it breaks out of the loop and
allows memory dirtying to continue.

                if (pages_written >= write_chunk)
                        break;          /* We've done our duty */

I wonder if we should wait for some IO to complete, or at least
do a simple congestion_wait() if the number of writeback pages
is very large?

-- 
All rights reversed.
