Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYJEXDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYJEXDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 19:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYJEXDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 19:03:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbYJEXDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 19:03:35 -0400
Date: Sun, 5 Oct 2008 19:02:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
In-Reply-To: <20081005153306.7e644c9f@infradead.org>
Message-ID: <Pine.LNX.4.64.0810051901190.31780@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
 <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
 <20080923154905.50d4b0fa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
 <20080923164623.ce82c1c2.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
 <20081001225404.4e973465.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com>
 <20081005153306.7e644c9f@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Oct 2008, Arjan van de Ven wrote:

> On Sun, 5 Oct 2008 18:14:50 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Fix starvation in memory management.
> > 
> > The bug happens when one process is doing sequential buffered writes
> > to a block device (or file) and another process is attempting to
> > execute sync(), fsync() or direct-IO on that device (or file). This
> > syncing process will wait indefinitelly, until the first writing
> > process finishes.
> > 
> > For example, run these two commands:
> > dd if=/dev/zero of=/dev/sda1 bs=65536 &
> > dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct
> > 
> > The bug is caused by sequential walking of address space in
> > write_cache_pages and wait_on_page_writeback_range: if some other
> > process is constantly making dirty and writeback pages while these
> > functions run, the functions will wait on every new page, resulting in
> > indefinite wait.
> 
> are you sure?
> isn't the right fix to just walk the file pages only once?

It walks the pages only once --- and waits on each on them. But because 
new pages are contantly appearing under it, that "walk only once" becomes 
infinite loop (well, finite, until the whole disk is written).

Mikulas
